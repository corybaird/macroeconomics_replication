% Table 3A from Online Appendix

clear all ;
nstraps = 50000 ; % number of bootstap replications to compute standard errors, set to 50,000 in the paper
rng(1,'twister') ; % set random number generator seed to reproduce bootstraps

dropintermeeting = 0 ;
dropcrisistrough = 0 ;
dropfirstsevendays = 0 ; % use 1 for NS replication sample, 3 for Campbell et al replication sample
startdate = [1990 1] ;
enddate = [2019 6] ;

loadbluechipdata ;
loadhfmpdata ;
loadmacrodata ;
loadfinancedata ;
loadmmsdata ;
constructomittedvars ;

i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

const = ones(size(nsmpmthly(i:j))) ;
trend = [1:j-i+1]' ;

% data for forecasting monetary policy surprises:
X = [const, ...
           mthlyunemp0(i:j), mthlynfp0(i:j), mthlygdp(i-1:j-1), bbk1(i:j), ...
           (cpix2(i:j)-2*cpix8(i:j)+cpix14(i:j))*200, mthlycpixexp(i:j), mthlycpix0(i:j), ...
           sp5003mchg(i:j)-sp500chg(i:j), sp500(i:j), slope3mchg(i:j)-slopechg(i:j), slopechg(i:j), ...
           (bcom3mchg(i:j)-0.4*bcomag3mchg(i:j)) - (bcomchg(i:j)-0.4*bcomagchg(i:j)), bcomchg(i:j)-0.4*bcomagchg(i:j)] ;

% X = [const, ...
%     mthlyunemp0(i:j), mthlynfp0(i:j), mthlygdp(i-1:j-1), bbk1(i:j), ...
%     (cpix2(i:j)-2*cpix8(i:j)+cpix14(i:j))*200, mthlycpixexp(i:j), mthlycpix0(i:j), ...
%     sp5003mchg(i:j), slope3mchg(i:j), bcom3mchg(i:j)-0.4*bcomag3mchg(i:j)] ;

nms = ["Constant", "unemp news", "payroll news", "GDP news", "BBK", "6m chg core CPI", "exp core CPI", "core CPI news", ...
         "SP500 ret up to beg of mth", "SP500 ret since beg of mth", "slope chg up to beg of mth", "slope chg since beg of mth", ...
         "commod ret up to beg of mth", "commod ret since beg of mth"];
%nms = ["Constant", "unemp news", "payroll news", "GDP news", "BBK", "6m chg core CPI", "exp core CPI", "core CPI news", "SP500 ret", "chg slope", "commod ret"];
N = length(nms);

%% regress monetary policy surprise on data in X, known prior to FOMC announcement:
fprintf('Regression of Campbell et al. target factor surprise on macro data:\n') ;
[betat,omegat,stats,resids] = ols(Zmthly(i:j,1),X,0) ;
Zhat = Zmthly(i:j,1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Zhatbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(size(X,2),nstraps) ;
for strap = 1:nstraps ;
    Zhatbstr(ind-i+1,strap) = Zhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) + Zmthlybstr(ind,1,strap) - Zmthly(ind,1) ;
    betabstr(:,strap) = ols(Zhatbstr(:,strap), X, 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = betat ./ sebstr ; % bootstrapped t-statistics
for n=1:N
    fprintf('%15s  ', nms(n));
    fprintf('%+5.3f     (%5.3f),  tstat= % 4.2f \n', [betat(n), sebstr(n),tstats(n)]') ;
end
nobs = sum(~isnan(Zmthly(i:j,1) + sum(X,2))) ;
fprintf('Observations:    %3i\n',nobs) ;
fprintf('R-squared:       %4.2f\n\n',stats(1)) ;

fprintf('Regression of Campbell et al. path factor surprise on macro data:\n') ;
[betap,omegap,stats,resids] = ols(Zmthly(i:j,2),X,0) ;
Zhat = Zmthly(i:j,2) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Zhatbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(size(X,2),nstraps) ;
for strap = 1:nstraps ;
    Zhatbstr(ind-i+1,strap) = Zhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) + Zmthlybstr(ind,2,strap) - Zmthly(ind,2) ;
    betabstr(:,strap) = ols(Zhatbstr(:,strap), X, 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = betap ./ sebstr ; % bootstrapped t-statistics
for n=1:N
    fprintf('%15s  ', nms(n));
    fprintf('%+5.3f     (%5.3f),  tstat= % 4.2f \n', [betap(n), sebstr(n),tstats(n)]') ;
end
nobs = sum(~isnan(Zmthly(i:j,2) + sum(X,2))) ;
fprintf('Observations:    %3i\n',nobs) ;
fprintf('R-squared:       %4.2f\n\n',stats(1)) ;

fprintf('Regression of NS MP surprise on macro data:\n') ;
[betans,omegans,stats,resids] = ols(nsmpmthly(i:j),X, 0) ;
nsmphat = nsmpmthly(i:j) - resids ;
ind = find(~isnan(nsmpmthly)) ;
nsmphatbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(size(X,2),nstraps) ;
for strap = 1:nstraps ;
    nsmphatbstr(ind-i+1,strap) = nsmphat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) + nsmpmthlybstr(ind,strap) - nsmpmthly(ind) ;
    betabstr(:,strap) = ols(nsmphatbstr(:,strap), X, 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = betans ./ sebstr ; % bootstrapped t-statistics
for n=1:N
    fprintf('%15s  ', nms(n));
    fprintf('%+5.3f     (%5.3f),  tstat= % 4.2f \n', [betans(n), sebstr(n),tstats(n)]') ;
end
nobs = sum(~isnan(nsmpmthly(i:j) + sum(X,2))) ;
fprintf('Observations:    %3i\n',nobs) ;
fprintf('R-squared:       %4.2f\n\n',stats(1)) ;
