% Table 1B from Online Appendix

% Replication of basic results in Cambpell et al (2012) and Nakamura-Steinsson (2018), and extension of those
%  results to the full sample, 1990-2019, with bootstrapped standard errors to take into account generated regressors.

clear all ;
nstraps = 50000 ; % number of boostraps used to compute standard errors, set to 50,000 in the paper
rng(1,'twister') ; % set random number generator seed to reproduce bootstraps

loadbluechipdata ;

%% Replicate Campbell et al result:

% Note: Campbell et al. probably did not use the NS timing convention for the 1-, 2-, 3-, and 4-quarter-ahead forecasts, but the
%  results are essentially the same using the NS timing convention, so for simplicity we're using the NS timing convention for the
%  Campbell et al regressions as well.

fprintf('\n') ;
fprintf('Panel (A): Campbell et al., replication sample (1990-6/2007, incl intermeeting):\n') ;

dropintermeeting = 0 ;
dropcrisistrough = 0 ;
dropfirstsevendays = 3 ;
startdate = [1994 1] ;
enddate = [2007 6] ;
loadhfmpdata ;

i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

[beta,~,stats,resids] = ols(Dunemp1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0) ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
Dunemp1yrhat = Dunemp1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dunemp1yrbstr = NaN(j-i+1,1,nstraps) ;
betabstr = NaN(3,nstraps) ;
for strap = 1:nstraps ;
  Dunemp1yrbstr(ind-i+1,strap) = Dunemp1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dunemp1yrbstr(:,strap), [ones(j-i+1,1), Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('                   Target factor                  Path factor\n') ;
fprintf('unemp Q1-3:   % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', [beta(2); sebstr(2); tstats(2); ...
                                                                                          beta(3); sebstr(3); tstats(3); stats(1); nobs]) ;

[beta,~,stats,resids] = ols(DGDP1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0) ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
DGDP1yrhat = DGDP1yrns(i+1:j+1) - resids ;
DGDP1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(3,nstraps) ;
for strap = 1:nstraps ;
  DGDP1yrbstr(ind-i+1,strap) = DGDP1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(DGDP1yrbstr(:,strap), [ones(j-i+1,1), Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('GDP Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', [beta(2); sebstr(2); tstats(2); ...
                                                                                          beta(3); sebstr(3); tstats(3); stats(1); nobs]) ;

[beta,~,stats,resids] = ols(Dcpi1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0) ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
Dcpi1yrhat = Dcpi1yrns(i+1:j+1) - resids ;
Dcpi1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(3,nstraps) ;
for strap = 1:nstraps ;
  Dcpi1yrbstr(ind-i+1,strap) = Dcpi1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dcpi1yrbstr(:,strap), [ones(j-i+1,1), Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('CPI Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', [beta(2); sebstr(2); tstats(2); ...
                                                                                          beta(3); sebstr(3); tstats(3); stats(1); nobs]) ;

%% Replicate NS result:

fprintf('\n\n') ;
fprintf('Panel (B): NS, replication sample (1995-3/2014, excl intermeeting, excl 7/2008-6/2009):\n') ;

dropintermeeting = 1 ;
dropcrisistrough = 1 ;
dropfirstsevendays = 1 ;
startdate = [1995 1] ;
enddate = [2014 3] ;
loadhfmpdata ;

i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

[beta,~,stats,resids] = ols(Dunemp1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0) ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
Dunemp1yrhat = Dunemp1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dunemp1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(2,nstraps) ;
for strap = 1:nstraps ;
  Dunemp1yrbstr(ind-i+1,strap) = Dunemp1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dunemp1yrbstr(:,strap), [ones(j-i+1,1), nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstat = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('                   NS MP surprise\n') ;
fprintf('unemp Q1-3:   %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', beta(2), sebstr(2), tstat(2), stats(1), nobs) ;

[beta,~,stats,resids] = ols(DGDP1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0) ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
DGDP1yrhat = DGDP1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
DGDP1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(2,nstraps) ;
for strap = 1:nstraps ;
  DGDP1yrbstr(ind-i+1,strap) = DGDP1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(DGDP1yrbstr(:,strap), [ones(j-i+1,1), nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstat = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('GDP Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', beta(2), sebstr(2), tstat(2), stats(1), nobs) ;

[beta,~,stats,resids] = ols(Dcpi1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0) ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
Dcpi1yrhat = Dcpi1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dcpi1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(2,nstraps) ;
for strap = 1:nstraps ;
  Dcpi1yrbstr(ind-i+1,strap) = Dcpi1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dcpi1yrbstr(:,strap), [ones(j-i+1,1), nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstat = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('CPI Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', beta(2), sebstr(2), tstat(2), stats(1), nobs) ;

%% Extend Campbell et al result to full sample:

fprintf('\n\n') ;
fprintf('Panel (C): Campbell et al., full sample (1990-2019, incl intermeeting, incl 7/2008-6/2009):\n') ;

dropintermeeting = 0 ;
dropcrisistrough = 0 ;
dropfirstsevendays = 0 ;
startdate = [1994 1] ;
enddate = [2019 6] ;
loadhfmpdata ;

i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

[beta,~,stats,resids] = ols(Dunemp1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0) ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
Dunemp1yrhat = Dunemp1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dunemp1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(3,nstraps) ;
for strap = 1:nstraps ;
  Dunemp1yrbstr(ind-i+1,strap) = Dunemp1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dunemp1yrbstr(:,strap), [ones(j-i+1,1), Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('                   Target factor                  Path factor\n') ;
fprintf('unemp Q1-3:   % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', [beta(2); sebstr(2); tstats(2); ...
                                                                                          beta(3); sebstr(3); tstats(3); stats(1); nobs]) ;

[beta,~,stats,resids] = ols(DGDP1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0) ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
DGDP1yrhat = DGDP1yrns(i+1:j+1) - resids ;
DGDP1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(3,nstraps) ;
for strap = 1:nstraps ;
  DGDP1yrbstr(ind-i+1,strap) = DGDP1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(DGDP1yrbstr(:,strap), [ones(j-i+1,1), Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('GDP Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', [beta(2); sebstr(2); tstats(2); ...
                                                                                          beta(3); sebstr(3); tstats(3); stats(1); nobs]) ;

[beta,~,stats,resids] = ols(Dcpi1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0) ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
Dcpi1yrhat = Dcpi1yrns(i+1:j+1) - resids ;
Dcpi1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(3,nstraps) ;
for strap = 1:nstraps ;
  Dcpi1yrbstr(ind-i+1,strap) = Dcpi1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dcpi1yrbstr(:,strap), [ones(j-i+1,1), Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('CPI Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', [beta(2); sebstr(2); tstats(2); ...
                                                                                          beta(3); sebstr(3); tstats(3); stats(1); nobs]) ;

%% Extend NS results to full sample:
fprintf('\n\n') ;
fprintf('Panel (C): NS, full sample (1990-2019, incl intermeeting, incl 7/2008-6/2009):\n') ;

[beta,~,stats,resids] = ols(Dunemp1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0) ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
Dunemp1yrhat = Dunemp1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dunemp1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(2,nstraps) ;
for strap = 1:nstraps ;
  Dunemp1yrbstr(ind-i+1,strap) = Dunemp1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dunemp1yrbstr(:,strap), [ones(j-i+1,1), nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstat = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('                   NS MP surprise\n') ;
fprintf('unemp Q1-3:   %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', beta(2), sebstr(2), tstat(2), stats(1), nobs) ;

[beta,~,stats,resids] = ols(DGDP1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0) ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
DGDP1yrhat = DGDP1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
DGDP1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(2,nstraps) ;
for strap = 1:nstraps ;
  DGDP1yrbstr(ind-i+1,strap) = DGDP1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(DGDP1yrbstr(:,strap), [ones(j-i+1,1), nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstat = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('GDP Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', beta(2), sebstr(2), tstat(2), stats(1), nobs) ;

[beta,~,stats,resids] = ols(Dcpi1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0) ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
Dcpi1yrhat = Dcpi1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dcpi1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(2,nstraps) ;
for strap = 1:nstraps ;
  Dcpi1yrbstr(ind-i+1,strap) = Dcpi1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dcpi1yrbstr(:,strap), [ones(j-i+1,1), nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstat = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('CPI Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', beta(2), sebstr(2), tstat(2), stats(1), nobs) ;


%% Extend Campbell et al result to full sample, excl intermeeting and incl 7/2009-6/2008:
fprintf('\n\n') ;
fprintf('Panel (D): Campbell et al., full sample (1990-2019, excl intermeeting, incl 7/2008-6/2009):\n') ;

dropintermeeting = 1 ;
dropcrisistrough = 0 ;
dropfirstsevendays = 0 ;
startdate = [1994 1] ;
enddate = [2019 6] ;
loadhfmpdata ;

i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

[beta,~,stats,resids] = ols(Dunemp1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0) ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
Dunemp1yrhat = Dunemp1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dunemp1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(3,nstraps) ;
for strap = 1:nstraps ;
  Dunemp1yrbstr(ind-i+1,strap) = Dunemp1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dunemp1yrbstr(:,strap), [ones(j-i+1,1), Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('                   Target factor                  Path factor\n') ;
fprintf('unemp Q1-3:   % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', [beta(2); sebstr(2); tstats(2); ...
                                                                                          beta(3); sebstr(3); tstats(3); stats(1); nobs]) ;

[beta,~,stats,resids] = ols(DGDP1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0) ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
DGDP1yrhat = DGDP1yrns(i+1:j+1) - resids ;
DGDP1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(3,nstraps) ;
for strap = 1:nstraps ;
  DGDP1yrbstr(ind-i+1,strap) = DGDP1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(DGDP1yrbstr(:,strap), [ones(j-i+1,1), Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('GDP Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', [beta(2); sebstr(2); tstats(2); ...
                                                                                          beta(3); sebstr(3); tstats(3); stats(1); nobs]) ;

[beta,~,stats,resids] = ols(Dcpi1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0) ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
Dcpi1yrhat = Dcpi1yrns(i+1:j+1) - resids ;
Dcpi1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(3,nstraps) ;
for strap = 1:nstraps ;
  Dcpi1yrbstr(ind-i+1,strap) = Dcpi1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dcpi1yrbstr(:,strap), [ones(j-i+1,1), Zmthlybstr(i:j,:,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstats = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('CPI Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', [beta(2); sebstr(2); tstats(2); ...
                                                                                          beta(3); sebstr(3); tstats(3); stats(1); nobs]) ;
fprintf('\n') ;


%% Extend NS results to same sample:

fprintf('\n') ;
fprintf('Panel (D): NS, full sample (1990-2019, excl intermeeting, incl 7/2008-6/2009):\n') ;

[beta,~,stats,resids] = ols(Dunemp1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0) ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
Dunemp1yrhat = Dunemp1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dunemp1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(2,nstraps) ;
for strap = 1:nstraps ;
  Dunemp1yrbstr(ind-i+1,strap) = Dunemp1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dunemp1yrbstr(:,strap), [ones(j-i+1,1), nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstat = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('                   NS MP surprise\n') ;
fprintf('unemp Q1-3:   %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', beta(2), sebstr(2), tstat(2), stats(1), nobs) ;

[beta,~,stats,resids] = ols(DGDP1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0) ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
DGDP1yrhat = DGDP1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
DGDP1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(2,nstraps) ;
for strap = 1:nstraps ;
  DGDP1yrbstr(ind-i+1,strap) = DGDP1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(DGDP1yrbstr(:,strap), [ones(j-i+1,1), nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstat = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('GDP Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', beta(2), sebstr(2), tstat(2), stats(1), nobs) ;

[beta,~,stats,resids] = ols(Dcpi1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0) ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
Dcpi1yrhat = Dcpi1yrns(i+1:j+1) - resids ;
ind = find(~isnan(nsmpmthly)) ;
Dcpi1yrbstr = NaN(j-i+1,nstraps) ;
betabstr = NaN(2,nstraps) ;
for strap = 1:nstraps ;
  Dcpi1yrbstr(ind-i+1,strap) = Dcpi1yrhat(ind-i+1) + resids(indmthlystrap(ind,strap)-i+1) ;
  betabstr(:,strap) = ols(Dcpi1yrbstr(:,strap), [ones(j-i+1,1), nsmpmthlybstr(i:j,strap)], 0) ;
end ;
sebstr = std(betabstr,0,2) ; % bootstrapped standard errors
tstat = beta ./ sebstr ; % bootstrapped t-statistics
fprintf('CPI Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f  nobs= %3i\n', beta(2), sebstr(2), tstat(2), stats(1), nobs) ;
