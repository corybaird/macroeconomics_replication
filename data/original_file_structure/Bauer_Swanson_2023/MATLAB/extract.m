function [factors,loadings,errorvar,errors] = extract(X,k)
% function [factors,loadings,errorvar,errors] = extract(X,k)
% 
% Returns the first k principal components of the data matrix X, and the loadings
%  of the data on those k principal components.
% The function assumes that the columns of the data matrix X have *already* been
%  de-meaned and normalized to unit standard deviation if that is what the
%  user desires.
% The factors that are returned are orthogonal and normalized to unit standard
%  deviation as well.
% 
% written by Eric Swanson, 8/06.

[T,n] = size(X) ;

if (k>0) ; % if number of factors is >0
  [U,S,V] = svd(X,0) ; % singular value decomposition, X = U *S *V'
  factors = U(:,1:k) * sqrt(T) ; % normalize factors to unit std dev
  loadings = S(1:k,:) * V' /sqrt(T) ;

  sgn = diag(sign(loadings(:,1))) ; % normalize sign of all factors to be positively
  factors = factors * sgn ;         %  correlated with the first observable data series
  loadings = sgn * loadings ;

  errors = X - factors*loadings ;
  errorvar = errors'*errors / T ;

else ; % if number of factors =0, then return empty vectors of correct dimesions
  factors = repmat(NaN,T,k) ;
  loadings = repmat(NaN,k,n) ;
  errors = X ;
  errorvar = repmat(NaN,n,n) ;
end ;

    
% Note:
% loadings.^2 gives the matrix of variance shares for each column of X on each factor
% mean(loadings.^2,2) gives the total variance share of each factor
% cumsum(mean(loadings.^2,2)) gives the cumulative total variance shares of each factor
%

% Note: Here is the long, traditional way to do principal components.  It is
%  slower and less numerically robust than using the SVD.
%
% [eigenvec,eigenval] = eig(X'*X) ;
%
% [eigenval,index] = sort(diag(eigenval),1,'descend') ; % sort eigenvalues
% eigenvec = eigenvec(:,index) ; % sort eigenvectors correspondingly
%
% loadings = diag(sqrt(eigenval)) * eigenvec(:,1:k)' /sqrt(T-1) ;
% factors = X * eigenvec(:,1:k) * diag(1./sqrt(eigenval(1:k))) *sqrt(T-1) ;
%
%
