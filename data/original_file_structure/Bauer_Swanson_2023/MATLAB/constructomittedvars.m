

% compute monthly MMS Nonfarm Payrolls measure
i = find(~isnan(mmsnfp)) ;
i = i(1:end-2) ;
mthlynfp = [NaN(120,1); mmsnfp(i)] ; % Blue Chip regression data starts in Jan 1980; MMS data starts in Jan 1990
mthlyunemp = [NaN(120,1); mmsunemp(i)] ;

% for each FOMC announcement, compute Employment Report news released between Blue Chip forecast and FOMC announcement:
mthlynfp0 = zeros(size(yr)) ;
mthlyunemp0 = zeros(size(yr)) ;
for i = 1:size(yr,1) ;
  if (yr(i)<2000 | (yr(i)==2000 & mo(i)<12)), bcdone = 3 ; % Blue Chip survey took 3 bus days until Dec 2000, then 2 bus days
  else bcdone = 2 ;
  end ;
  j = find(mpyr==yr(i) & mpmo==mo(i)) ;
  if (~isempty(j)) ;
    k = find(gswyr==yr(i) & gswmo==mo(i)) ;
    nfpday = find(mmsyr==yr(i) & mmsmo==mo(i) & mmsdy<=mpdy(j(1)) & ~isnan(mmsnfprel)) ;
    if ~isempty(nfpday) ;
      mthlynfp0(i) = mmsnfp(nfpday) ;
      mthlyunemp0(i) = mmsunemp(nfpday) ;
    end ;
  end ;
end ;

% Rescale NFP variables to make scale similar to BBK index and S&P500 change:
mthlynfp0 = mthlynfp0/1000 ;

% compute monthly MMS CPI measures
i = find(~isnan(mmscpix)) ;
i = i(1:end-1) ;
mthlycpix = [NaN(120,1); mmscpix(i)] ; % Blue Chip regression data starts in Jan 1980; MMS data starts in Jan 1990
mthlycpixexp = [NaN(120,1); mmscpixexp(i)] ;
mthlycpixrel = [NaN(120,1); mmscpixrel(i)] ;

% for each FOMC announcement, compute CPI news released between Blue Chip forecast and FOMC announcement:
mthlycpixexp0 = zeros(size(yr)) ;
mthlycpixrel0 = zeros(size(yr)) ;
mthlycpix0 = zeros(size(yr)) ;
for i = 1:size(yr,1) ;
  if (yr(i)<2000 | (yr(i)==2000 & mo(i)<12)), bcdone = 3 ; % Blue Chip survey took 3 bus days until Dec 2000, then 2 bus days
  else bcdone = 2 ;
  end ;
  j = find(mpyr==yr(i) & mpmo==mo(i)) ;
  if (~isempty(j)) ;
    k = find(gswyr==yr(i) & gswmo==mo(i)) ;
    cpiday = find(mmsyr==yr(i) & mmsmo==mo(i) & mmsdy>gswdy(k(bcdone)) & mmsdy<=mpdy(j(1)) & ~isnan(mmscpixrel)) ;
    if ~isempty(cpiday) ;
      mthlycpixexp0(i) = mmscpixexp(cpiday) ;
      mthlycpixrel0(i) = mmscpixrel(cpiday) ;
      mthlycpix0(i) = mmscpix(cpiday) ;
    end ;
  end ;
end ;

% compute monthly MMS GDP measure
mthlygdp = zeros(size(yr)) ;
for i = 1:size(yr,1) ;
  gdpday = find(mmsyr==yr(i) & mmsmo==mo(i) & ~isnan(mmsgdprel)) ;
  if ~isempty(gdpday) ;
    if (mod(mo(i),3)==1); i1 = i ;
    elseif (mo(i)==2 & (yr(i)==1996 | yr(i)==2019)); i1 = i ; % GDP was released near the end of these months due to delays
    else i1 = i-1 ; % if GDP release date is early in following month, assign to end of prior month
    end ;
    mthlygdp(i1) = mmsgdp(gdpday) ;
  end ;
end ;


% for each FOMC announcement, compute change in S&P500, yield curve slope, and commodity prices from second business day of month to day before FOMC announcement:
sp500chg = zeros(size(yr)) ; % change these to NaNs if you want to drop months with no news
slopechg = zeros(size(yr)) ;
bcomchg = zeros(size(yr)) ;
bcomspchg = zeros(size(yr)) ;
bcomagchg = zeros(size(yr)) ;
for i = 1:size(yr,1) ;
  if (yr(i)<2000 | (yr(i)==2000 & mo(i)<12)), bcdone = 3 ; % Blue Chip survey took 3 bus days until Dec 2000, then 2 bus days
  else bcdone = 2 ;
  end ;
  j = find(mpyr==yr(i) & mpmo==mo(i)) ;
  if (~isempty(j)) ;
    k = find(gswyr==yr(i) & gswmo==mo(i)) ;
    k1 = find(sp500yr==yr(i) & sp500mo==mo(i) & sp500dy>=gswdy(k(bcdone)) & sp500dy<mpdy(j(1))) ;
    if (~isempty(k1)) ;
      sp500chg(i) = sp500(k1(end)) - sp500(k1(1)) ;
    end ;
    k1 = find(slopeyr==yr(i) & slopemo==mo(i) & slopedy>=gswdy(k(bcdone)) & slopedy<mpdy(j(1))) ;
    if (~isempty(k1)) ;
      slopechg(i) = slope(k1(end)) - slope(k1(1)) ;
    end ;
    k1 = find(bcomyr==yr(i) & bcommo==mo(i) & bcomdy>=gswdy(k(bcdone)) & bcomdy<mpdy(j(1))) ;
    if (~isempty(k1)) ;
      bcomchg(i) = bcomt(k1(end)) - bcomt(k1(1)) ;
      bcomspchg(i) = bcomsp(k1(end)) - bcomsp(k1(1)) ;
      bcomagchg(i) = bcomag(k1(end)) - bcomag(k1(1)) ;
    end ;
  end ;
end ;

% for each FOMC announcement, compute change in S&P500, yield curve slope, and commodity prices over 3 months leading up to FOMC announcement:
sp5003mchg = zeros(size(yr)) ; % change these to NaNs if you want to drop months with no news
slope3mchg = zeros(size(yr)) ;
slope3mlev = zeros(size(yr)) ;
slopelev = zeros(size(yr)) ;
bcom3mchg = zeros(size(yr)) ;
bcomsp3mchg = zeros(size(yr)) ;
bcomag3mchg = zeros(size(yr)) ;
for i = 1:size(yr,1) ;
  j = find(mpyr==yr(i) & mpmo==mo(i)) ;
  if (~isempty(j) & j(1)>2) ;
    if (mpdy(j(1))>1); k2 = find(sp500yr==mpyr(j(1)) & sp500mo==mpmo(j(1)) & sp500dy<mpdy(j(1))) ; % day of current FOMC announcement
    else; k2 = find(sp500yr==mpyr(j(1)) & sp500mo==mpmo(j(1))-1) ; % this allows for FOMC announcement on 1st of month
    end ;
    sp5003mchg(i) = sp500(k2(end)) - sp500(k2(end)-65) ; % change in S&P500 over past 3 months
    if (mpdy(j(1))>1); k2 = find(slopeyr==mpyr(j(1)) & slopemo==mpmo(j(1)) & slopedy<mpdy(j(1))) ;
    else; k2 = find(slopeyr==mpyr(j(1)) & slopemo==mpmo(j(1))-1) ;
    end ;
    slope3mchg(i) = slope(k2(end)) - slope(k2(end)-65) ;
    slope3mlev(i) = slope(k2(end)-65) ;
    slopelev(i) = slope(k2(end)) ;
    if (mpdy(j(1))>1); k2 = find(bcomyr==mpyr(j(1)) & bcommo==mpmo(j(1)) & bcomdy<mpdy(j(1))) ;
    else; k2 = find(bcomyr==mpyr(j(1)) & bcommo==mpmo(j(1))-1) ;
    end ;
    bcom3mchg(i) = bcomt(k2(end)) - bcomt(k2(end)-65) ;
    bcomsp3mchg(i) = bcomsp(k2(end)) - bcomsp(k2(end)-65) ;
    bcomag3mchg(i) = bcomag(k2(end)) - bcomag(k2(end)-65) ;
  end ;
end ;

