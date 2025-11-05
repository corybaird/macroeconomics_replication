function [V,rnw,snsw,B,S,T]=correlate(n,w,lag,thet,l)
%
%  This routine takes as input the time series n and w,
%  and returns the m=2*lag+1 vector,
%
%        rnw(lag+j+1) = corr(n(t),w(t-j)),
%
%  for j = -lag,...,lag.  It also returns the m+1 by m+1 symmetric
%  matrix V.  This is the asymptotic variance-covariance matrix of
%  the m+1 vector [rnw,snsw], where snsw is the ratio of the
%  sample standard deviation of n to that of w.  The 3 by m+1 matrix
%  B contains [rnw,snsw] as its first row, the square root of the
%  corresponding diagonal element of V in the second row, and the
%  ratio of the first and second row (i.e., the t-statistics) in
%  the third row.
%    Asymptotically, (T^.5)*[rnw,snsw] is normal with mean equal
%  to the true values and variance equal to V*T, where T is the number
%  of observations used in doing the computations.  Lars Hansen's
%  formulas for exactly identified GMM are used to get V.
%    To get V, two other parameters are needed:  thet and l.  These
%  correspond to theta and L on page 14-143 in the RATS 3.0 manual
%  (see Doan, September 1988).  They are used in the estimation
%  of the frequency zero part of the spectral density, S, of a certain
%  stochastic process.  The parameter l is the order of the highest
%  non-zero autocorrelation assumed for the process (try l = 1 or 2),
%  and the parameter thet controls the type of window used (try thet
%  = 1.)  The program calls MATLAB routine SE.M.

if nargin == 3
    l=2;
    thet=1;
end
    
T=length(n);
Tw=length(w);
if T~=Tw
  disp('fatal (correlate) data length mismatch')
  return
end
ww=w([lag+1:T-lag]);
mw=sum(ww)/length(ww);
nn=n([lag+1:T-lag]);
n=[];
n=nn-sum(nn)/length(nn);
m=2*lag+1;
for i=1:m
 wx(:,i)=w([m-i+1:T-i+1]);
end
wx=wx-kron(mean(wx),ones(size(wx,1),1));
%
T=length(n);
sn=sqrt(sum(n.^2)/T);
sw=sqrt(sum(wx(:,lag+1).^2)/T);
snsw=sn/sw;
%
rnw=zeros(m,1);
for i=1:m
    rnw(i)=(sum(n.*wx(:,i))/sum(n.^2))*snsw;
end
%
X=zeros(T,m+1);
bb=zeros(1,m);
for i = 1:T
  for j=1:m
  bb(j)=(n(i)^2)*rnw(j)*sw/sn-n(i)*wx(i,j);
  end
  X(i,:)=[bb,(wx(i,lag+1)*sn/sw)^2-n(i)^2];
end
D=zeros(m+1,m+1);
D([1:m],m+1)=-(sw^2)*rnw([1:m]);
for i=1:m
 D(i,i)=sn*sw;
end
D(m+1,m+1)=2*sn*sw;
[V,S]=se(X,D,thet,l);
V=V/T;
G=[rnw' snsw
   sqrt(diag(V)')];
B=[G
   G(1,:)./G(2,:)];
