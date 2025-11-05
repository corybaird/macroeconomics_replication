function [FF,RR,eu] = modelINFO(yy,par,varargin)

% Routine that computes the matrices G1 and the error coefficients RR based
% on Gensys routine. The model is the Information Model of NS2015. It also
% outputs a vector eu to verify existence and uniqueness of a solution.
%
% Takes as inputs:
% - yy: vector of parameters

% --- New Keynesian Model
%
% 1. Hybrid Phillips curve
% 2. External habit formaction in conumption
% 3. New unconventional monetary policy:
%    i_t - E_t pi_t+1 = rbar_t + \psiPiU E_t pi_t+1
%    rbar_t is an AR2 with roots rhoMP1 and rhoMP2
% 4. rbar_t shock contains information about future natural rates
%
% Emi Nakamura and Jon Steinsson, October 2013

% --- Parameters
% Changing
rhoMP1  = yy(1);     % 1st root of interest rate shock
rhoMP2  = yy(2);     % 2nd root of interest rate shock
xx      = yy(3);     % additional real rigidity
aa      = yy(4);     % Change in E_t r^n_t+j when E_t rbar_t+j changes by 1
bb      = yy(5);     % Habit parameter

% Calibrated
beta    = par.calibration.beta;      % Subjective discount factor
alpha   = par.calibration.alpha;     % nominal rigidity
omega   = par.calibration.omega;     % elasticity of marginal cost to output
gamma   = par.calibration.gamma;     % coeff on lagged inflation (indexation parameter)
psiPi   = par.calibration.psiPi;     % Endogenous feedback in Taylor rule
inftarg = par.calibration.inftarg;   % Inflation target shock
theta   = par.calibration.theta;     % elasticity of substitution across varieties
sigma   = par.calibration.sigma;     % Intertemporal elasticity of substitution

% Composite parameters
kappa   = (1-alpha)*(1-alpha*beta)/alpha;
zeta    = xx/(1+omega*theta);
sigma_c = sigma^-1/((1-bb)*(1-bb*beta));

% Definition of system
%
% g0 * x(t) = g1 * x(t-1) + C + Psi * z(t) + Pi * eta(t)
% 
% x_(t)= [
%  [1]    x_t         % output gap 
%  [2]    E_t x_t+1
%  [3]    pi_t        % inflation 
%  [4]    E_t pi_t+1      
%  [5]    r_t         % nominal interest rate 
%  [6]    r_t-1
%  [7]    E_t-1 pi_t
%  [8]    pi_t-1
%  [9]    rbar_t      % MP real rate shock
%  [10]   rbar_t-1
%  [11]   rbar2_t     % 2nd more persistent MP real rate shock
%  [12]   r^n_t       % Natural rate of interest
%  [13]   y_t         % output
%  [14]   y_t^n       % Natural rate of output
%  [15]   lambda_xt    % Marginal utility gap
%  [16]   E_t lambda_xt+1
%  [17]   E_t r^n_t+1
%  [18]   y^n_t-1     % lagged natural rate
%  [19]   sp_t        % Stock price
%  [20]   E_t sp_t+1
%  [21]   E_t y_t+1
%  [22]   lambda_yt   % Marginal utility
%  [23]   E_t lambda_yt+1
%  [24]   Dummy
%  [25]   a_t         % productivity
%  [26]   y^n_t-2     % twice lagged natural rate of output
%  [27]   r^n_t-1     % lagged natural rate of interest
%  [28]   eps_t       % Initial natural rate of output response
%  [29]   E_t y^n_t+1 % Expected future natural rate of output
%         ]

dimg0 = 29;
cc = zeros(dimg0,1);
g0 = zeros(dimg0,dimg0);
g1 = zeros(dimg0,dimg0);
pi = zeros(dimg0,8);     % Expectational Errors
psi = zeros(dimg0,1);    % Disturbances

% Consumption Euler Equation
g0(1,15) = -1;
g0(1,16) = 1;
g0(1,4)  = -1;
g0(1,5)  = 1;
g0(1,12) = -1;

% Philips curve
g0(2,3)  = -(1+beta*gamma);
g0(2,4)  = beta;
g0(2,8)  = gamma;
g0(2,1)  = kappa*omega*zeta;
g0(2,15) = -kappa*zeta;

% Monetary policy
g0(3,5)  = 1;                %(i_t)
g0(3,4)  = -1;               %(E_t pi_t+1)
g0(3,3)  = -psiPi;           %(pi_t)
g0(3,9)  = -1;               %(rbar_t)
g0(3,11) = -inftarg;         %(rbar2_t)

% Expected consumption
g0(4,1) = 1;
g1(4,2) = 1;
pi(4,1) = 1;

% Expected inflation
g0(5,3) = 1;
g1(5,4) = 1;
pi(5,2) = 1;

% Lagged interest rate
g0(6,6) = 1;
g1(6,5) = 1;

% Lagged expected inflation
g0(7,7) = 1;
g1(7,4) = 1;

% Lagged inflation
g0(8,8) = 1;
g1(8,3) = 1;

% AR(2) for real rate shock
g0(9,9) = 1;
g1(9,9) = (rhoMP1+rhoMP2);
g1(9,10) = -rhoMP1*rhoMP2;
psi(9,1) = 1;

% Lagged real rate shock
g0(10,10) = 1;
g1(10,9) = 1;

% Inflation target shock
g0(11,11) = 1;
g1(11,11) = 0.999;
psi(11,1) = 1;

% Natural rate of interest
g0(12,12) = 1;
g0(12,9)  = -aa;

% Output
g0(13,13) = 1;
g0(13,14) = -1;
g0(13,1)  = -1;

% Natural rate of output
g0(14,14) = 1+bb*beta+bb^2*beta;
g0(14,29) = -beta*bb;
g1(14,14) = 1+bb+bb^2*beta;
g1(14,18) = -bb;
g1(14,12) = sigma_c^(-1);
g0(14,28) = -1;

% Marginal utility gap
g0(15,15) = 1;
g0(15,1)  = sigma_c*(1+bb^2*beta);
g1(15,1)  = bb*sigma_c;
g0(15,2) = -beta*bb*sigma_c;

% Expected marginal utility gap
g0(16,15) = 1;
g1(16,16) = 1;
pi(16,3) = 1;

% Expected natural rate of interest
g0(17,12) = 1;
g1(17,17) = 1;
pi(17,4) = 1;

% Lagged natural rate of output at time
g0(18,18) = 1;
g1(18,14) = 1;

% Stock price equation
g0(19,19) = 1;
g0(19,20) = -beta;
g0(19,22) = 1;
g0(19,23) = -1;
g0(19,21) = -(1-beta);

% stock price expectations
g0(20,19) = 1;
g1(20,20) = 1;
pi(20,5) = 1;

% Expected output
g0(21,13) = 1;
g1(21,21) = 1;
pi(21,6) = 1;

% Marginal utility 
g0(22,22) = 1;
g0(22,13) = sigma_c*(1+bb^2*beta);
g1(22,13) = bb*sigma_c;
g0(22,21) = -beta*bb*sigma_c;

% Expected marginal utility
g0(23,22) = 1;
g1(23,23) = 1;
pi(23,7) = 1;

% Dummy variable
g0(24,24) = 1;

% Productivity 
g0(25,25) = 1+omega;
g0(25,14) = -(omega + sigma_c*(1 + bb^2*beta));
g1(25,14) = - sigma_c * bb;
g0(25,29) = beta*bb*sigma_c;

% Twice lagged natural rate of output
g0(26,26) = 1;
g1(26,18) = 1;

% Lagged natural rate of interest
g0(27,27) = 1;
g1(27,12) = 1;

% Initial response of the natural rate
g0(28,28) = 1;
psi(28,1) = aa;

% Expected natural output
g0(29,14) = 1;
g1(29,29) = 1;
pi(29,8) = 1;

% Run Gensys
[FF,~,RR,~,~,~,~,eu] = gensys(g0,g1,cc,psi,pi);
end

