
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

