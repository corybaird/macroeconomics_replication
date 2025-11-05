function [cc] = corr_(x,y,lag)

if length(x) ~= length(y)
    error('fatal (corr_) variables of different length')
end
lx=length(x);
cc=zeros(2*lag+1,1);
a0=corrcoef(x,y);
cc(lag+1)=a0(1,2);
for ii = 1:lag
    tt=ii+1:lx;
    t1=1:lx-ii;
    a=corrcoef(x(tt),y(t1));
    cc(lag+1+ii)=a(1,2);
    a=corrcoef(x(t1),y(tt));
    cc(lag+1-ii)=a(1,2);    
end

