% Calculates response data
% 
% A function which calculates response data for the following 
% system:
%
% y(t) = G1*y(t-1) + impact*e(t)
%
% Where y(t) is a nx1 vector, e(t) is a kx1 vector and 
% G1 and impact are matrices of the appropriate dimensions
%
% Inputs:
%
%    G1 and impact  --- see above
%    shock          --- kxT vector of shocks to be fed to the model
%    T              --- number of periods to be simulated
%
% Output:
%
%    X              --- (T+1)xn matrix describing the evolution of
%                         y(t)
%
% Created by Jon Steinsson, June 2001.
% Modified by Michele Fornino, April 2016.
%*********************************************************

function X = VarResponse(G1,impact,shock,T)

% Perform check of input argument shock
if size(shock,2) ~= T
    error('Shock vector should be equal in size to the simulation horizon')
end

%*********************************************************
% Definition of variables

n = size(G1,1);
y = zeros(n,1);
X = zeros(T+1,n);

%*********************************************************
% Calculation of Impulse data

 t = 1;
  while t <= T;
    ee = shock(:,t);
    y = G1*y + impact*ee;
    X(t+1,:) = y';
    t = t + 1;
  end;
