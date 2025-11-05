function [aaa, loglik] = kfsim_nan(y, dd, ZZ, WW, cc, TT, RR, a1, C1, ind_output)
% PURPOSE: Performs Kalman filtering and smoothing or simulation smoothing.
% This version: Uses a version of Algorithm 2 of Durbin and Koopman (2002)
% *WITH* the efficient modification that saves one pass of the filter/smoother.
% This version: ALLOWS MISSING VALUES (NaN) IN THE DATA y.
% We assume the model is:
% y(t) = dd + ZZ a(t) + WW eps(t),  eps(t) ~ N(0,I)
% a(t+1) = cc + TT a(t) + RR eta(t), eta(t) ~ N(0,I)
% a(1) ~ N(a1,C1*C1')
% INPUTS:
% y - data, nobs x T (where nobs is the number of observables and T is the
%     number of time periods)
% dd, ZZ, WW - parameters of the observation equation
% cc, TT, RR - parameters of the state equation
% a1, C1 - parameters of the distribution of the initial state
% ind_output - 0: return the log likelihood [NaN,loglik]
%              1: return the smoothed state and the log likelihood [aaa,loglik]
%              2: return a draw of the states from the simulation smoother [aaa,NaN]
% OUTPUTS:
% if ind_output = 0
%   aaa = []
%   loglik = log likelihood of each observation of y, 1 x T
% if ind_output = 1
%   aaa = the mean of the states conditional on y, nstates x T
%   loglik = log likelihood of each observation of y, 1 x T
% if ind_output = 2
%   aaa = a draw of the states conditional on y, nstates x T
%   loglik = []
%
% Marek Jarocinski, 2013-11-17
% 2014-01-22 added the option of reporting only loglik

% measure dimensions
[nobs,T] = size(y);
[nobs2, nobsshocks] = size(WW);
if (nobs2~=nobs), error('Input size mismatch, transpose y?'), end
[nstates, nstatesshocks] = size(RR);

if ind_output==2
    % Durbin, Koopman 2002, Algorithm 2.
    % Generate yplus and aplus - y and a drawn from their unconditional
    % distribution *using the 'demeaned' model*,
    % i.e. zero initial state and zero constant terms!
    yplus = nan(nobs,T);
    aplus = nan(nstates,T+1);
    aplus(:,1) = C1*randn(size(C1,2),1); % draw the first state with a1=0
    for t = 1:T
        yplus(:,t) = ZZ*aplus(:,t) + WW*randn(nobsshocks,1);
        aplus(:,t+1) = TT*aplus(:,t) + RR*randn(nstatesshocks,1);
    end
    aplus(:,end) = [];
    yy = y - yplus;
else
    yy = y;
end


% allocate space
loglik = nan(1,T);
vvv = nan(nobs,T); % one-step-ahead forecast error of y
FFFinv = nan(nobs,nobs,T); % inverse of the variance of the one-step-ahead forecast error of y
KKK = nan(nstates,nobs,T); % Kalman gain

% Kalman filter on yy
% compute frequently used matrices
HH = WW*WW';
RQR = RR*RR';
% initialize Kalman filter
at = a1; % at|I(t-1)
Pt = C1*C1'; % Pt|I(t-1)
for t = 1:T
    iobs = find(~isnan(yy(:,t)));
    if length(iobs)==nobs
        vt = yy(:,t) - dd - ZZ*at;
        Ftinv = (ZZ*Pt*ZZ' + HH)\eye(nobs);
        Kt = TT*Pt*ZZ'*Ftinv;
        % update at,Pt; from now on their interpretation is "a(t+1),P(t+1)"
        at = cc + TT*at + Kt*vt;
        Pt = TT*Pt*(TT - Kt*ZZ)' + RQR;
        % store the quantities needed later for smoothing
        vvv(:,t) = vt;
        FFFinv(:,:,t) = Ftinv;
        KKK(:,:,t) = Kt;
        if ind_output<2
            loglik(t) = -0.5*nobs*log(2*pi) + sum(log(diag(chol(Ftinv)))) -0.5*(vt'*Ftinv*vt);
            % Note that: 0.5*log(det(Ftinv)) = sum(log(diag(chol(Ftinv)))
        end
    elseif ~isempty(iobs)
        nobst = length(iobs);
        ZZt = ZZ(iobs,:);
        HHt = HH(iobs,iobs);
        vt = yy(iobs,t) - dd(iobs) - ZZt*at;
        Ftinv = (ZZt*Pt*ZZt' + HHt)\eye(nobst);
        Kt = TT*Pt*ZZt'*Ftinv;
        % update at,Pt; from now on their interpretation is "a(t+1),P(t+1)"
        at = cc + TT*at + Kt*vt;
        Pt = TT*Pt*(TT - Kt*ZZt)' + RQR;
        % store the quantities needed later for smooting
        vvv(iobs,t) = vt;
        FFFinv(iobs,iobs,t) = Ftinv;
        KKK(:,iobs,t) = Kt;
        if ind_output<2
            % store the log likelihood
            loglik(t) = -0.5*nobs*log(2*pi) + sum(log(diag(chol(Ftinv)))) -0.5*(vt'*Ftinv*vt); 
            % Note that: 0.5*log(det(Ftinv)) = sum(log(diag(chol(Ftinv)))
        end
    else
        % update at,Pt; from now on their interpretation is "a(t+1),P(t+1)"
        at = cc + TT*at;
        Pt = TT*Pt*TT' + RQR;
        loglik(t) = 0;
    end
end

if ind_output==0, aaa = []; return, end

% Kalman smoother
% backwards recursion on r
rrr = zeros(nstates,T);
for t = T-1:-1:1
    iobs = find(~isnan(yy(:,t+1)));
    if length(iobs)==nobs
        rrr(:,t) = ZZ'*FFFinv(:,:,t+1)*vvv(:,t+1) + (TT - KKK(:,:,t+1)*ZZ)'*rrr(:,t+1);
    elseif ~isempty(iobs)
        Ftp1inv = FFFinv(iobs,iobs,t+1);
        ZZtp1 = ZZ(iobs,:);
        vtp1 = vvv(iobs,t+1);
        Ktp1 = KKK(:,iobs,t+1);
        rrr(:,t) = ZZtp1'*Ftp1inv*vtp1 + (TT - Ktp1*ZZtp1)'*rrr(:,t+1);
    else        
        rrr(:,t) = TT'*rrr(:,t+1); % backward recursion with no observables
    end
end
% one more iteration to get r0
iobs = find(~isnan(yy(:,1)));
r0 = ZZ(iobs,:)'*FFFinv(iobs,iobs,1)*vvv(iobs,1) + (TT - KKK(:,iobs,1)*ZZ(iobs,:))'*rrr(:,1);
% allocate space for smoothed states
aaa = nan(nstates,T);
% forwards recursion to compute smoothed states from r - DK(2002),eq.8
aaa(:,1) = a1 + C1*C1'*r0; % initialize the forward recursion
for t = 2:T
    aaa(:,t) = cc + TT*aaa(:,t-1) + RQR*(rrr(:,t-1));
end

if ind_output==2
    aaa = aaa + aplus;
    loglik = [];
end

end