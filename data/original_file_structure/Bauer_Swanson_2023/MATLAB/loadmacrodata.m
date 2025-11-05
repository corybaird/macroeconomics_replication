
% load monthly Nonfarm Payrolls data
load ../data/NonfarmPayrolls.txt ;
nfpyr = NonfarmPayrolls(:,1) ;
nfpmo = NonfarmPayrolls(:,2) ;
nfplev = log(NonfarmPayrolls(:,3)) ;
Dnfp = [NaN;diff(nfplev)] ;
Dnfp1 = lag(Dnfp) ;
Dnfp2 = lag(Dnfp,2) ;
Dnfp3 = lag(Dnfp,3) ;
Dnfp4 = lag(Dnfp,4) ;
Dnfp5 = lag(Dnfp,5) ;
Dnfp6 = lag(Dnfp,6) ;
Dnfp7 = lag(Dnfp,7) ;
Dnfp8 = lag(Dnfp,8) ;
Dnfp9 = lag(Dnfp,9) ;
Dnfp10 = lag(Dnfp,10) ;
Dnfp11 = lag(Dnfp,11) ;
Dnfp12 = lag(Dnfp,12) ;

% load monthly unemployment data
load ../data/Unemployment.txt ;
unemp = Unemployment(:,3) ;
unemp1 = lag(unemp) ;
unemp2 = lag(unemp,2) ;
unemp3 = lag(unemp,3) ;
unemp4 = lag(unemp,4) ;
unemp5 = lag(unemp,5) ;
unemp6 = lag(unemp,6) ;

load ../data/cpi.txt ;
cpi = log(cpi(:,3)) ;
cpi1 = lag(cpi) ;
cpi2 = lag(cpi,2) ;
cpi3 = lag(cpi,3) ;
cpi4 = lag(cpi,4) ;
cpi5 = lag(cpi,5) ;
cpi6 = lag(cpi,6) ;
cpi7 = lag(cpi,7) ;
cpi8 = lag(cpi,8) ;
cpi9 = lag(cpi,9) ;
cpi10 = lag(cpi,10) ;
cpi11 = lag(cpi,11) ;
cpi12 = lag(cpi,12) ;
cpi13 = lag(cpi,13) ;
cpi14 = lag(cpi,14) ;
cpi15 = lag(cpi,15) ;

load ../data/cpix.txt ;
cpix = log(cpix(:,3)) ;
cpix1 = lag(cpix) ;
cpix2 = lag(cpix,2) ;
cpix3 = lag(cpix,3) ;
cpix4 = lag(cpix,4) ;
cpix5 = lag(cpix,5) ;
cpix6 = lag(cpix,6) ;
cpix7 = lag(cpix,7) ;
cpix8 = lag(cpix,8) ;
cpix9 = lag(cpix,9) ;
cpix10 = lag(cpix,10) ;
cpix11 = lag(cpix,11) ;
cpix12 = lag(cpix,12) ;
cpix13 = lag(cpix,13) ;
cpix14 = lag(cpix,14) ;
cpix15 = lag(cpix,15) ;

% load monthly Brave-Butters-Kelley index
load ../data/bravebutterskelley.txt ;
bbk = bravebutterskelley(:,3) ;
bbk1 = lag(bbk) ;
bbk2 = lag(bbk,2) ;
bbk3 = lag(bbk,3) ;
bbk4 = lag(bbk,4) ;
bbk5 = lag(bbk,5) ;
bbk6 = lag(bbk,6) ;
