
load ../data/confidential/tightalldata.txt

% drop 9/17/2001 from the analysis (also intermeeting):
i = find(tightalldata(:,1)==9 & tightalldata(:,2)==17 & tightalldata(:,3)==2001) ;
tightalldata = [tightalldata(1:i-1,:);tightalldata(i+1:end,:)] ;

% drop 11/25/2008 from the analysis (not an FOMC announcement):
i = find(tightalldata(:,1)==11 & tightalldata(:,2)==25 & tightalldata(:,3)==2008) ;
tightalldata = [tightalldata(1:i-1,:);tightalldata(i+1:end,:)] ;

% drop 12/1/2008 from the analysis (not an FOMC announcement):
i = find(tightalldata(:,1)==12 & tightalldata(:,2)==1 & tightalldata(:,3)==2008) ;
tightalldata = [tightalldata(1:i-1,:);tightalldata(i+1:end,:)] ;

% data for 1/22/2008 seems to have errors; fix it based on Kurov and Gu (2016 J Futures Markets):
 i = find(tightalldata(:,1)==1 & tightalldata(:,2)==22 & tightalldata(:,3)==2008) ;
 tightalldata(i,4) = -0.26; tightalldata(i,5) = -0.124; tightalldata(i,16) = 1.6 ;

% MP2 data for 3/11/2008 is off; fix it based on FF data in tightalldata20151031.xlsx:
 i = find(tightalldata(:,1)==3 & tightalldata(:,2)==11 & tightalldata(:,3)==2008) ;
 tightalldata(i,5) = 0.11 ;

% drop intermeeting FOMC announcements: (note 7/2/92 not really intermeeting, leave it in):
if dropintermeeting == 1 ;
 i = find((tightalldata(:,1)==7 & tightalldata(:,2)==13 & tightalldata(:,3)==1990) | ...
         (tightalldata(:,1)==10 & tightalldata(:,2)==29 & tightalldata(:,3)==1990) | ...
         (tightalldata(:,1)==12 & tightalldata(:,2)==7  & tightalldata(:,3)==1990) | ...
         (tightalldata(:,1)==1  & tightalldata(:,2)==8  & tightalldata(:,3)==1991) | ...
         (tightalldata(:,1)==2  & tightalldata(:,2)==1  & tightalldata(:,3)==1991) | ...
         (tightalldata(:,1)==3  & tightalldata(:,2)==8  & tightalldata(:,3)==1991) | ...
         (tightalldata(:,1)==4  & tightalldata(:,2)==30 & tightalldata(:,3)==1991) | ...
         (tightalldata(:,1)==8  & tightalldata(:,2)==6  & tightalldata(:,3)==1991) | ...
         (tightalldata(:,1)==9  & tightalldata(:,2)==13 & tightalldata(:,3)==1991) | ...
         (tightalldata(:,1)==10 & tightalldata(:,2)==30 & tightalldata(:,3)==1991) | ...
         (tightalldata(:,1)==12 & tightalldata(:,2)==6  & tightalldata(:,3)==1991) | ...
         (tightalldata(:,1)==12 & tightalldata(:,2)==20 & tightalldata(:,3)==1991) | ...
         (tightalldata(:,1)==4  & tightalldata(:,2)==9  & tightalldata(:,3)==1992) | ...
         (tightalldata(:,1)==9  & tightalldata(:,2)==4  & tightalldata(:,3)==1992) | ...
         (tightalldata(:,1)==4  & tightalldata(:,2)==18 & tightalldata(:,3)==1994) | ...
         (tightalldata(:,1)==10 & tightalldata(:,2)==15 & tightalldata(:,3)==1998) | ...
         (tightalldata(:,1)==1  & tightalldata(:,2)==3  & tightalldata(:,3)==2001) | ...
         (tightalldata(:,1)==4  & tightalldata(:,2)==18 & tightalldata(:,3)==2001) | ...
         (tightalldata(:,1)==8  & tightalldata(:,2)==10 & tightalldata(:,3)==2007) | ...
         (tightalldata(:,1)==8  & tightalldata(:,2)==17 & tightalldata(:,3)==2007) | ...
         (tightalldata(:,1)==1  & tightalldata(:,2)==22 & tightalldata(:,3)==2008) | ...
         (tightalldata(:,1)==3  & tightalldata(:,2)==11 & tightalldata(:,3)==2008) | ...
         (tightalldata(:,1)==10 & tightalldata(:,2)==8  & tightalldata(:,3)==2008) | ...
         (tightalldata(:,1)==12  & tightalldata(:,2)==1 & tightalldata(:,3)==2008)) ;
 j = setdiff([1:size(tightalldata,1)],i) ;
 tightalldata = tightalldata(j,:) ;
end ;

% drop FOMC announcements from 7/2008 through 6/2009:
if dropcrisistrough == 1 ;
 i = find(tightalldata(:,3)<2008 | tightalldata(:,3)>2009 | ...
        (tightalldata(:,3)==2008 & tightalldata(:,1)<7) | ...
        (tightalldata(:,3)==2009 & tightalldata(:,1)>6) ) ;
 tightalldata = tightalldata(i,:) ;
end ;

% set sample start date and end date for FOMC announcement surprises:
i = find((tightalldata(:,3)>startdate(1) | (tightalldata(:,3)==startdate(1) & tightalldata(:,1)>=startdate(2))) & ...
         (tightalldata(:,3)<enddate(1) | (tightalldata(:,3)==enddate(1) & tightalldata(:,1)<=enddate(2)))) ;
tightalldata = tightalldata(i,:) ;

mpmo = tightalldata(:,1) ;
mpdy = tightalldata(:,2) ;
mpyr = tightalldata(:,3) ;
mp1 = tightalldata(:,4) ;
mp2 = tightalldata(:,5) ;
ed1 = tightalldata(:,6) ;
ed2 = tightalldata(:,7) ;
ed3 = tightalldata(:,8) ;
ed4 = tightalldata(:,9) ;

% Extract first principal component from [mp1 mp2 ed2 ed3 ed4] to get NS mp surprise:
X = [mp1 mp2 ed2 ed3 ed4] ;
X = (X - repmat(mean(X),size(X(:,1)))) /diag(std(X)) ; % standardize X
nsmp = extract(X,1) ; % NS MP shock is just first principal component

% compute GSS target and path factors, contained in variable Z:
[Fraw,lambda] = extract(X,2) ;
F = Fraw /diag(std(Fraw)) ;
g = ols(mp1,F,0) ;
alpha1 = sqrt(1/(1+(g(2)/g(1))^2)) ;
alpha2 = alpha1 * g(2)/g(1) ;
U = [alpha1  sqrt(1/(1+(alpha1/alpha2)^2)); alpha2  -alpha1/alpha2/sqrt((1+(alpha1/alpha2)^2)) ] ;
Z = F*U ;
b1tmp = ols(mp1,Z,0) ;
b2tmp = ols(ed4,Z,0) ;
Z = Z *diag([b1tmp(1) b2tmp(2)]) ; % rescale Z to have unit effect on mp1, ed4, respectively


% Rescale NS MP surprise to have unit effect on GSW 1Y Treasury yield:

% load GSW yield data
load ../data/gswyields.txt ;
gswyr = gswyields(:,1) ;
gswmo = gswyields(:,2) ;
gswdy = gswyields(:,3) ;
gsw1y = gswyields(:,4) ;
i = find(isnan(gsw1y)) ;
gsw1y(i) = gsw1y(i-1) ;
Dgsw1y = [NaN;diff(gsw1y)] ;

Dtres1 = NaN(size(mpmo)) ;
for i = 1:size(mpmo,1) ;
  j = find(gswyr==mpyr(i) & gswmo==mpmo(i) & gswdy==mpdy(i)) ;
  Dtres1(i,1) = Dgsw1y(j) ;
end ;

% rescale nsmp to have unit effect on GSW 1Y Treasury yield:
[beta,~,~,tresresids] = ols(Dtres1,[ones(size(nsmp)),nsmp],0) ;
nsmp = nsmp * beta(2) ;

% convert MP series to monthly frequency for Blue Chip regressions:
nsmpforbc = nsmp ;
Zforbc = Z ;
if dropfirstsevendays == 1 ;
  dropind = find(mpdy<8) ; % drop observations from first 7 days of each month, as in NS
elseif dropfirstsevendays == 3 ;  % drop observations from first 3 business days of each month, as in
  dropind = find(mpdy<4 | ...     %                         Campbell et al. (2012) and Lunsford (2019).
                 (mpyr<=2000 & mpdy<4) | ...
                 (mpyr==1990 & mpmo==7 & mpdy==5) | ...
                 (mpyr==1994 & mpmo==7 & mpdy==6) | ...
                 (mpyr==1995 & mpmo==7 & mpdy==6) | ...
                 (mpyr==1997 & mpmo==2 & mpdy==5) | ...
                 (mpyr==1998 & mpmo==2 & mpdy==4) | ...
                 (mpyr==1999 & mpmo==10 & mpdy==5) | ...
                 (mpyr==2004 & mpmo==5 & mpdy==4)) ;
else ;  % drop observations from first 3 business days (pre-12/2000) or 2 business days (post-11/2000) of each month
  dropind = find(mpdy<3 | ...
                 (mpyr<=2000 & mpdy<4) | ...
                 (mpyr==1990 & mpmo==7 & mpdy==5) | ...
                 (mpyr==1994 & mpmo==7 & mpdy==6) | ...
                 (mpyr==1995 & mpmo==7 & mpdy==6) | ...
                 (mpyr==1997 & mpmo==2 & mpdy==5) | ...
                 (mpyr==1998 & mpmo==2 & mpdy==4) | ...
                 (mpyr==1999 & mpmo==10 & mpdy==5) | ...
                 (mpyr==2004 & mpmo==5 & mpdy==4)) ;
end ;
nsmpforbc(dropind) = NaN ;
Zforbc(dropind,:) = NaN(length(dropind),2) ;
nsmpmthly = NaN(size(yr)) ;
Zmthly = NaN(size(yr,1),2) ;
for i = 1:size(yr,1) ;
  j = find(mpyr==yr(i) & mpmo==mo(i)) ;
  if (length(j)==1) ;
    nsmpmthly(i,1) = nsmpforbc(j) ;
    Zmthly(i,:) = Zforbc(j,:) ;
  elseif (length(j)>1) ; % if there's more than one FOMC announcement in a given month, add up the surprises
    nsmpmthly(i,1) = sum(nantozip(nsmpforbc(j))) ; % need to convert NaNs to 0s when doing sum
    Zmthly(i,:) = sum(nantozip(Zforbc(j,:))) ;
  end ;
end ;


%
% create bootstrap MP data using the factor model and the residuals:
%

  Xresids = X - Fraw*lambda ;
  Xlen = size(X,1) ;
  indstrap = randi(Xlen,[Xlen,nstraps]) ;

  Dtres1hat = Dtres1 - tresresids ;
  [~,~,~,mp1resids] = ols(mp1,[ones(size(F(:,1))),F],0) ;
  mp1hat = mp1 - mp1resids ;
  [~,~,~,ed4resids] = ols(ed4,[ones(size(Z(:,1))),Z],0) ;
  ed4hat = ed4 - ed4resids ;
  Xbstr = NaN(Xlen,size(X,2),nstraps) ;
  Dtres1bstr = NaN(Xlen,nstraps) ;
  mp1bstr = NaN(Xlen,nstraps) ;
  ed4bstr = NaN(Xlen,nstraps) ;
  for strap = 1:nstraps ;
    Xbstr(:,:,strap) = Fraw*lambda + Xresids(indstrap(:,strap),:) ;
    Dtres1bstr(:,strap) = Dtres1hat + tresresids(indstrap(:,strap)) ;
    mp1bstr(:,strap) = mp1hat + mp1resids(indstrap(:,strap)) ;
    ed4bstr(:,strap) = ed4hat + ed4resids(indstrap(:,strap)) ;
  end ;
  Xbstrnorm = (Xbstr - repmat(mean(Xbstr),[Xlen,1,1])) ./ repmat(std(Xbstr),[Xlen,1,1]) ;

  nsmpbstr = NaN(Xlen,nstraps) ;
  Fbstr = NaN(Xlen,2,nstraps) ;
  lambdabstr = NaN(2,size(X,2),nstraps) ;
  Zbstr = NaN(Xlen,2,nstraps) ;
  for strap = 1:nstraps ;
    nsmpbstr(:,strap) = extract(Xbstrnorm(:,:,strap),1) ; % NS MP shock is first principal component
    beta = ols(Dtres1bstr(:,strap),[ones(Xlen,1),nsmpbstr(:,strap)],0) ;
    nsmpbstr(:,strap) = nsmpbstr(:,strap) * beta(2) ; % rescale to have unit effect on GSW 1Y Treasury yield

    [Fstrap,lambdastrap] = extract(Xbstrnorm(:,:,strap),2) ;
    Fbstr(:,:,strap) = Fstrap ;
    lambdabstr(:,:,strap) = lambdastrap ;
    Fbstr(:,:,strap) = Fbstr(:,:,strap) /diag(std(Fbstr(:,:,strap))) ;
    g = ols(mp1bstr(:,strap),Fbstr(:,:,strap),0) ;
    alpha1 = sqrt(1/(1+(g(2)/g(1))^2)) ;
    alpha2 = alpha1 * g(2)/g(1) ;
    U = [alpha1  sqrt(1/(1+(alpha1/alpha2)^2)); alpha2  -alpha1/alpha2/sqrt((1+(alpha1/alpha2)^2)) ] ;
    Zbstr(:,:,strap) = Fbstr(:,:,strap)*U ;
    b1tmp = ols(mp1bstr(:,strap),Zbstr(:,:,strap),0) ;
    b2tmp = ols(ed4bstr(:,strap),Zbstr(:,:,strap),0) ;
    Zbstr(:,:,strap) = Zbstr(:,:,strap) *diag([b1tmp(1) b2tmp(2)]) ; % rescale Z to have unit effect on mp1, ed4
  end ;

  % convert bootstrap MP series to monthly frequency for Blue Chip regressions:
  nsmpforbc = nsmpbstr ;
  Zforbc = Zbstr ;
  nsmpforbc(dropind,:) = NaN(length(dropind),nstraps) ;  % the timing of the synthetic announcements is same as for the original data,
  Zforbc(dropind,:,:) = NaN(length(dropind),2,nstraps) ; % so we need to drop synthetic announcements that occur in first few days of each month
  
  nsmpmthlybstr = NaN(size(yr,1),nstraps) ;
  Zmthlybstr = NaN(size(yr,1),2,nstraps) ;
  for i = find(~isnan(nsmpmthly))' ;
    j = find(mpyr==yr(i) & mpmo==mo(i)) ;
    nsmpmthlybstr(i,:) = sum(nsmpforbc(j,:),1) ; % if more than one FOMC announcement in a month, add up the surprises
    Zmthlybstr(i,:,:) = sum(Zforbc(j,:,:),1) ;
  end ;

  % for monthly regressions (like predicting Blue Chip forecasts), we need to bootstrap the monthly observations, so we need to
  %  convert the monetary policy frequency bootstrap indexes above to monthly frequency.
  indmthlystrap = NaN(size(nsmpmthly,1),nstraps) ;
  for i = find(~isnan(nsmpmthly))' ;
    j = find(mpyr==yr(i) & mpmo==mo(i)) ;
    yrstrap = mpyr(indstrap(j(1),:)) ;
    mostrap = mpmo(indstrap(j(1),:)) ;
    for strap = 1:nstraps ;
      indmthlystrap(i,strap) = find(yr==yrstrap(strap) & mo==mostrap(strap)) ;
    end ;
  end ;

