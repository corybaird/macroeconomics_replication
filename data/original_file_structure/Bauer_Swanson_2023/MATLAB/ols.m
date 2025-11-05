function [betah,omegah,stats,resids] = ols(y,X,printfl,plotfl) ;
%
% Ordinary Least Squares, obviously, for the model y = X*beta.
% y is a column vector or may be an Nxm matrix consisting of several
%  columns; if the latter, equation-by-equation OLS is performed, so that
%  regression coefficients for each column of y are estimated separately.
% X is an Nxk matrix of exogenous regressors, which will be used for every
%  column of y.
% printfl is 0 or 1, with 1 denoting that regression results should be
%  printed out in a convenient format.
% plotfl is 0 or 1, with 1 denoting that the residuals should be plotted
%  after the regression is run.
% As usual, betahat is a column (or kxm matrix if y is a matrix) of the
%  estimated coefficients of the regression; omegahat is a kxkxm array of
%  variance-covariance matrices for each column of coefficients.
% The vector stats consists of regression statistics:
%  stats(1) is the R-squared; stats(2) is the sum of squared residuals;
%  stats(3) is the zero-slopes F-test statistic.
%  Others can be added as needed in the future.
%
% written by Eric T. Swanson, 1995.  Last updated by ETS 2005.
%

if (nargin<3); printfl=1; end ;
if (nargin<4); plotfl=0; end ;

[N,m] = size(y) ;
[N,k] = size(X) ;

% If there are no missing data points, the regression is easy.  The QR
%  decomposition method is better for matrices X that have poorly
%  conditioned X'*X.

if (all(isfinite(y),2) & all(isfinite(X),2)) ;
  [Q,R] = qr(X,0) ; % Gram-Schmidt decomposition X = Q*R, Q orthogonal.
  XXinv = inv(R) / R' ;
  betah = R \ Q'*y ;
  omegah = repmat(XXinv,[1 1 m]) ;
else ;
  for i=1:m ;
    good = isfinite(y(:,i)) & all(isfinite(X),2) ;
    if (sum(good) >k) ; % need >k data points or else regression is undefined
      [Q,R] = qr(X(good,:),0) ; 
      XlocXlocinv = inv(R) / R' ;
      betah(:,i) = R \ Q'*y(good,i) ;
      omegah(:,:,i) = XlocXlocinv ;
    else ;
      betah(:,i) = repmat(NaN,k,1) ;
      omegah(:,:,i) = repmat(NaN,k,k) ;
    end ;
  end ;
end ;

% Now calculate the regression statistics.  Note that the residuals
%  will have missing data where either X or y had missing data.

resids = y - X*betah ;
for i=1:m ;
  good = find(isfinite(resids(:,i))) ;
  if (size(good,1)>k) ;
    Nloc = size(good,1) ;
    SSR(i) = resids(good,i)'*resids(good,i) ;
    TSS(i) = sum((y(good,i)-mean(y(good,i))).^2) ;
    Rsquared(i) = 1 -  SSR(i)/TSS(i) ;
    sigmahsq(i) = SSR(i) / (Nloc-k) ;
    omegah(:,:,i) = sigmahsq(i) * omegah(:,:,i) ;
    stderr(:,i) = sqrt(diag(omegah(:,:,i))) ;
    tstat(:,i) = betah(:,i)./stderr(:,i) ;
    pval(:,i) = 2*tcdf(-abs(tstat(:,i)),Nloc-k) ;
%    pval(:,i) = NaN*ones(size(tstat(:,i))) ;

    % exclusion F-test and zero-slopes F-test for each regression:
    excTSS(i) = TSS(i) ;
    excF(i) = (excTSS(i)-SSR(i)) / sigmahsq(i) / k ;
    excFp(i) = 1 - fcdf(excF(i),k,Nloc-k) ;
%    excF(i) = NaN ;
%    excFp(i) = NaN ;
    zsTSS(i) = y(good,i)'*y(good,i) - Nloc*mean(y(good,i))^2 ;
    zsF(i) = (zsTSS(i)-SSR(i)) / sigmahsq(i) / max(k-1,1) ;
    zsFp(i) = 1 - fcdf(zsF(i),max(k-1,1),Nloc-k) ;
%    zsFp(i) = NaN ;
  else ;
    SSR(i) = NaN ;
    TSS(i) = NaN ;
    Rsquared(i) = NaN ;
    stderr(:,i) = repmat(NaN,k,1) ;
    tstat(:,i) = repmat(NaN,k,1) ;
    pval(:,i) = repmat(NaN,k,1) ;
    excF(i) = NaN ;
    excFp(i) = NaN ;
    zsF(i) = NaN ;
    zsFp(i) = NaN ;
  end ;
end ;

if (printfl==1) ;
fprintf('\n') ;
  for i=1:m ;
    if (m==1); fprintf(1,'Regression Results:\n');
    else; fprintf(1,'Regression #%i:\n',i);
    end ;
    fprintf(1,'  % 8.4f  (%6.4f),  tstat=% 6.3f,  pval=%5.4f\n',...
                   [betah(:,i)';stderr(:,i)';tstat(:,i)';pval(:,i)']) ;
    fprintf(1,'\n R^2 = %.2f,  excF = %-6.2f(p=%5.4e),  zsF = %-6.2f(p=%5.4e)\n',...
                           Rsquared(i),excF(i),excFp(i),zsF(i),zsFp(i)) ;
    fprintf(1,'\n')
  end ;
end ;


if (plotfl==1) ;
  yhat = y - resids ;
  hold off;
  plot(y) ;
  hold on ;
  plot(yhat,'--m') ;
  tempax = axis ;
  axis([0,N+1,tempax(3),tempax(4)]) ;
  hold off ;
end ;

stats = [Rsquared;SSR;excF;zsF] ;
squeeze(omegah) ;

return ;
