% Table 1A from Online Appendix

% Replication of basic results in Cambpell et al (2012) and Nakamura-Steinsson (2018), and extension of those
%  results to the full sample, 1990-2019, with bootstrapped standard errors to take into account generated regressors.

clear all ;
bootstrapfl = 0 ;
nstraps = 0 ;

loadbluechipdata ;


% Replicate Campbell et al result:

% Note: Campbell et al. probably did not use the NS timing convention for the 1-, 2-, 3-, and 4-quarter-ahead forecasts, but the
%  results are essentially the same using the NS timing convention, so for simplicity we're using the NS timing convention for the
%  Campbell et al regressions as well.

dropintermeeting = 0 ;
dropcrisistrough = 0 ;
dropfirstsevendays = 3 ;
startdate = [1990 1] ;
enddate = [2007 6] ;
loadhfmpdata ;

i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

[betatmp,setmp,stats] = olshodrick(Dunemp1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('\n') ;
fprintf('Campbell et al., replication sample (1990-6/2007, incl intermeeting):\n') ;
fprintf('                   Target factor                  Path factor\n') ;
fprintf('unemp Q1-3:   % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;
[betatmp,setmp,stats] = olshodrick(DGDP1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('GDP Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;

[betatmp,setmp,stats] = olshodrick(Dcpi1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('CPI Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;
fprintf('\n') ;


% Replicate NS result:

dropintermeeting = 1 ;
dropcrisistrough = 1 ;
dropfirstsevendays = 1 ;
startdate = [1995 1] ;
enddate = [2014 3] ;
loadhfmpdata ;

i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

[betatmp,setmp,stats] = olshodrick(Dunemp1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('\n') ;
fprintf('NS, replication sample (1995-3/2014, excl intermeeting, excl 7/2008-6/2009):\n') ;
fprintf('                   NS MP surprise\n') ;
fprintf('unemp Q1-3:   %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;

[betatmp,setmp,stats] = olshodrick(DGDP1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('GDP Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;

[betatmp,setmp,stats] = olshodrick(Dcpi1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('CPI Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;
fprintf('\n') ;



% Extend Campbell et al result to full sample:

dropintermeeting = 0 ;
dropcrisistrough = 0 ;
dropfirstsevendays = 0 ;
startdate = [1990 1] ;
enddate = [2019 6] ;
loadhfmpdata ;

i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

[betatmp,setmp,stats] = olshodrick(Dunemp1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('\n') ;
fprintf('Campbell et al., full sample (1990-2019, incl intermeeting):\n') ;
fprintf('                   Target factor                  Path factor\n') ;
fprintf('unemp Q1-3:   % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;

[betatmp,setmp,stats] = olshodrick(DGDP1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('GDP Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;

[betatmp,setmp,stats] = olshodrick(Dcpi1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('CPI Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;
fprintf('\n') ;


% Extend NS results to full sample:

[betatmp,setmp,stats] = olshodrick(Dunemp1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('\n') ;
fprintf('NS, full sample (1990-2019, incl intermeeting, incl 7/2008-6/2009):\n') ;
fprintf('                   NS MP surprise\n') ;
fprintf('unemp Q1-3:   %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;

[betatmp,setmp,stats] = olshodrick(DGDP1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('GDP Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;

[betatmp,setmp,stats] = olshodrick(Dcpi1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('CPI Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;
fprintf('\n') ;


% Extend Campbell et al result to full sample, excl intermeeting and incl 7/2009-6/2008:

dropintermeeting = 1 ;
dropcrisistrough = 0 ;
dropfirstsevendays = 0 ;
startdate = [1990 1] ;
enddate = [2019 6] ;
loadhfmpdata ;

i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

[betatmp,setmp,stats] = olshodrick(Dunemp1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('\n') ;
fprintf('Campbell et al., full sample (1990-2019, excl intermeeting, incl 7/2008-6/2009):\n') ;
fprintf('                   Target factor                  Path factor\n') ;
fprintf('unemp Q1-3:   % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;

[betatmp,setmp,stats] = olshodrick(DGDP1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('GDP Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;

[betatmp,setmp,stats] = olshodrick(Dcpi1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('CPI Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;
fprintf('\n') ;

% Extend NS results to same sample:

[betatmp,setmp,stats] = olshodrick(Dunemp1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('\n') ;
fprintf('NS, full sample (1990-2019, excl intermeeting, incl 7/2008-6/2009):\n') ;
fprintf('                   NS MP surprise\n') ;
fprintf('unemp Q1-3:   %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;

[betatmp,setmp,stats] = olshodrick(DGDP1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('GDP Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;

[betatmp,setmp,stats] = olshodrick(Dcpi1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('CPI Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;
fprintf('\n') ;




% Extend Campbell et al result to full sample, excl intermeeting and excl 7/2009-6/2008:

dropintermeeting = 1 ;
dropcrisistrough = 1 ;
dropfirstsevendays = 0 ;
startdate = [1990 1] ;
enddate = [2019 6] ;
loadhfmpdata ;

i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

[betatmp,setmp,stats] = olshodrick(Dunemp1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('\n') ;
fprintf('Campbell et al., full sample (1990-2019, excl intermeeting, excl 7/2008-6/2009):\n') ;
fprintf('                   Target factor                  Path factor\n') ;
fprintf('unemp Q1-3:   % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;

[betatmp,setmp,stats] = olshodrick(DGDP1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('GDP Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;

[betatmp,setmp,stats] = olshodrick(Dcpi1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('CPI Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;
fprintf('\n') ;

% Extend NS results to same sample:

[betatmp,setmp,stats] = olshodrick(Dunemp1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('\n') ;
fprintf('NS, full sample (1990-2019, excl intermeeting, excl 7/2008-6/2009):\n') ;
fprintf('                   NS MP surprise\n') ;
fprintf('unemp Q1-3:   %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;

[betatmp,setmp,stats] = olshodrick(DGDP1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('GDP Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;

[betatmp,setmp,stats] = olshodrick(Dcpi1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('CPI Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;
fprintf('\n') ;



% Extend Campbell et al result to full sample, incl intermeeting and excl 7/2009-6/2008:

dropintermeeting = 0 ;
dropcrisistrough = 1 ;
dropfirstsevendays = 0 ;
startdate = [1990 1] ;
enddate = [2019 6] ;
loadhfmpdata ;

i = find(yr==startdate(1) & mo==startdate(2)) ;
j = find(yr==enddate(1) & mo==enddate(2)) ;

[betatmp,setmp,stats] = olshodrick(Dunemp1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('\n') ;
fprintf('Campbell et al., full sample (1990-2019, incl intermeeting, excl 7/2008-6/2009):\n') ;
fprintf('                   Target factor                  Path factor\n') ;
fprintf('unemp Q1-3:   % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;

[betatmp,setmp,stats] = olshodrick(DGDP1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('GDP Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;

[betatmp,setmp,stats] = olshodrick(Dcpi1yrns(i+1:j+1),[ones(j-i+1,1),Zmthly(i:j,:)],0); beta = betatmp'; se = sqrt(diag(setmp))' ;
tstats = beta ./se ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + Zmthly(i:j,1))) ;
fprintf('CPI Q1-3:     % 5.3f  (%5.3f)  t= % 4.2f     % 5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f     nobs= %3i\n', [beta(:,2)'; se(:,2)'; tstats(:,2)'; ...
                                                                                          beta(:,3)'; se(:,3)'; tstats(:,3)'; stats(1); nobs]) ;
fprintf('\n') ;

% Extend NS results to same sample:

[betatmp,setmp,stats] = olshodrick(Dunemp1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(Dunemp1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('\n') ;
fprintf('NS, full sample (1990-2019, incl intermeeting, excl 7/2008-6/2009):\n') ;
fprintf('                   NS MP surprise\n') ;
fprintf('unemp Q1-3:   %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;

[betatmp,setmp,stats] = olshodrick(DGDP1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(DGDP1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('GDP Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;


[betatmp,setmp,stats] = olshodrick(Dcpi1yrns(i+1:j+1),[ones(size(nsmpmthly(i:j))),nsmpmthly(i:j)],0); NS3beta(1) = betatmp(2); NS3se(1) = sqrt(setmp(2,2)) ;
nobs = sum(~isnan(Dcpi1yrns(i+1:j+1) + nsmpmthly(i:j))) ;
fprintf('CPI Q1-3:      %5.3f  (%5.3f)  t= % 4.2f   R^2= %4.2f      nobs= %3i\n', NS3beta, NS3se, NS3beta/NS3se, stats(1), nobs) ;
fprintf('\n') ;

