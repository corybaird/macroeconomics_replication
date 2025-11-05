function [betah,omegahodrick,stats,resids] = olshodrick(y,X,printfl,plotfl,nlags,NWflag) ;
%
% Ordinary Least Squares for the model y = X*beta, with HAC standard errors computed according to Hodrick (1992)
%  or Newey and West (1987).  The Hodrick (1992) std errs are similar to Hansen-Hodrick (1980), but are
%  heteroskedasticity-consistent as well as corrected for autocorrelation up to nlags lags.  Note that this
%  particular program computes Hodrick's "standard errors (1A)," for which the covariance matrix is not necessarily
%  positive definite and which do not perform as well in small samples as his alternative (1B).  However, they are
%  much easier to compute than (1B).  For an alternative that is guaranteed to be positive definite, use the
%  Newey-West (1987) option for standard errors.
% y is a column vector or may be an Nxm matrix consisting of several columns; if the latter, equation-by-equation
%  OLS is performed, so that regression coefficients for each column of y are estimated separately.
% X is an Nxk matrix of exogenous regressors, which will be used for every column of y.
% printfl is 0 or 1, with 1 denoting that regression results should be printed out in a convenient format.
% plotfl is 0 or 1, with 1 denoting that the residuals should be plotted after the regression is run.
% nlags is the number of lags for which the residuals are potentially autocorrelated.  Note that nlags=0 simply
%  yields White's std errs.
% NWflag is 0 or 1, with 1 denoting that Newey-West (1987) standard errors should be used instead of Hodrick (1992).
%  Use this option if you need the estimated variance matrix to be guaranteed to be positive definite.
% As usual, betahat is a column (or kxm matrix if y is a matrix) of the estimated coefficients of the regression;
%  omegahat is a kxkxm array of variance-covariance matrices for each column of coefficients.
% The vector stats consists of regression statistics:
%  stats(1) is the R-squared; stats(2) is the sum of squared residuals;
%  stats(3) is the zero-slopes F-test statistic.
%  Others can be added as needed in the future.
%
% Eric Swanson, 2003; updated 2016 (Newey-West option added).


if (nargin<6); NWflag=0; end ;
if (nargin<5); nlags=0; end ;
if (nargin<4); plotfl=0; end ;
if (nargin<3); printfl=1; end ;

[N,m] = size(y) ;
[N,k] = size(X) ;

if (NWflag==1);
  weights = 1 - ([1:nlags]/(nlags+1)) ;
else ;
  weights = ones(nlags,1) ;
end ;

% If there are no missing data points, the regression is easy.  The QR
%  decomposition method is better for matrices X that have poorly
%  conditioned X'*X.

if (all(isfinite(y),2) & all(isfinite(X),2)) ;
  [Q,R] = qr(X,0) ; % Gram-Schmidt decomposition X = Q*R, Q orthogonal.
  betah = R \ Q'*y ;
  resids = y - X*betah ;
  for i=1:m ;
    S0 = (repmat(resids(:,i),1,k).*X)' * (repmat(resids(:,i),1,k).*X) /N ;
    for j=1:nlags ;
      termj = (repmat(resids(1+j:N,i),1,k).*X(1+j:N,:))' * ...
			(repmat(resids(1:N-j,i),1,k).*X(1:N-j,:)) / (N-j) ;
      S0 = S0 + weights(j) *(termj + termj') ;
    end ;
    XX = X'*X /N ;
    omegahodrick(:,:,i) = XX\ S0 /XX /N ;
  end ;
else ; % some data are missing
  for i=1:m ;
    good = isfinite(y(:,i)) & all(isfinite(X),2) ;
    if (sum(good)>k) ; % need >k data points or else regression is undefined
      [Q,R] = qr(X(good,:),0) ; 
      betah(:,i) = R \ Q'*y(good,i) ;
      resids(:,i) = y(:,i) - X*betah(:,i) ;
      S0 = (repmat(resids(good,i),1,k).*X(good,:))' * ...
			(repmat(resids(good,i),1,k).*X(good,:)) / sum(good) ;
      for j=1:nlags ;
        residsloc1 = resids(1:N-j,i); residsloc2 = resids(1+j:N,i) ;
        Xloc1 = X(1:N-j,:); Xloc2 = X(1+j:N,:) ;
        goodloc = good(1:N-j) & good(1+j:N) ;
        termj = (repmat(residsloc1(goodloc),1,k).*Xloc1(goodloc,:))' * ...
			(repmat(residsloc2(goodloc),1,k).*Xloc2(goodloc,:)) ...
							/ sum(goodloc) ;
        S0 = S0 + weights(j) *(termj + termj') ;
      end ;
      XlocXloc = X(good,:)'*X(good,:) /sum(good) ;
      omegahodrick(:,:,i) = XlocXloc\ S0 /XlocXloc /sum(good) ;
    else ;
      betah(:,i) = repmat(NaN,k,1) ;
      omegahodrick(:,:,i) = repmat(NaN,k,k) ;
    end ;
  end ;
end ;

% Now calculate the regression statistics.  Note that the residuals
%  will have missing data where either X or y had missing data.
if (nargout>2 | printfl==1) ;
  for i=1:m ;
    good = find(isfinite(resids(:,i))) ;
    if (size(good,1)>k) ;
      Nloc = size(good,1) ;
      SSR(i) = resids(good,i)'*resids(good,i) ;
      TSS(i) = sum((y(good,i)-mean(y(good,i))).^2) ;
      Rsquared(i) = 1 -  SSR(i)/TSS(i) ;
      sigmahsq(i) = SSR(i) / (Nloc-k) ;
      stderr(:,i) = sqrt(diag(omegahodrick(:,:,i))) ;
      tstat(:,i) = betah(:,i)./stderr(:,i) ;
      pval(:,i) = 2*tcdf(-abs(tstat(:,i)),Nloc-k) ;
%      pval(:,i) = NaN*ones(size(tstat(:,i))) ;
      % exclusion F-test and zero-slopes F-test for each regression:
      excF(i) = betah(:,i)' /omegahodrick(:,:,i) *betah(:,i) /k ;
      excFp(i) = 1 - fcdf(excF(i),k,Nloc-k) ;
%      excFp(i) = NaN ;
      j = find(~all(X==1)) ;
      zsF(i) = betah(j,i)' /omegahodrick(j,j,i) *betah(j,i) /length(j) ;
      zsFp(i) = 1 - fcdf(zsF(i),length(j),Nloc-length(j)) ;
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
  stats = [Rsquared;SSR;excF;zsF] ;

  if (printfl==1) ;
  fprintf('\n') ;
    for i=1:m ;
      if (m==1); fprintf(1,'Regression Results (Hodrick HAC std errs):\n');
      else; fprintf(1,'Regression #%i:\n',i);
      end ;
      fprintf(1,'  % 8.4f  (%6.4f),  tstat=% 6.3f,  pval=%5.4f\n',...
  		     [betah(:,i)';stderr(:,i)';tstat(:,i)';pval(:,i)']) ;
      fprintf(1,'\n R^2 = %.2f,  excF = %-6.2f(p=%5.4e),  zsF = %-6.2f(p=%5.4e)\n',...
  			     Rsquared(i),excF(i),excFp(i),zsF(i),zsFp(i)) ;
      fprintf(1,'\n')
    end ;
  end ;
end ; % end if (nargout>2 | printfl==1)


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


return ;
