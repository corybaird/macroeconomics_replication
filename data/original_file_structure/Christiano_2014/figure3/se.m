function [V,Shat]=se(X,D,thet,l)
%
% This routine returns V, the variance-covariance matrix of
% a set of parameters, say beta, which have been estimated by
% exactly identified GMM.  The estimate is defined by the fact
% that it sets to zero a function g(beta), which is the sample
% average of a stochastic process,
%
%             u (beta),
%              t
%
% which is a row vector which, when evaluated at the true value of beta,
% is strictly stationary, has zero mean, nonsingular spectral density
% S, and satisfies other regularity conditions (see Hansen's
% GMM paper in Econometrica, or Hansen and Singleton.)
%     The matrix X is defined
%
%              X = u (betahat)
%                   1
%                  .
%                  .
%                  u (betahat)
%                   T
%
% where betahat is the estimated value of beta, and T is the number
% of observations in the dataset.  The vector composed of the mean
% of the entries in each column of X is g(betahat), which must be zero.
% Accordingly, the routine checks that the mean value of each column
% of X is zero.
%    The square matrix D is the derivative of g(beta) with respect
% to beta, evaluated at beta = betahat.
%    The routine requires as input thet, l, X, D and returns V
% and Shat, where Shat is an estimate of S and where
%
%           V = inv(D)*Shat*inv(D-transpose),
%
%  where,
%
%           Shat = sum (j = -l,...,l) w(j)Chat(j),
%
%  where,
%
%           w(j) = (1 - abs(j)/(l+1))^thet,
%
%           Chat(j) = sum(t = j+1,...,T)u (betahat)'*u   (betahat)
%                                        t            t-j
%
%  Normaly, one would just set thet = 1, and l = 1, or 2.  But it
%  would make sense to experiment especially with higher values of
%  thet.
%
[T,n]=size(X);
[m1,n1]=size(D);
if m1~=n1
  disp(' fatal (se) matrix D on input not square')
  return
end
if n~=m1
  disp(' fatal (se) right dimension of X not equal to dimension of D')
  return
end
a=sum(X)/T;
for i=1:length(a)
 if abs(a(i))>=.00001
 disp(' fatal (se) columns of X not zero')
 a
 return
 end
end
Shat=X'*X/T;
if l>=1
  for j=1:l
    C=X([j+1:T],:)'*X([1:T-j],:)/(T-j);
    const=((1-abs(j)/(l+1))^thet);
    Shat=Shat+(C+C')*const;
  end
end
V=inv(D)*Shat*inv(D');
