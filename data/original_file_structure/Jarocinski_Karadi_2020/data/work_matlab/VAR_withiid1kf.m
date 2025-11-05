function result = VAR_withiid(data, prior, gssettings, printout)
% result = VAR_withiid(data, prior, gssettings, printout)
% PURPOSE: inference in a VAR with some i.i.d. variables
%
% The VAR model with parameters B,Sigma is
%   M = Um
%   Y = X B + Uy
% where X = [ lagged M's and Y's, W ] and each row of U is N(0,Sigma).
%
% INPUTS:
% data - structure with variables
% data.y - T x Ny data on endogenous variables
% data.m - T x Nm data on i.i.d variables (the same number of observations as y)
% data.w - T x Nw data on exogenous variables (the same number of observations as y)
% data.names - cell array with names of the variables, m first, y second
% prior - structure with prior hyperparameters + n. of lags
% gssettings - settings of the Gibbs sampler
% printout (optional) - controls much printout, default=1
%
% DESCRIPTION OF prior:
%
% compulsory field:
% prior.lags - number of lags
%
% prior.minnesota - settings of the Minnesota prior
% example of the prior.minnesota struct:
% prior.minnesota.mvector = [1 1 0 1 0 0]; % means of own lags
% prior.minnesota.tightness = 0.2;
% prior.minnesota.decay = 1;
% prior.minnesota.sigma_deg = N+2; % degrees of freedom of p(Sigma)
%   p(Sigma) = IW(S,sigma_deg)
%   need sigma_deg > N-1 for the prior to be proper
%   need sigma_deg > N+1 for the E(Sigma) to exist
%   optional, default: sigma_deg = N+2
%
% RETURNS: result - struct with various posterior results
% result.data - data
% result.prior - prior
% result.logdensy - log marginal likelihood
% result.beta - posterior mean of the reduced form VAR parameters, K by N
% result.sigma - posterior mean of the reduced form error variance, N by N
% result.beta_draws - draws of beta from the posterior, K by N by ndraws
% result.sigma_draws - draws of sigma from the posterior, N by N by ndraws
% result.dens_draws - ndraws by 2, where:
%             the first column contains log prior p(B,Sigma) for each draw
%             the second column contains loglikelihod for each draw
%
% DEPENDS: kfsim_nan_VAR->kfsim_nan, MLMGD_VARwithiid->MLMGD
% SUBFUNCTIONS: varlags, multgammaln, logdet
%
% Marek Jarocinski 2016-Jul; 2016-Sep; 2017-Jun;
% 2019-Jan - marginal likelihood

[T,N] = size(data.y); % T is the length of the whole sample (including initial observations)
[Tw,Nw] = size(data.w); if Tw~=T, error('y and w have different lengths'), else clear Tw, end
Nm = prior.Nm;
Ny = N - Nm;
P = prior.lags;
T = T-P; % now T is the length of the effective sample
n_m = 1:Nm; n_y = Nm+(1:Ny);
K = P*N+Nw; % number of columns in X

if nargin<4, printout = 1; end

if printout
    disp(' ')
    disp(mfilename)
    disp(['lags: ' num2str(prior.lags)])
end

if ~isfield(gssettings,'saveevery'), gssettings.saveevery = 1; end
if ~isfield(gssettings,'waitbar'), gssettings.waitbar = 1; end
if ~isfield(gssettings,'computemarglik'), gssettings.computemarglik = 0; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% construct the prior from the supplied prior hyperparameters
% Minnesota prior
if isfield(prior,'minnesota') && isfield(prior.minnesota,'tightness')
    % default values if something not supplied
    if ~isfield(prior.minnesota,'exog_std')
        prior.minnesota.exog_std = 1e5;
    end
    if ~isfield(prior.minnesota,'decay')
        prior.minnesota.decay = 1;
    end
    
    if ~isfield(prior.minnesota,'sigma')
        % compute sigma = standard errors from univariate autoregressions
        if ~isfield(prior.minnesota,'sigma_data')
            % sigma is computed from univariate autoregressions on sigma_data
            % default: sigma_data is identical to the actual sample
            prior.minnesota.sigma_data = data.y;
        end
        prior.minnesota.sigma = zeros(1,N);
        if ~isfield(prior.minnesota,'sigma_arlags')
            prior.minnesota.sigma_arlags = ...
                max(0,min(P, size(prior.minnesota.sigma_data,1)-3));
            % when a very short sample is supplied use fewer lags
        end
        for n = 1:N
            yn = prior.minnesota.sigma_data(:,n); yn = yn(~isnan(yn));
            [yn, ylagsn] = varlags(yn,prior.minnesota.sigma_arlags);
            Xn = [ylagsn ones(size(yn))];
            bn = Xn \ yn;
            prior.minnesota.sigma(n) = std(yn - Xn*bn);
        end
    else
        prior.minnesota.sigma = prior.minnesota.sigma(:)'; % ensure sigma is a row vector
    end
    if isfield(prior.minnesota,'sigma_factor')
        prior.minnesota.sigma = prior.minnesota.sigma .* prior.minnesota.sigma_factor;
    end
    
    % prior for the coefficients
    % p(B|Sigma) = N( vecB0, Q0 )
    if ~isinf(prior.minnesota.tightness)
        temp1 = kron(((1:P)').^-prior.minnesota.decay, ones(N,N)); % p^-d
        temp2 = repmat(prior.minnesota.sigma,P*N,1); % sigma_i
        temp3 = repmat(prior.minnesota.sigma'.^-1,P,N); % /sigma_j
        Q0 = prior.minnesota.tightness*temp1.*temp2.*temp3;
        Q0 = [Q0; repmat(prior.minnesota.exog_std,1,N)]; % this assumes there is only constant term in w
        Q0 = Q0.^2;
        Q0(:,1:Nm) = []; % drop the equations for m
        prior.Q = spdiags(Q0(:),0,K*Ny,K*Ny);
        prior.Qinv = spdiags(Q0(:).^-1,0,K*Ny,K*Ny);
        
        prior.B = zeros(K,N);
        if ~isfield(prior.minnesota,'mvector')
            prior.minnesota.mvector = ones(1,N);
        elseif (length(prior.minnesota.mvector) > N)
            warning('Minnesota prior: mvector too long, truncating'); %#ok<WNTAG>
        elseif length(prior.minnesota.mvector)==Ny
            prior.minnesota.mvector = [zeros(Nm,1); prior.minnesota.mvector(:)];
        end
        prior.B(1:N,1:N) = diag(prior.minnesota.mvector(1:N));
        prior.B(:,1:Nm) = []; % drop the equations for m
        prior.QinvB_reshaped = reshape(prior.Qinv*prior.B(:), K, Ny);
    end
    
    % Sims' dummy observations
    if isfield(prior,'simsdummy')
        if ~isfield(prior.simsdummy,'oneunitroot') prior.simsdummy.oneunitroot = 0; end
        if ~isfield(prior.simsdummy,'oneunitrootc') prior.simsdummy.oneunitrootc = 0; end
        if ~isfield(prior.simsdummy,'oneunitrooty') prior.simsdummy.oneunitrooty = 0; end
        if ~isfield(prior.simsdummy,'nocointegration') prior.simsdummy.nocointegration = 0; end
        if prior.simsdummy.oneunitroot || prior.simsdummy.oneunitrootc || prior.simsdummy.oneunitrooty || any(prior.simsdummy.nocointegration)
            ybar = [zeros(1,Nm) mean(data.y(1:P,Nm+1:end),1)]; Xprior = []; Yprior = [];
            if prior.simsdummy.oneunitroot
                Xprior = [Xprior; repmat(ybar,1,P)*prior.simsdummy.oneunitroot, prior.simsdummy.oneunitroot*data.w(P,:)];
                Yprior = [Yprior; ybar*prior.simsdummy.oneunitroot];
            end
            if prior.simsdummy.oneunitrootc
                Xprior = [Xprior; zeros(1,P*N) prior.simsdummy.oneunitrootc*data.w(P,:)];
                Yprior = [Yprior; zeros(1,N)];
            end
            if prior.simsdummy.oneunitrooty
                Xprior = [Xprior; repmat(ybar,1,P)*prior.simsdummy.oneunitrooty 0*data.w(P,:)];
                Yprior = [Yprior; ybar*prior.simsdummy.oneunitrooty];
            end
            if any(prior.simsdummy.nocointegration)
                temp = diag(ybar.*prior.simsdummy.nocointegration);
                if isfield(prior,'minnesota') && isfield(prior.minnesota,'mvector')
                    temp = temp(logical(prior.minnesota.mvector),:);
                end
                Xprior = [Xprior; repmat(temp,1,P) zeros(size(temp,1),size(data.w,2))];
                Yprior = [Yprior; temp];
            end
            % we will only add dummy observation priors to the equations for y,
            % so prepare a 'Sigmayinv' that only corresponds to y
            tempSigmayinv = prior.minnesota.sigma.^-1; tempSigmayinv(1:Nm) = []; tempSigmayinv = diag(tempSigmayinv);
            prior.simsdummy.Qinv = kron(tempSigmayinv,Xprior'*Xprior);
            prior.simsdummy.QinvB_reshaped = Xprior'*Yprior(:,Nm+1:end)*tempSigmayinv;
            prior.Qinv = prior.Qinv + prior.simsdummy.Qinv;
            prior.QinvB_reshaped = prior.QinvB_reshaped + prior.simsdummy.QinvB_reshaped;
            % update prior.Q and prior.B so they remain consistent
            prior.Q = prior.Qinv\eye(Ny*K);
            prior.B = reshape(prior.Q*prior.QinvB_reshaped(:),K,Ny);
        end
    end
    
    % prior for the variance
    % p(Sigma) = IW(Sprior,vprior)
    if ~isfield(prior,'v')
        prior.v = N + 2;
    end    
    prior.S = diag(prior.minnesota.sigma.^2*(prior.v - N - 1));

    if printout
        disp('Minnesota prior');
        disp(['Note: for a proper prior need sigma_deg > ' num2str(N-1)])
        disp(['Note: for E(Sigma) to exist need sigma_deg > ' num2str(N+1)])
        disp(prior.minnesota)
        if isfield(prior,'simsdummy'), disp(prior.simsdummy); end
        disp(prior)
    end
end
% store the prior
result.prior = prior;

% if initial values of m are missing, replace with zeros
temp = data.y(1:P,1:Nm); temp(isnan(temp)) = 0; data.y(1:P,1:Nm) = temp;

% prepare data matrices
[Y,X] = varlags(data.y,P);
X = [X data.w(P+1:end,:)]; % add the exogenous variables
result.Y = Y;
result.X = X;
result.Y0 = data.y(1:P,:);
result.lags = P;
result.Nm = Nm;
nnans = sum(sum(isnan(data.y)));
if printout
    disp(['Sample with T = ' num2str(T) ' and N = ' num2str(N) '.'])
    disp(['Y(1,1) = ' num2str(Y(1,1)) '; Y(T,N) = ' num2str(Y(T,N))])
    disp(['Number of missing values: ' num2str(nnans)])
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% POSTERIOR SIMULATION
if gssettings.ndraws
    
    % starting values
    BB = [zeros(K,Nm) reshape(prior.B(:) + 1e-2*chol(prior.Q)'*randn(K*Ny,1), K, Ny)];
    % temp = randn(prior.v, N);
    % Sigma = chol(prior.S)'/(temp'*temp)*chol(prior.S);
    Sigma = prior.S/(prior.v - N - 1);
    
    result.v = round(T + prior.v);
    
    % simulation length - derived from burnin, ndraws, saveevery
    ndraws = gssettings.ndraws;
    nalldraws = gssettings.burnin + ndraws * gssettings.saveevery;
    
    % allocate space for the posterior draws
    result.beta_draws = nan(K,N,ndraws);
    result.sigma_draws = nan(N,N,ndraws);
    result.Y_draws = nan(T,N,ndraws);
    result.X_draws = nan(T,K,ndraws);
    result.dens_draws = nan(ndraws,2);
    
    % integrating constants
    logpriorBconst = -0.5*K*Ny*log(2*pi) -0.5*logdet(prior.Q);
    logpriorSigmaconst = -0.5*prior.v*N*log(2) -multgammaln(N,prior.v/2) +0.5*prior.v*logdet(prior.S);
    
    % last preparations
    it_save = 0;
    if isfield(gssettings,'waitbar') && gssettings.waitbar, waitbar_handle = waitbar(0,'Gibbs sampler','Name','Gibbs sampler running'); end
    timing_start = now;
    disp(['start: ',datestr(timing_start,0), '; total iterations: ', num2str(nalldraws)])
    
    % Gibbs sampler
    for draw = 1:nalldraws
        
        if nnans % draw missing data
            ydraw = kfsim_nan_VAR(data.y, BB, Sigma, 2);
            Y(isnan(result.Y)) = ydraw(isnan(result.Y)); % substitute only missing data
            [Y, Ylags] = varlags([result.Y0; Y], P);
            X = [Ylags data.w(P+1:end,:)];
        end
        
        % draw Sigma
        U = Y - X*BB;
        Spost = U'*U + prior.S;
        Spost_chol = chol(Spost)';
        temp = randn(result.v, N);
        Sigma = Spost_chol/(temp'*temp)*Spost_chol';

        
        % draw B
        Csig = chol(Sigma,'lower');
        SigmaYY1inv = Csig(n_y,n_y)'\(Csig(n_y,n_y)\eye(Ny));
        A = prior.Qinv + kron(SigmaYY1inv, X'*X);
        yst = Y(:,n_y) - Y(:,n_m)/Csig(n_m,n_m)'*Csig(n_y,n_m)';
        a = prior.QinvB_reshaped + X'*yst*SigmaYY1inv;
        C = chol(A);
        B = C \ (C'\a(:) + randn(K*Ny,1)); % use Chan (2015) formula
        BB = [zeros(K,Nm) reshape(B, K, Ny)];
        
        % report progress
        if gssettings.waitbar && ~rem(draw,gssettings.saveevery*10)
            waitbar(draw/nalldraws, waitbar_handle, timing_message(draw, nalldraws, timing_start))
        end
        % save current iteration if appropriate
        if draw>gssettings.burnin && ~rem(draw,gssettings.saveevery)
            it_save = it_save + 1;
            
            % store draws
            result.beta_draws(:,:,it_save) = BB;
            result.sigma_draws(:,:,it_save) = Sigma;
            %result.resid_draws(:,:,it_save) = U;
            result.Y_draws(:,:,it_save) = Y;
            result.X_draws(:,:,it_save) = X;
            
            % store logprior and loglik
            if gssettings.computemarglik
                if nnans
                    [temp, vloglik] = kfsim_nan_VAR(data.y, BB, Sigma, 0);
                    loglik = sum(vloglik(:));
                else
                    loglik = -0.5*N*T*log(2*pi) -0.5*T*logdet(Sigma) -0.5*trace(Sigma\(Y-X*BB)'*(Y-X*BB));
                end
                temp = BB(:,Nm+1:end) - prior.B;
                logpriorB = logpriorBconst - 0.5*temp(:)'*prior.Qinv*temp(:);
                logpriorSigma = logpriorSigmaconst - 0.5*(prior.v+N+1)*logdet(Sigma) - 0.5*trace(Sigma\prior.S);
                result.dens_draws(it_save,:) = [logpriorB + logpriorSigma, loglik];
            end
        end
    end
    if gssettings.waitbar, close(waitbar_handle), end
    disp(timing_message(draw, nalldraws, timing_start))
    if gssettings.computemarglik
        result.logdensy = MLMGD_VARwithiid(result);
        disp(['marginal likelihood: ' num2str(result.logdensy)])
    else
        result.logdensy = NaN;
    end
end
result.fnname = mfilename;
end % of VAR_withiid


% SUBFUNCTIONS
function [ynew,ylags] = varlags(y,P)
[T,N] = size(y);
ynew = y(P+1:end,:);
ylags = zeros(T-P,P*N);
for p = 1:P
    ylags(:,N*(p-1)+1:N*p) = y(P+1-p:T-p,:);
end
end

function y = logdet(A)
% log(det(A)) where A is positive-definite.
% This is faster and more stable than using log(det(A)).
% Written by Tom Minka
% (c) Microsoft Corporation. All rights reserved.
U = chol(A);
y = 2*sum(log(diag(U)));
end

function res = multgammaln(N,a)
% evaluates log of the N-dimensional multivariate Gamma function, defined:
% pi^{N(N-1)/4} \prod_{n=1}^N \Gamma ((2a+1-n)/2) 
nlst = 1:N ;
v1n2 = (2*a+1-nlst)/2 ;
gamln = gammaln(v1n2) ;
sumgamln = sum(gamln) ;
res = 0.25*N*(N-1)*log(pi) + sumgamln;
end
