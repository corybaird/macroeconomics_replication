
% load Blue Chip GDP growth forecast data:

load ../data/confidential/BCEI_rgdp.txt
BCEI = BCEI_rgdp;
yr = BCEI(:,1) ;
mo = BCEI(:,2) ;
GDPn1 = BCEI(:,3) ;
GDP0 = BCEI(:,4) ;
GDP1 = BCEI(:,5) ;
GDP2 = BCEI(:,6) ;
GDP3 = BCEI(:,7) ;
GDP4 = BCEI(:,8) ;
GDP5 = BCEI(:,9) ;
GDP6 = BCEI(:,10) ;
GDP7 = BCEI(:,11) ;
GDPvec = BCEI(:,3:11) ;

date = yr + (mo-0.5)/12 ;

DGDP0alt = [NaN; diff(GDP0)] ;
 DGDP0 = DGDP0alt ;
 DGDP0(4:3:end) = GDPn1(4:3:end) - GDP0(3:3:end-1) ;
 DGDP0ns = DGDP0alt ;
 DGDP0ns(4:3:end) = GDP0(4:3:end) - GDP1(3:3:end-1) ;
DGDP1alt = [NaN; diff(GDP1)] ;
 DGDP1 = DGDP1alt ;
 DGDP1(4:3:end) = GDP0(4:3:end) - GDP1(3:3:end-1) ;
 DGDP1ns = DGDP1alt ;
 DGDP1ns(4:3:end) = GDP1(4:3:end) - GDP2(3:3:end-1) ;
DGDP2alt = [NaN; diff(GDP2)] ;
 DGDP2 = DGDP2alt ;
 DGDP2(4:3:end) = GDP1(4:3:end) - GDP2(3:3:end-1) ;
 DGDP2ns = DGDP2alt ;
 DGDP2ns(4:3:end) = GDP2(4:3:end) - GDP3(3:3:end-1) ;
DGDP3alt = [NaN; diff(GDP3)] ;
 DGDP3 = DGDP3alt ;
 DGDP3(4:3:end) = GDP2(4:3:end) - GDP3(3:3:end-1) ;
 DGDP3ns = DGDP3alt ;
 DGDP3ns(4:3:end) = GDP3(4:3:end) - GDP4(3:3:end-1) ;
DGDP4alt = [NaN; diff(GDP4)] ;
 DGDP4 = DGDP4alt ;
 DGDP4(4:3:end) = GDP3(4:3:end) - GDP4(3:3:end-1) ;
 DGDP4ns = DGDP4alt ;
 DGDP4ns(4:3:end) = GDP4(4:3:end) - GDP5(3:3:end-1) ;
DGDP5alt = [NaN; diff(GDP5)] ;
 DGDP5 = DGDP5alt ;
 DGDP5(4:3:end) = GDP4(4:3:end) - GDP5(3:3:end-1) ;
 DGDP5ns = DGDP5alt ;
 DGDP5ns(4:3:end) = GDP5(4:3:end) - GDP6(3:3:end-1) ;
DGDP6alt = [NaN; diff(GDP6)] ;
 DGDP6 = DGDP6alt ;
 DGDP6(4:3:end) = GDP5(4:3:end) - GDP6(3:3:end-1) ;
 DGDP6ns = DGDP6alt ;
 DGDP6ns(4:3:end) = GDP6(4:3:end) - GDP7(3:3:end-1) ;
DGDP7alt = [NaN; diff(GDP7)] ;
 DGDP7 = DGDP7alt ;
 DGDP7(4:3:end) = GDP6(4:3:end) - GDP7(3:3:end-1) ;
 DGDP7ns = DGDP7alt ;
 DGDP7ns(4:3:end) = NaN ;

DGDP1yrns = (DGDP1ns + DGDP2ns + DGDP3ns) /3 ;
DGDP1yrns4 = (DGDP0ns + DGDP1ns + DGDP2ns + DGDP3ns) /4 ;
DGDP1yrns4a = (DGDP1ns + DGDP2ns + DGDP3ns + DGDP4ns) /4 ;
DGDP1yr = (DGDP1 + DGDP2 + DGDP3) /3 ;
DGDP1yr4 = (DGDP0 + DGDP1 + DGDP2 + DGDP3) /4 ;


% load Blue Chip unemployment rate forecast data:

load ../data/confidential/BCEI_unemp.txt
yr = BCEI_unemp(:,1) ;
mo = BCEI_unemp(:,2) ;
unempn1 = BCEI_unemp(:,3) ;
unemp0 = BCEI_unemp(:,4) ;
unemp1 = BCEI_unemp(:,5) ;
unemp2 = BCEI_unemp(:,6) ;
unemp3 = BCEI_unemp(:,7) ;
unemp4 = BCEI_unemp(:,8) ;
unemp5 = BCEI_unemp(:,9) ;
unemp6 = BCEI_unemp(:,10) ;
unemp7 = BCEI_unemp(:,11) ;
unempvec = BCEI_unemp(:,3:11) ;

Dunemp0alt = [NaN; diff(unemp0)] ;
 Dunemp0 = Dunemp0alt ;
 Dunemp0(4:3:end) = unempn1(4:3:end) - unemp0(3:3:end-1) ;
 Dunemp0ns = Dunemp0alt ;
 Dunemp0ns(4:3:end) = unemp0(4:3:end) - unemp1(3:3:end-1) ;
Dunemp1alt = [NaN; diff(unemp1)] ;
 Dunemp1 = Dunemp1alt ;
 Dunemp1(4:3:end) = unemp0(4:3:end) - unemp1(3:3:end-1) ;
 Dunemp1ns = Dunemp1alt ;
 Dunemp1ns(4:3:end) = unemp1(4:3:end) - unemp2(3:3:end-1) ;
Dunemp2alt = [NaN; diff(unemp2)] ;
 Dunemp2 = Dunemp2alt ;
 Dunemp2(4:3:end) = unemp1(4:3:end) - unemp2(3:3:end-1) ;
 Dunemp2ns = Dunemp2alt ;
 Dunemp2ns(4:3:end) = unemp2(4:3:end) - unemp3(3:3:end-1) ;
Dunemp3alt = [NaN; diff(unemp3)] ;
 Dunemp3 = Dunemp3alt ;
 Dunemp3(4:3:end) = unemp2(4:3:end) - unemp3(3:3:end-1) ;
 Dunemp3ns = Dunemp3alt ;
 Dunemp3ns(4:3:end) = unemp3(4:3:end) - unemp4(3:3:end-1) ;
Dunemp4alt = [NaN; diff(unemp4)] ;
 Dunemp4 = Dunemp4alt ;
 Dunemp4(4:3:end) = unemp3(4:3:end) - unemp4(3:3:end-1) ;
 Dunemp4ns = Dunemp4alt ;
 Dunemp4ns(4:3:end) = unemp4(4:3:end) - unemp5(3:3:end-1) ;
Dunemp5alt = [NaN; diff(unemp5)] ;
 Dunemp5 = Dunemp5alt ;
 Dunemp5(4:3:end) = unemp4(4:3:end) - unemp5(3:3:end-1) ;
 Dunemp5ns = Dunemp5alt ;
 Dunemp5ns(4:3:end) = unemp5(4:3:end) - unemp6(3:3:end-1) ;
Dunemp6alt = [NaN; diff(unemp6)] ;
 Dunemp6 = Dunemp6alt ;
 Dunemp6(4:3:end) = unemp5(4:3:end) - unemp6(3:3:end-1) ;
 Dunemp6ns = Dunemp6alt ;
 Dunemp6ns(4:3:end) = unemp6(4:3:end) - unemp7(3:3:end-1) ;
Dunemp7alt = [NaN; diff(unemp7)] ;
 Dunemp7 = Dunemp7alt ;
 Dunemp7(4:3:end) = unemp6(4:3:end) - unemp7(3:3:end-1) ;
 Dunemp7ns = Dunemp7alt ;
 Dunemp7ns(4:3:end) = NaN ;

Dunemp1yrns = (Dunemp1ns + Dunemp2ns + Dunemp3ns) /3 ;
Dunemp1yrns4 = (Dunemp0ns + Dunemp1ns + Dunemp2ns + Dunemp3ns) /4 ;
Dunemp1yrns4a = (Dunemp1ns + Dunemp2ns + Dunemp3ns + Dunemp4ns) /4 ;
Dunemp1yr = (Dunemp1 + Dunemp2 + Dunemp3) /3 ;
Dunemp1yr4 = (Dunemp0 + Dunemp1 + Dunemp2 + Dunemp3) /4 ;


% load Blue Chip CPI inflation forecast data:

load ../data/confidential/BCEI_cpi.txt
yr = BCEI_cpi(:,1) ;
mo = BCEI_cpi(:,2) ;
cpin1 = BCEI_cpi(:,3) ;
cpi0 = BCEI_cpi(:,4) ;
cpi1 = BCEI_cpi(:,5) ;
cpi2 = BCEI_cpi(:,6) ;
cpi3 = BCEI_cpi(:,7) ;
cpi4 = BCEI_cpi(:,8) ;
cpi5 = BCEI_cpi(:,9) ;
cpi6 = BCEI_cpi(:,10) ;
cpi7 = BCEI_cpi(:,11) ;
cpivec = BCEI_cpi(:,3:11) ;

Dcpi0alt = [NaN; diff(cpi0)] ;
 Dcpi0 = Dcpi0alt ;
 Dcpi0(4:3:end) = cpin1(4:3:end) - cpi0(3:3:end-1) ;
 Dcpi0ns = Dcpi0alt ;
 Dcpi0ns(4:3:end) = cpi0(4:3:end) - cpi1(3:3:end-1) ;
Dcpi1alt = [NaN; diff(cpi1)] ;
 Dcpi1 = Dcpi1alt ;
 Dcpi1(4:3:end) = cpi0(4:3:end) - cpi1(3:3:end-1) ;
 Dcpi1ns = Dcpi1alt ;
 Dcpi1ns(4:3:end) = cpi1(4:3:end) - cpi2(3:3:end-1) ;
Dcpi2alt = [NaN; diff(cpi2)] ;
 Dcpi2 = Dcpi2alt ;
 Dcpi2(4:3:end) = cpi1(4:3:end) - cpi2(3:3:end-1) ;
 Dcpi2ns = Dcpi2alt ;
 Dcpi2ns(4:3:end) = cpi2(4:3:end) - cpi3(3:3:end-1) ;
Dcpi3alt = [NaN; diff(cpi3)] ;
 Dcpi3 = Dcpi3alt ;
 Dcpi3(4:3:end) = cpi2(4:3:end) - cpi3(3:3:end-1) ;
 Dcpi3ns = Dcpi3alt ;
 Dcpi3ns(4:3:end) = cpi3(4:3:end) - cpi4(3:3:end-1) ;
Dcpi4alt = [NaN; diff(cpi4)] ;
 Dcpi4 = Dcpi4alt ;
 Dcpi4(4:3:end) = cpi3(4:3:end) - cpi4(3:3:end-1) ;
 Dcpi4ns = Dcpi4alt ;
 Dcpi4ns(4:3:end) = cpi4(4:3:end) - cpi5(3:3:end-1) ;
Dcpi5alt = [NaN; diff(cpi5)] ;
 Dcpi5 = Dcpi5alt ;
 Dcpi5(4:3:end) = cpi4(4:3:end) - cpi5(3:3:end-1) ;
 Dcpi5ns = Dcpi5alt ;
 Dcpi5ns(4:3:end) = cpi5(4:3:end) - cpi6(3:3:end-1) ;
Dcpi6alt = [NaN; diff(cpi6)] ;
 Dcpi6 = Dcpi6alt ;
 Dcpi6(4:3:end) = cpi5(4:3:end) - cpi6(3:3:end-1) ;
 Dcpi6ns = Dcpi6alt ;
 Dcpi6ns(4:3:end) = cpi6(4:3:end) - cpi7(3:3:end-1) ;
Dcpi7alt = [NaN; diff(cpi7)] ;
 Dcpi7 = Dcpi7alt ;
 Dcpi7(4:3:end) = cpi6(4:3:end) - cpi7(3:3:end-1) ;
 Dcpi7ns = Dcpi7alt ;
 Dcpi7ns(4:3:end) = NaN ;

Dcpi1yrns = (Dcpi1ns + Dcpi2ns + Dcpi3ns) /3 ;
Dcpi1yrns4 = (Dcpi0ns + Dcpi1ns + Dcpi2ns + Dcpi3ns) /4 ;
Dcpi1yrns4a = (Dcpi1ns + Dcpi2ns + Dcpi3ns + Dcpi4ns) /4 ;
Dcpi1yr = (Dcpi1 + Dcpi2 + Dcpi3) /3 ;
Dcpi1yr4 = (Dcpi0 + Dcpi1 + Dcpi2 + Dcpi3) /4 ;


