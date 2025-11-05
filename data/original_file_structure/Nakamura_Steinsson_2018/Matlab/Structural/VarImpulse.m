% Calculates impulse data
% 
% A function which calculates impulse data for the following 
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
%    shock          --- kx1 vector of impulses at time 0, i.e. e(0)
%    T              --- number of periods to be simulated
%
% Output:
%
%    X              --- (T+1)xn matrix describing the evolution of
%                         y(t)
%
% Created by Jon Steinsson, June 2001.
%*********************************************************

function X = VarImpulse(G1,impact,shock,T)

%*********************************************************
% Definition of variables

n = size(G1,1);
k = size(impact,2);
y = zeros(n,1);
X = zeros(T+1,n);
e2 = zeros(k,1);

%*********************************************************
% Calculation of Impulse data

 t = 1;
  while t <= T;
    if t == 1;
      ee = shock;
    else
      ee = e2;
    end;
    y = G1*y + impact*ee;
    X(t+1,:) = y';
    t = t + 1;
  end;
