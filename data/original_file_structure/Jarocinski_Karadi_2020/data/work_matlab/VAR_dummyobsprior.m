function result = VAR_dummyobsprior(y, w, n_draws, info, varargin)
% result = VAR_dummyobsprior(y,w,n_draws,info);
% PURPOSE: inference in a VAR with dummy observations prior (conjugate prior)
% 
% The VAR model with parameters B,Sigma is
%   Y = X B + U
% where X = [ lagged Y's, W ] and each row of U is N(0,Sigma).
%
% The kernel of the prior p(B,Sigma) is:
% |Sigma|^{-0.5*(vprior + K + N + 1)}exp(-0.5tr(Yprior - Xprior*B)'((Yprior - Xprior*B)Sigma^-1)
% note that if vprior > N-1 then this prior is proper and satisfies
% p(B,Sigma) = p(B|Sigma) x p(Sigma) where
% p(B|Sigma) = N(Bprior,kron(Sigma,Qprior)), p(Sigma) = IW(Sprior,vprior)
% where 
% Bprior = inv(Xprior'Xprior)*Xprior'Yprior,
% Qprior = inv(Xprior'Xprior), Sprior = (Yprior - Xprior*Bprior)'(Yprior - Xprior*Bprior)
%
% INPUTS:
% y - data on endogenous variables
% w - data on exogenous variables (the same number of observations as y)
% n_draws - number of MC draws from the posterior
% info - struct with various options of the estimation
% varargin (optional) - verbosity - controls much printout, default=1
%
% DESCRIPTION OF info:
%
% compulsory field:
% info.lags - number of lags
%
% optional fields:
% info.dummyobs - settings of a dummy observations prior constructed outside
%  or
% info.minnesota - settings of the Minnesota prior
% info.simsdummy - settings of the Sims' dummy observation priors
% info.trspl - settings of the training sample prior
%
% description of optional fields:
% 
% info.dummyobs should be a struct with fields
%  info.dummyobs.Y, info.dummyobs.X, info.dummyobs.v - parameters of
%  |Sigma|^-0.5(v + K + N + 1) exp(-0.5(Y - X*B)'(Y - X*B)Sigma^-1)
%
% example of the info.minnesota struct:
% info.minnesota.mvector = [1 1 0 1 0 0]; % means of own lags
% info.minnesota.tightness = 0.2;
% info.minnesota.decay = 1;
% info.minnesota.sigma_deg = N+2; % degrees of freedom of p(Sigma)
%   p(Sigma) = IW(S,sigma_deg)
%   need sigma_deg > N-1 for the prior to be proper
%   need sigma_deg > N+1 for the E(Sigma) to exist
%   optional, default: sigma_deg = N+2
% 
% example of the info.simsdummy struct:
% info.simsdummy.oneunitroot = 1; % weight of the one-unit-root prior
% ... etc. for oneunitrootc, oneunitrooty, nocointegration
% see Sims (2006) 'CONJUGATE DUMMY OBSERVATION PRIORS FOR VAR’S'
%
% structure of the info.trspl array of structs:
% info.trspl(i).y - training sample data, Ttr x N
% info.trspl(i).Tsubj - subjective size of the training sample, <=>Ttr
%
% RETURNS: result - struct with various posterior results
% result.Y - data, left-hand-side
% result.X - data, right-hand-side
% result.Y0 - data, initial observations
% result.prior.Yprior - dummy observations implementing the prior, left-hand-side
% result.prior.Xprior - dummy observations implementing the prior, right-hand-side
% result.prior.vprior - degrees of freedom of the Sigma prior
% result.logdensy - log marginal likelihood
% result.lags - number of lags in the VAR
% result.beta - posterior mean of the reduced form VAR parameters, K by N
% result.sigma - posterior mean of the reduced form error variance, N by N
% result.beta_draws - draws of beta from the posterior, K by N by n_draws
% result.sigma_draws - draws of sigma from the posterior, N by N by n_draws
% 
% DEPENDS: -
% SUBFUNCTIONS: varlags, multgammaln
% 
% Marek Jarocinski 2011-September, 2011-December eliminated stats/iwishrnd
% 2012-March added optional field minnesota.sigma_data
% 2013-April changed intepretation of sigma_deg
% 2013-October replaced 'inv' with '/' in the posterior simulation
% 2013-November added result.v
% 2013-December added result.ynames
% 2014-February optional Sigma prior dynare style (triggered by sigma_omega)
% 2014-March report the sample
% 2014-September no attempt to compute logdensy when prior is improper

[T,N] = size(y); % T is the length of the whole sample (including initial observations)
P = info.lags;
T = T-P; % now T is the length of the effective sample
K = P*N+size(w,2); % number of columns in X

if isempty(varargin)
    verbosity = 1;
else
    verbosity = varargin{1};
end

if verbosity
    disp(' ')
    disp('VAR_dummyobsprior')
    disp(['lags: ' num2str(info.lags)])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONSTRUCTION OF Yprior, Xprior, vprior FROM THE SUPPLIED info

% If Yprior, Xprior, vprior constructed outside of this function are
% supplied, then just copy the values.
% If not, then build Yprior, Xprior, vprior from the supplied
% hyperparameters.
if isfield(info,'dummyobs') % used supplied values
    Yprior = info.dummyobs.Y;
    Xprior = info.dummyobs.X;
    vprior = info.dummyobs.v;
else % build Yprior, Xprior, vprior from hyperparameters
    Yprior = [];
    Xprior = [];

    % Minnesota prior
    if isfield(info,'minnesota') && isfield(info.minnesota,'tightness')
        % default values if something not supplied
        if ~isfield(info.minnesota,'exog_std')
            info.minnesota.exog_std = 1e5;
        end
        if ~isfield(info.minnesota,'decay')
            info.minnesota.decay = 1;
        end

        if ~isfield(info.minnesota,'sigma')
            % compute sigma = standard errors from univariate autoregressions
            if ~isfield(info.minnesota,'sigma_data')
                % sigma is computed from univariate autoregressions on sigma_data
                % default: sigma_data is identical to the actual sample
                info.minnesota.sigma_data = y;
            end
            info.minnesota.sigma = zeros(1,N);
            if ~isfield(info.minnesota,'sigma_arlags')
                info.minnesota.sigma_arlags = ...
                    max(0,min(P, size(info.minnesota.sigma_data,1)-3)); 
                % when a very short sample is supplied use fewer lags
            end
            for n = 1:N
                yn = info.minnesota.sigma_data(:,n);
                [yn, ylagsn] = varlags(yn,info.minnesota.sigma_arlags);
                Xn = [ylagsn ones(size(yn))];
                bn = Xn \ yn;
                info.minnesota.sigma(n) = std(yn - Xn*bn);
            end
        end
        if isfield(info.minnesota,'sigma_factor')
            info.minnesota.sigma = info.minnesota.sigma .* info.minnesota.sigma_factor;
        end

        % prior for the coefficients
        % p(B|Sigma) = N(B0,Sigma ** Q )
        % decompose Q = W*W'
        % to implement the prior need dummy observations with
        % Yd = inv(W)*B0      Xd = inv(W)
        if ~isinf(info.minnesota.tightness)
            Winv = (1:P).^info.minnesota.decay;
            Winv = kron(Winv, info.minnesota.sigma ./ info.minnesota.tightness);
            Winv = [Winv, info.minnesota.exog_std^(-1)*ones(1,size(w,2)) ];
            Winv = diag(Winv);

            B0 = zeros(K,N);
            if ~isfield(info.minnesota,'mvector')
                info.minnesota.mvector = ones(1,N);
            elseif (length(info.minnesota.mvector) > N)
                warning('Minnesota prior: mvector too long, truncating'); %#ok<WNTAG>
            end
            B0(1:N,1:N) = diag(info.minnesota.mvector(1:N));

            Yprior = [Yprior; Winv*B0];
            Xprior = [Xprior; Winv];
        end
        
        % prior for the variance
        % p(Sigma) = IW(Sprior,vprior)
        % decompose Sprior = Z*Z'
        % to implement the prior need dummy observations with
        % Yd = Z'   Xd = 0
        % plus an improper prior
        % p(Sigma) = |Sigma|^-0.5(vprior+1)

        % default: vprior = N + 2
        if ~isfield(info.minnesota,'sigma_deg') 
            info.minnesota.sigma_deg = N + 2;
        end

        % Z = diag(sigma)*sqrt(vprior - N - 1)
        % this choice of Z ensures that 
        % E(Sigma) = Z*Z' / (vprior - N - 1) = diag(sigma.^2)
        if info.minnesota.sigma_deg == N + 1
            YSigma = diag(info.minnesota.sigma);
        else
            YSigma = diag(info.minnesota.sigma*sqrt(info.minnesota.sigma_deg - N - 1));
        end
        
        % if sigma_omega is specified, then override sigma_deg and YSigma
        % with the Dynare-style specification
        if isfield(info.minnesota,'sigma_omega')
            info.minnesota.sigma_deg = N*info.minnesota.sigma_omega + N;
            YSigma = diag(info.minnesota.sigma*sqrt(info.minnesota.sigma_omega));
        end

        Yprior = [Yprior; YSigma];
        Xprior = [Xprior; zeros(N,K)];

        if verbosity
            disp('Minnesota prior');
            disp(['Note: for a proper prior need sigma_deg > ' num2str(N-1)])
            disp(['Note: for E(Sigma) to exist need sigma_deg > ' num2str(N+1)])
            disp(info.minnesota)
        end
    end

    % Sims' dummy observations
    if isfield(info,'simsdummy')
        ybar = mean(y(1:P,:),1);
        if isfield(info.simsdummy,'oneunitroot') && info.simsdummy.oneunitroot>0
            Xprior = [Xprior; repmat(ybar,1,P)*info.simsdummy.oneunitroot, info.simsdummy.oneunitroot*w(P,:)];
            Yprior = [Yprior; ybar*info.simsdummy.oneunitroot];
        end
        if isfield(info.simsdummy,'oneunitrootc') && info.simsdummy.oneunitrootc>0
            Xprior = [Xprior; zeros(1,P*N) info.simsdummy.oneunitrootc*w(P,:)];
            Yprior = [Yprior; zeros(1,N)];
        end
        if isfield(info.simsdummy,'oneunitrooty') && info.simsdummy.oneunitrooty>0
            Xprior = [Xprior; repmat(ybar,1,P)*info.simsdummy.oneunitrooty 0*w(P,:)];
            Yprior = [Yprior; ybar*info.simsdummy.oneunitrooty];
        end
        if isfield(info.simsdummy,'nocointegration') && info.simsdummy.nocointegration(1)>0                
            temp = diag(ybar.*info.simsdummy.nocointegration);
            if isfield(info,'minnesota') && isfield(info.minnesota,'mvector')
                temp = temp(logical(info.minnesota.mvector),:);
            end
            Xprior = [Xprior; repmat(temp,1,P) zeros(size(temp,1),size(w,2))];
            Yprior = [Yprior; temp];
        end
        if verbosity
            disp('Sims dummy prior')
            disp(info.simsdummy)
        end
    end
    
    % determine the prior degrees of freedom of Sigma (vprior)
    if isfield(info,'minnesota')
        vprior = info.minnesota.sigma_deg;
    else
        % when no Minnesota prior, then 
        % a) assume the noninformative prior |Sigma|^-(N+1)/2
        % b) treat Sims dummy obs, if any, as a training sample
        vprior = size(Yprior,1) - K; % note that we lose K degrees of freedom because of B
    end
end

% add training sample prior
if isfield(info,'trspl') && numel(info.trspl)>0
    for i = 1:numel(info.trspl)
        if isfield(info.trspl(i),'y') && isfield(info.trspl(i),'Tsubj') && info.trspl(i).Tsubj>0
            [Ytr, Xtr] = varlags(info.trspl(i).y, P);
            Xtr = [Xtr info.trspl(i).w(P+1:end,:)]; % add the exogenous variable
            Ytr = Ytr * sqrt(info.trspl(i).Tsubj / size(Ytr,1)); % scaling
            Xtr = Xtr * sqrt(info.trspl(i).Tsubj / size(Ytr,1)); % scaling
            % add the training sample info to vprior, Yprior, Xprior
            vprior = vprior + info.trspl(i).Tsubj;
            Yprior = [Yprior; Ytr];
            Xprior = [Xprior; Xtr];
            if verbosity
                disp('Training sample prior');
                disp(info.trspl(i))
            end
        end
    end
end

% store the names of the variables if supplied
if isfield(info,'ynames'), result.ynames = info.ynames; end

% store the dummy observations
result.prior.info = info;
result.prior.Yprior = Yprior;
result.prior.Xprior = Xprior;
result.prior.vprior = vprior;

% actual data matrices
[Y,X] = varlags(y,P);
X = [X w(P+1:end,:)]; % add the exogenous variables
result.Y = Y;
result.X = X;
result.Y0 = y(1:P,:);
result.v = T + vprior;

% stacked data
Yst = [Yprior; Y];
Xst = [Xprior; X];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MARGINAL LIKELIHOOD
% some quantities from the prior
logdetXtXprior = log(det(Xprior'*Xprior));
Bprior = Xprior\Yprior;
Uprior = Yprior - Xprior * Bprior;
Sprior = Uprior'*Uprior;
logdetSprior = log(det(Sprior));
% some quantities from the stacked data
logdetXtXst = log(det(Xst'*Xst));
Bst = Xst\Yst;
Ust = Yst - Xst*Bst;
Sst = Ust'*Ust;
logdetSst = log(det(Sst));

if verbosity
    disp(['Prior degrees of freedom of Sigma: ' num2str(vprior)])
end
if vprior<=(N-1)
    disp('Prior for Sigma is improper!')
    result.logdensy = NaN;
else
    result.logdensy = -0.5*N*T*log(pi) + 0.5*N*(logdetXtXprior - logdetXtXst) + ...
        multgammaln(N,0.5*(T+vprior)) - multgammaln(N,0.5*vprior) + ...
        0.5*vprior*logdetSprior - 0.5*(T+vprior)*logdetSst;
end

if verbosity
    disp(['Sample with T = ' num2str(T) ' and N = ' num2str(N) '.'])
    disp(['Y(1,1) = ' num2str(Y(1,1)) '; Y(T,N) = ' num2str(Y(T,N))])
    disp(['Log marginal likelihood: ' num2str(result.logdensy)])
end

% entropy of the prior
% part1 = (K + vprior)*N/2 + K*N/2*log(2*pi) + multgammaln(N,vprior/2);
% part2 = -N/2*logdetXtXprior + (K + N + 1)/2*log(det(0.5*Sprior));
% part3 = - (K + vprior + N + 1)/2*sum(psi(0.5*(vprior - N + (1:N))));
% result.priorentropy = part1 + part2 + part3;
% if verbosity
%     disp(['Entropy of the prior: ' num2str(result.priorentropy)])
% end


% store results
result.beta = Bst; % posterior mean of B
result.sigma = Sst/(T+vprior-N-1); % posterior mean of Sigma
result.lags = P;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% POSTERIOR SIMULATION
if n_draws>0
    % some quantities used repeatedly in the simulation
    df = round(T + vprior); % posterior degrees of freedom
    %XtXstinv_chol = chol(inv(Xst'*Xst))';
    XtXstinv_chol = chol((Xst'*Xst)\eye(K))';
    Sst_chol = chol(Sst)';
    % allocate space for the posterior draws
    result.beta_draws = nan(K,N,n_draws);
    result.sigma_draws = nan(N,N,n_draws);
    % drawing from the posterior
    for draw = 1:n_draws;
        % draw Sigma from IW(Sst, df)
        temp = randn(df, N);
        Sigma_draw = Sst_chol/(temp'*temp)*Sst_chol';
        % draw B from N(Bst, kron(Sigma_draw, XtXst))
        B_draw = Bst + XtXstinv_chol*randn(K,N)*chol(Sigma_draw);
        % store
        result.beta_draws(:,:,draw) = B_draw;
        result.sigma_draws(:,:,draw) = Sigma_draw;
    end;
end

end % of VAR_dummyobsprior


% SUBFUNCTIONS
function res = multgammaln(N,a)
% evaluates log of the N-dimensional multivariate Gamma function, defined:
% pi^{N(N-1)/4} \prod_{n=1}^N \Gamma ((2a+1-n)/2) 
nlst = 1:N ;
v1n2 = (2*a+1-nlst)/2 ;
gamln = gammaln(v1n2) ;
sumgamln = sum(gamln) ;
res = 0.25*N*(N-1)*log(pi) + sumgamln;
end

function [ynew,ylags] = varlags(y,P)
[T,N] = size(y);
ynew = y(P+1:end,:);
ylags = zeros(T-P,P*N);
for p = 1:P
    ylags(:,N*(p-1)+1:N*p) = y(P+1-p:T-p,:);
end
end

