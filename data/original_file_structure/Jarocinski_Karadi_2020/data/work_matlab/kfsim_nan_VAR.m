function [ydraw, loglik] = kfsim_nan_VAR(y, B, Sigma, ind_output)
% PURPOSE: Draw the missing data in a VAR model with some missing data.
% This function sets up the VAR as a state-space model and calls kfsim_nan.
%
% INPUTS:
% y - data, T by N, may contain missing values, but not in the first P obs.
% B - parameters of the VAR, K by N
% Sigma - variance of the VAR innovations, N by N
% RETURNS: 
% ydraw - draw of the states
% loglik - log likelihood

[K,N] = size(B);
P = (K - 1)/N;

yy = y(P+1:end,:)';

dd = zeros(N,1);
ZZ = zeros(N,N*P); ZZ(1:N,1:N) = eye(N);
WW = eps*eye(N);

cc = zeros(N*P,1); cc(1:N) = B(end,:)';
TT = [B(1:end-1,:)'; eye(N*(P-1)) zeros(N*(P-1),N)];
RR = [chol(Sigma)'; zeros(N*(P-1),N)];

C1 = RR;
a0 = flipud(y(1:P,:))'; a0 = a0(:);
a1 = cc + TT*a0;

[ydraw, loglik] = kfsim_nan(yy, dd, ZZ, WW, cc, TT, RR, a1, C1, ind_output);

if ind_output>0
    ydraw = ydraw(1:N,:)';
else
    ydraw = NaN;
end

% ss.dd = dd;
% ss.ZZ = ZZ;
% ss.WW = WW;
% ss.cc = cc;
% ss.TT = TT;
% ss.RR = RR;
% ss.C1 = C1;
% ss.a1 = a1;
% ss.a0 = a0;