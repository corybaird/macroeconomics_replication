function out = lag(y,nlag) ;

if (nargin<2); nlag=1; end ;

[N,k] = size(y) ;

out = [repmat(NaN,nlag,k); y(1:N-nlag,:)] ;
