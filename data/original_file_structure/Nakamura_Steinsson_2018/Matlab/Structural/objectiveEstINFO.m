function [loss,varargout] = objectiveEstINFO(par,mpe,yy,weightMatrix)

% Routine that computes a quadratic loss function (unweighted) based on
% the difference between estimated moments and those implied by the IRFs
% of the model.
%
% Takes as inputs:
% - mpe: structure containing moment point estimates that we want to target
% - par: structure containing global settings
% - yy: vector of parameters to pass to modelINFO
% - weightMatrix: symmetric PD matrix to weight loss GMM style.
%                 Mmust have size #moments * #moments

% % Check input arguments
% narginchk(3,4)
% 
% if nargin == 3
%     weightMatrix = eye(length(par.numMoments));
% end
% if size(weightMatrix,2) ~= par.numMoments || ...
%    size(weightMatrix,1) ~= par.numMoments
%     error(['Weighting Matrix must be consistent with number of ' ...
%            'moments used in estimation!'])
% end

% Simulate Model
[FF,RR,eu] = modelINFO(yy,par);

% Settings and Preallocate result structure
dimg0 = length(RR);
out = struct;

% RECALL MODEL INFO:
%  [3]    pi_t        % Inflation 
%  [4]    E_t pi_t+1  % Expected Inflation    
%  [5]    r_t         % Nominal interest rate
%  [13]   y_t         % Output
%  [19]   sp_t        % Stock price

% Preallocate IRF vectors
out.IR        = zeros(dimg0,par.figures.TT);    % Complete set of variables
out.Nforwards = zeros(1,par.figures.TT);        % Nominal Forwards
out.Rforwards = zeros(1,par.figures.TT);        % Real Forwards
out.Nyields   = zeros(1,par.figures.TT);        % Nominal Yields
out.Ryields   = zeros(1,par.figures.TT);        % Real Yields
out.inflation = zeros(1,par.figures.TT);        % Inflation
out.expinflY  = zeros(1,par.figures.TT);        % Expected Inflation (Yields)
out.expinflF  = zeros(1,par.figures.TT);        % Expected Inflation (Forwards)
out.stocks    = zeros(1,par.figures.TT);        % Stocks (nominal return)
out.RGDP      = zeros(1,par.figures.TT);        % GDP (real)

% First period
out.IR(:,1)        = RR;
out.Rforwards(1,1) = out.IR(5,1)-out.IR(4,1);   % Real = Nom - E_t pi_t+1
out.Ryields(1,1)   = out.IR(5,1)-out.IR(4,1);   % Real = Nom - E_t pi_t+1
out.inflation(1,1) = out.IR(3,1);               % Current Inflation
out.expinflY(1,1)  = out.IR(4,1);               % Expected Inflation (Yield)
out.expinflF(1,1)  = out.IR(4,1);               % Expected Inflation (Forward)
out.Nforwards(1,1) = out.IR(5,1);               % Nominal interest rate
out.Nyields(1,1)   = out.IR(5,1);
out.stocks(1,1)    = out.IR(19,1);              % Stock price
out.RGDP           = out.IR(13,1);              % Output

% Subsequent periods
% Note: we want the growth rate of output annualized!
for tt = 2:par.figures.TT
    out.IR(:,tt)        = FF * out.IR(:,tt-1);
    out.Rforwards(1,tt) = out.IR(5,tt)-out.IR(4,tt);
    out.Ryields(1,tt)   = (out.Rforwards(1,tt) + (tt-1)*out.Ryields(1,tt-1))/tt;
    out.Nforwards(1,tt) = out.IR(5,tt);
    out.Nyields(1,tt)   = (out.Nforwards(1,tt) + (tt-1)*out.Nyields(1,tt-1))/tt;
    out.inflation(1,tt) = out.IR(3,tt);
    out.expinflF(1,tt)  = out.IR(4,tt);
    out.expinflY(1,tt)  = (out.expinflF(1,tt) + (tt-1)*out.expinflY(1,tt-1))/tt;
    out.stocks(1,tt)    = out.IR(19,tt);
    out.RGDP(1,tt)      = (out.IR(13,tt) - out.IR(13,tt-1))*4;
end

% Rescale simulation to hit 3Y Real Forward exactly
% Note: Recall quarterly calibration!
factor        = mpe.DRF3 / out.Rforwards(1,12);

out.IR        = out.IR * factor;
out.Nforwards = out.Nforwards * factor;
out.Rforwards = out.Rforwards * factor;
out.Nyields   = out.Nyields * factor;
out.Ryields   = out.Ryields * factor;
out.inflation = out.inflation * factor;
out.expinflY  = out.expinflY * factor;
out.expinflF  = out.expinflF * factor;
out.stocks    = out.stocks * factor;
out.RGDP      = out.RGDP * factor;

% Evaluate Loss
% Calculate loss if model is determinate. Otherwise return large number.

if (eu(1) == 1 && eu(2) == 1)  
    % Preallocate
    devVec = zeros(par.numMoments,1);
    
    % Compute deviation of model from moments (keep only real part)
    for ii = 1:par.numMoments
        devVec(ii,1) = real(devAsset(par.estVar{ii},out,mpe));
    end
    
    % Compute loss function weighted by GMM style matrix
    loss = devVec' * weightMatrix * devVec;
    
    varargout = {devVec};
else
    loss = 10^12;
end

end
