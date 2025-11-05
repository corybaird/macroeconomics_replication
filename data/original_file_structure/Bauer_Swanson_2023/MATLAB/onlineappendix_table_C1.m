
clear all ;
startdate = [1990 1] ;
enddate = [2019 6] ;

%% BCEI data just for sample selection
% all other macro data go from 1980-1 to 2019-6
% BCEI data from 1980-1 to 2019-6 (can use same indices)
load ../data/confidential/BCEI_rgdp.txt
yr = BCEI_rgdp(:,1) ;
mo = BCEI_rgdp(:,2) ;

%% BCFF data -- need to line up information sets with these dates
load '../data/confidential/bcff_forecast_errors.txt';
bcerrors = bcff_forecast_errors(2:end,:);
bcyr = bcerrors(:,1);
bcmo = bcerrors(:,2);
bcdy = bcerrors(:,3);
e0 = bcerrors(:,4);
e1 = bcerrors(:,5);
e2 = bcerrors(:,6);
e3 = bcerrors(:,7);
e4 = bcerrors(:,8);

%% load macro data

% load monthly unemployment data
load ../data/Unemployment.txt ;
unemp = Unemployment(:,3) ;
unemp1 = lag(unemp) ;
unemp2 = lag(unemp,2) ;
unemp3 = lag(unemp,3) ;
unemp4 = lag(unemp,4) ;
unemp5 = lag(unemp,5) ;
unemp6 = lag(unemp,6) ;

load ../data/cpix.txt ;
cpix = log(cpix(:,3)) ;
cpix1 = lag(cpix) ;
cpix2 = lag(cpix,2) ;
cpix8 = lag(cpix,8) ;
cpix14 = lag(cpix,14) ;

% load monthly Brave-Butters-Kelley index
load ../data/bravebutterskelley.txt ;
bbk = bravebutterskelley(:,3) ;
bbk1 = lag(bbk) ;

%% load finance data
% load daily S&P500 data
load ../data/confidential/sp500.txt ;
sp500mo = sp500(:,1) ;
sp500dy = sp500(:,2) ;
sp500yr = sp500(:,3) ;
sp500 = log(sp500(:,4)) ;

% load daily Treasury yield curve slope data
load ../data/treasuryslope.txt ;
slopeyr = treasuryslope(:,1) ;
slopemo = treasuryslope(:,2) ;
slopedy = treasuryslope(:,3) ;
slope = treasuryslope(:,4) ;

% load daily commodity price index data:
load ../data/confidential/bcom.txt ;
bcommo = bcom(:,1) ;
bcomdy = bcom(:,2) ;
bcomyr = bcom(:,3) ;
bcomt = log(bcom(:,4)) ;
bcomsp = log(bcom(:,5)) ;
bcomag = log(bcom(:,6)) ;

% replace NaNs with previous day's value:
i = find(isnan(sp500)); sp500(i) = sp500(i-1) ;
i = find(isnan(slope)); slope(i) = slope(i-1) ;
i = find(isnan(bcomt)); bcomt(i) = bcomt(i-1) ;
i = find(isnan(bcomsp)); bcomsp(i) = bcomsp(i-1) ;
i = find(isnan(bcomag)); bcomag(i) = bcomag(i-1) ;

%% load MMS data
loadmmsdata ;

%% construct omitted variables
% compute monthly MMS Nonfarm Payrolls measure
i = find(~isnan(mmsnfp)) ;
i = i(1:end-2) ;
mthlynfp = [NaN(120,1); mmsnfp(i)] ; % Blue Chip regression data starts in Jan 1980; MMS data starts in Jan 1990
mthlynfpexp = [NaN(120,1); mmsnfpexp(i)] ;
mthlynfprel = [NaN(120,1); mmsnfprel(i)] ;
mthlyunemp = [NaN(120,1); mmsunemp(i)] ;
mthlyunempexp = [NaN(120,1); mmsunempexp(i)] ;
mthlyunemprel = [NaN(120,1); mmsunemprel(i)] ;

% Rescale NFP variables to make scale similar to BBK index and S&P500 change:
mthlynfpexp = mthlynfpexp/1000 ;
mthlynfprel = mthlynfprel/1000 ;
mthlynfp = mthlynfp/1000 ;

% compute monthly MMS CPI measures
i = find(~isnan(mmscpix)) ;
i = i(1:end-1) ;
mthlycpix = [NaN(120,1); mmscpix(i)] ; % Blue Chip regression data starts in Jan 1980; MMS data starts in Jan 1990
mthlycpixexp = [NaN(120,1); mmscpixexp(i)] ;
mthlycpixrel = [NaN(120,1); mmscpixrel(i)] ;

% compute monthly MMS GDP measure
mthlygdp = zeros(size(yr)) ;
mthlygdpexp = zeros(size(yr)) ;
mthlygdprel = zeros(size(yr)) ;
for i = 1:size(yr,1) ;
  gdpday = find(mmsyr==yr(i) & mmsmo==mo(i) & ~isnan(mmsgdprel)) ;
  if ~isempty(gdpday) ;
    if (mod(mo(i),3)==1); i1 = i ;
    elseif (mo(i)==2 & (yr(i)==1996 | yr(i)==2019)); i1 = i ; % GDP was released near the end of these months due to delays
    else i1 = i-1 ; % if GDP release date is early in following month, assign to end of prior month
    end ;
    mthlygdpexp(i1) = mmsgdpexp(gdpday) ;
    mthlygdprel(i1) = mmsgdprel(gdpday) ;
    mthlygdp(i1) = mmsgdp(gdpday) ;
  end 
end 

% for each FOMC announcement, compute change in S&P500, Baa spread, and 2Y Treasury over 3 months leading up to FOMC announcement:
sp5003mchg = zeros(size(yr)) ; % change these to NaNs if you want to drop months with no news
slope3mchg = zeros(size(yr)) ;
slope3mlev = zeros(size(yr)) ;
slopelev = zeros(size(yr)) ;
bcom3mchg = zeros(size(yr)) ;
bcomsp3mchg = zeros(size(yr)) ;
bcomag3mchg = zeros(size(yr)) ;
for i = 1:size(yr,1) 
  j = find(bcyr==yr(i) & bcmo==mo(i)) ;
  if (~isempty(j) & j(1)>3) 
    k2 = find(sp500yr==bcyr(j(1)) & sp500mo==bcmo(j(1)) & sp500dy<=bcdy(j(1))) ; % day of BCFF deadline
    sp5003mchg(i) = sp500(k2(end)) - sp500(k2(end)-65) ; % change in S&P500 over past 3 months
    k2 = find(slopeyr==bcyr(j(1)) & slopemo==bcmo(j(1)) & slopedy<=bcdy(j(1))) ;
    slope3mchg(i) = slope(k2(end)) - slope(k2(end)-65) ;
    slope3mlev(i) = slope(k2(end)-65) ;
    slopelev(i) = slope(k2(end)) ;
    k2 = find(bcomyr==bcyr(j(1)) & bcommo==bcmo(j(1)) & bcomdy<=bcdy(j(1))) ;
    bcom3mchg(i) = bcomt(k2(end)) - bcomt(k2(end)-65) ;
    bcomsp3mchg(i) = bcomsp(k2(end)) - bcomsp(k2(end)-65) ;
    bcomag3mchg(i) = bcomag(k2(end)) - bcomag(k2(end)-65) ;
  end 
end 

%% run predictive regressions 
i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

const = ones(j-i+1,1) ;

X = [const, ...
           mthlyunemp(i:j), mthlynfp(i:j),mthlygdp(i-1:j-1),  bbk1(i:j), ...
           (cpix2(i:j)-2*cpix8(i:j)+cpix14(i:j))*200, mthlycpixexp(i:j), mthlycpix(i:j), ...
           sp5003mchg(i:j), slope3mchg(i:j), bcom3mchg(i:j)-0.4*bcomag3mchg(i:j)] ;

i = find(bcyr==startdate(1) & bcmo==startdate(2)) ;
j = find(bcyr==enddate(1) & bcmo==enddate(2)) ;

% regress Blue Chip Financial Forecast consensus forecast errors for fed funds rate
% on on data in X, known prior to FOMC announcement:
fprintf('\n') ;
fprintf('Regression of BCFF forecast errors on macro data X:\n') ;
nobs = sum(~isnan(sum(bcerrors(i:j, 4:7),2) + sum(X,2))) ;
fprintf('# observations:  %3i',nobs) ;
fprintf('\n') ;

fprintf('\n') ;
fprintf('Next quarter:\n') ;
[betat,omegat,~,resids] = olshodrick(e1(i:j),X,1,0,6,1) ;

fprintf('\n') ;
fprintf('Two quarters ahead:\n') ;
[betat,omegat,~,resids] = olshodrick(e2(i:j),X,1,0,9,1) ;

fprintf('\n') ;
fprintf('Three quarters ahead:\n') ;
[betat,omegat,~,resids] = olshodrick(e3(i:j),X,1,0,12,1) ;

fprintf('\n') ;
fprintf('Four quarters ahead:\n') ;
[betat,omegat,~,resids] = olshodrick(e4(i:j),X,1,0,15,1) ;