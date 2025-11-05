% Table 4C from Online Appendix

clear all ;
nstraps = 50000 ; % number of bootstrap replications for standard errors, set to 50,000 in the paper
rng(1,'twister') ; % set random number generator seed to reproduce bootstraps

dropintermeeting = 1 ;
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
trend = [1:j-i+1]'/1000 ;

% specification with omitted economic news variables controls:
X = [const, trend, Dunemp1(i:j), DGDP1(i:j), Dcpi1(i:j), ...
           mthlyunemp0(i:j), mthlynfp0(i:j), mthlygdp(i-1:j-1), bbk1(i:j), ...
           (cpix2(i:j)-2*cpix8(i:j)+cpix14(i:j))*200, mthlycpixexp(i:j), mthlycpix0(i:j), ...
           sp5003mchg(i:j)-sp500chg(i:j), sp500chg(i:j), slope3mchg(i:j)-slopechg(i:j), slopechg(i:j), ...
           bcom3mchg(i:j)-0.4*bcomag3mchg(i:j) - (bcomchg(i:j)-0.4*bcomagchg(i:j)), bcomchg(i:j)-0.4*bcomagchg(i:j)] ;
% X = [const, trend, Dunemp1(i:j), DGDP1(i:j), Dcpi1(i:j), ...
%     mthlyunemp0(i:j), mthlynfp0(i:j), mthlygdp(i-1:j-1), bbk1(i:j), ...
%     (cpix2(i:j)-2*cpix8(i:j)+cpix14(i:j))*200, mthlycpixexp(i:j), mthlycpix0(i:j), ...
%     sp5003mchg(i:j), slope3mchg(i:j), bcom3mchg(i:j)-0.4*bcomag3mchg(i:j)] ;  

nms = ["Constant", "Trend", "BC unemp FC rev", "BC GDP FC rev", "BC CPI FC rev", "unemp news", "payroll news", ...
         "GDP news", "BBK", "6m chg core CPI", "exp core CPI", "core CPI news", "SP500 ret up to beg of mth", "SP500 ret since beg of mth", ...
         "slope chg up to beg of mth", "slope chg since beg of mth", "commod ret up to beg of mth", "commod ret since beg of mth"];
% nms = ["Constant", "Trend", "BC unemp FC rev", "BC GDP FC rev", "BC CPI FC rev", "unemp news", "payroll news", ...
%          "GDP news", "BBK", "6m chg core CPI", "exp core CPI", "core CPI news", "SP500 ret", "chg slope", "commod ret"];

%nms = ["Constant", "Trend", "chg unemp", "GDP", "CPI", "unemp news", "payroll news", "GDP news", "BBK", "chg core CPI", "exp core CPI", "core CPI news", "SP500 ret", "chg slope", "comm ret"];
nms1 = [nms, "Target surprise", "Path surprise"];
nms2 = [nms, "NS surprise"];
N1 = length(nms1);
N2 = length(nms2);

%% regress Blue Chip forecast revision on Campbell et al MPS and omitted economic news:

fprintf('Regression of Blue Chip unemployment forecast revisions on macro data and Campbell et al. MP factors:\n') ;
nobs = sum(~isnan(Zmthly(i:j,1) + sum(X,2))) ;
[betacu,omegacu,stats,resids] = ols(Dunemp1yrns(i+1:j+1),[X,Zmthly(i:j,:)],0) ;
Dunemp1yrhat = Dunemp1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dunemp1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(size(X,2)+2,nstraps) ;
for strap = 1:nstraps ;
    Dunemp1yrbstr(ind-i+1,strap) = Dunemp1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
    betabstr(:,strap) = ols(Dunemp1yrbstr(:,strap), [X,Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = betacu ./ sebstr ; % bootstrapped t-statistics
for n=1:N1
    fprintf('%15s  ', nms1(n));
    fprintf('%+5.3f     (%5.3f),  tstat= % 4.2f \n', [betacu(n), sebstr(n),tstats(n)]') ;
end
fprintf('Observations:    %3i\n',nobs) ;
fprintf('R-squared:       %4.2f\n\n',stats(1)) ;

fprintf('Regression of Blue Chip GDP forecast revisions on macro data and Campbell et al. MP factors:\n') ;
[betacg,omegacg,stats,resids] = ols(DGDP1yrns(i+1:j+1),[X,Zmthly(i:j,:)],0) ;
DGDP1yrhat = DGDP1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
DGDP1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(size(X,2)+2,nstraps) ;
for strap = 1:nstraps ;
    DGDP1yrbstr(ind-i+1,strap) = DGDP1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
    betabstr(:,strap) = ols(DGDP1yrbstr(:,strap), [X,Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = betacg ./ sebstr ; % bootstrapped t-statistics
for n=1:N1
    fprintf('%15s  ', nms1(n));
    fprintf('%+5.3f     (%5.3f),  tstat= % 4.2f \n', [betacg(n), sebstr(n),tstats(n)]') ;
end
fprintf('Observations:    %3i\n',nobs) ;
fprintf('R-squared:       %4.2f\n\n',stats(1)) ;


fprintf('Regression of Blue Chip CPI forecast revisions on macro data and Campbell et al. MP factors:\n') ;
[betaci,omegaci,stats,resids] = ols(Dcpi1yrns(i+1:j+1),[X,Zmthly(i:j,:)],0) ;
Dcpi1yrhat = Dcpi1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dcpi1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(size(X,2)+2,nstraps) ;
for strap = 1:nstraps ;
    Dcpi1yrbstr(ind-i+1,strap) = Dcpi1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
    betabstr(:,strap) = ols(Dcpi1yrbstr(:,strap), [X,Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = betaci ./ sebstr ; % bootstrapped t-statistics
for n=1:N1
    fprintf('%15s  ', nms1(n));
    fprintf('%+5.3f     (%5.3f),  tstat= % 4.2f \n', [betaci(n), sebstr(n),tstats(n)]') ;
end
fprintf('Observations:    %3i\n',nobs) ;
fprintf('R-squared:       %4.2f\n\n',stats(1)) ;

%% regress Blue Chip forecast revision on Nakamura-Steinsson MPS and omitted economic news:

fprintf('Regression of Blue Chip unemployment forecast revisions on macro data and NS MP surprise:\n') ;
nobs = sum(~isnan(nsmpmthly(i:j) + sum(X,2))) ;
[betansu,omegansu,stats,resids] = ols(Dunemp1yrns(i+1:j+1),[X,nsmpmthly(i:j)],0) ;
Dunemp1yrhat = Dunemp1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dunemp1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(size(X,2)+1,nstraps) ;
for strap = 1:nstraps ;
    Dunemp1yrbstr(ind-i+1,strap) = Dunemp1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
    betabstr(:,strap) = ols(Dunemp1yrbstr(:,strap), [X,nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = betansu ./ sebstr ; % bootstrapped t-statistics
for n=1:N2
    fprintf('%15s  ', nms2(n));
    fprintf('%+5.3f     (%5.3f),  tstat= % 4.2f \n', [betansu(n), sebstr(n),tstats(n)]') ;
end
fprintf('Observations:    %3i\n',nobs) ;
fprintf('R-squared:       %4.2f\n\n',stats(1)) ;


fprintf('Regression of Blue Chip GDP forecast revisions on macro data and NS MP surprise:\n') ;
[betansg,omegansg,stats,resids] = ols(DGDP1yrns(i+1:j+1),[X,nsmpmthly(i:j)],0) ;
DGDP1yrhat = DGDP1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
DGDP1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(size(X,2)+1,nstraps) ;
for strap = 1:nstraps ;
    DGDP1yrbstr(ind-i+1,strap) = DGDP1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
    betabstr(:,strap) = ols(DGDP1yrbstr(:,strap), [X,nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = betansg ./ sebstr ; % bootstrapped t-statistics
for n=1:N2
    fprintf('%15s  ', nms2(n));
    fprintf('%+5.3f     (%5.3f),  tstat= % 4.2f \n', [betansg(n), sebstr(n),tstats(n)]') ;
end
fprintf('Observations:    %3i\n',nobs) ;
fprintf('R-squared:       %4.2f\n\n',stats(1)) ;


fprintf('Regression of Blue Chip CPI forecast revisions on macro data and NS MP surprise:\n') ;
[betansi,omegansi,stats,resids] = ols(Dcpi1yrns(i+1:j+1),[X,nsmpmthly(i:j)],0) ;
Dcpi1yrhat = Dcpi1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dcpi1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(size(X,2)+1,nstraps) ;
for strap = 1:nstraps ;
    Dcpi1yrbstr(ind-i+1,strap) = Dcpi1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
    betabstr(:,strap) = ols(Dcpi1yrbstr(:,strap), [X,nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = betansi ./ sebstr ; % bootstrapped t-statistics
for n=1:N2
    fprintf('%15s  ', nms2(n));
    fprintf('%+5.3f     (%5.3f),  tstat= % 4.2f \n', [betansi(n), sebstr(n),tstats(n)]') ;
end
fprintf('Observations:    %3i\n',nobs) ;
fprintf('R-squared:       %4.2f\n\n',stats(1)) ;
