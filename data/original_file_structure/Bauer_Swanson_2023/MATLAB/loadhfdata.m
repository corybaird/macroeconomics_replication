

% load MMS data (from FRB FAME, Jan 1990 through Dec 2017, available to Feb 2018 if needed)
load data/usalldata_board_bauer.txt ;
mmsdataall = usalldata_board_bauer ; clear usalldata_board_bauer ;
[mmsrows,mmscols] = size(mmsdataall) ;
mmsmo = mmsdataall(:,1) ;
mmsdy = mmsdataall(:,2) ;
mmsyr = mmsdataall(:,3) ;
mmsautosexp = mmsdataall(:,4) ;
mmsautosrel = mmsdataall(:,5) ;
mmscapaexp = mmsdataall(:,8) ;
mmscaparel = mmsdataall(:,9) ;
mmscconfexp = mmsdataall(:,10) ;
mmscconfrel = mmsdataall(:,11) ;
mmscpixexp = mmsdataall(:,16) ;
mmscpixrel = mmsdataall(:,17) ;
mmseciexp = mmsdataall(:,20) ;
mmsecirel = mmsdataall(:,21) ;
mmsgdpexp = mmsdataall(:,22) ;
mmsgdprel = mmsdataall(:,23) ;
mmsstartsexp = mmsdataall(:,26) ;
mmsstartsrel = mmsdataall(:,27) ;
mmsiclmexp = mmsdataall(:,28) ;
mmsiclmrel = mmsdataall(:,29) ;
mmsipexp = mmsdataall(:,30) ;
mmsiprel = mmsdataall(:,31) ;
mmsldiexp = mmsdataall(:,32) ;
mmsldirel = mmsdataall(:,33) ;
mmsismexp = mmsdataall(:,34) ;
mmsismrel = mmsdataall(:,35) ;
mmsnfpexp = mmsdataall(:,36) ;
mmsnfprel = mmsdataall(:,37) ;
mmsnhomexp = mmsdataall(:,38) ;
mmsnhomrel = mmsdataall(:,39) ;
mmsppixexp = mmsdataall(:,46) ;
mmsppixrel = mmsdataall(:,47) ;
mmsrsxexp = mmsdataall(:,50) ;
mmsrsxrel = mmsdataall(:,51) ;
mmsunempexp = mmsdataall(:,52) ;
mmsunemprel = mmsdataall(:,53) ;

% define surprise component of releases
autos = mmsautosexp - mmsautosrel ;
capa = mmscaparel - mmscapaexp ;
cconf = mmscconfrel - mmscconfexp ;
cpix = mmscpixrel - mmscpixexp ;
eci = mmsecirel - mmseciexp ;
gdp = mmsgdprel - mmsgdpexp ;
iclm = mmsiclmrel - mmsiclmexp ;
ip = mmsiprel - mmsipexp ;
ism = mmsismrel - mmsismexp ;
ldi = mmsldirel - mmsldiexp ;
nfp = mmsnfprel - mmsnfpexp ;
nhom = mmsnhomrel - mmsnhomexp ;
ppix = mmsppixrel - mmsppixexp ;
rsx = mmsrsxrel - mmsrsxexp ;
starts = mmsstartsrel - mmsstartsexp ;
unemp = mmsunemprel - mmsunempexp ;

% load monthly Nonfarm Payrolls data
load data/NonfarmPayrolls.txt
nfpyr = NonfarmPayrolls(:,1) ;
nfpmo = NonfarmPayrolls(:,2) ;
nfpmthly = NonfarmPayrolls(:,3) ;
Dnfpmthly = [NaN; diff(log(nfpmthly))] ;
D3nfpmthly = [NaN(3,1); log(nfpmthly(4:end)) - log(nfpmthly(1:end-3))] ;
i = find(nfpyr==1990 & nfpmo==1) ;
Dnfpmthly = Dnfpmthly(i:end) ;
D3nfpmthly = D3nfpmthly(i:end) ;
nfpyr = nfpyr(i:end) ;
nfpmo = nfpmo(i:end) ;

%
% Use high-frequency data to forecast change in NFP over the next 3 months:
%

% convert daily high-frequency surprises into monthly vectors for forecasting
N = length(Dnfpmthly) ;
capam = NaN(N,1) ;
cconfm = NaN(N,1) ;
cpixm = NaN(N,1) ;
ipm = NaN(N,1) ;
ismm = NaN(N,1) ;
ldim = NaN(N,1) ;
nfpm = NaN(N,1) ;
nhomm = NaN(N,1) ;
ppixm = NaN(N,1) ;
rsxm = NaN(N,1) ;
startsm = NaN(N,1) ;
unempm = NaN(N,1) ;
iclmm1 = NaN(N,1); iclmm2 = NaN(N,1); iclmm3 = NaN(N,1); iclmm4 = NaN(N,1) ;
autosm1 = NaN(N,1); autosm2 = NaN(N,1); autosm3 = NaN(N,1);
gdpm = NaN(N,1) ; gdprelm = NaN(N,1) ;
ecim = NaN(N,1) ;


for i = 1:N ;
  j = find(mmsyr==nfpyr(i) & mmsmo==nfpmo(i)) ;
  j1 = find(~isnan(capa(j))); if(~isempty(j1)); capam(i) = capa(j(j1(1))); ipm(i) = ip(j(j1(1))); end ;
  j1 = find(~isnan(cconf(j))); if(~isempty(j1)); cconfm(i) = cconf(j(j1(1))); end ;
  j1 = find(~isnan(cpix(j))); if(~isempty(j1)); cpixm(i) = cpix(j(j1(1))); end ;
  j1 = find(~isnan(ism(j))); if(~isempty(j1)); ismm(i) = ism(j(j1(1))); end ;
  j1 = find(~isnan(ldi(j))); if(~isempty(j1)); ldim(i) = ldi(j(j1(1))); end ;
  j1 = find(~isnan(nfp(j))); if(~isempty(j1)); nfpm(i) = nfp(j(j1(1))); unempm(i) = unemp(j(j1(1))); end ;
  j1 = find(~isnan(nhom(j))); if(~isempty(j1)); nhomm(i) = nhom(j(j1(1))); end ;
  j1 = find(~isnan(ppix(j))); if(~isempty(j1)); ppixm(i) = ppix(j(j1(1))); end ;
  j1 = find(~isnan(rsx(j))); if(~isempty(j1)); rsxm(i) = rsx(j(j1(1))); end ;
  j1 = find(~isnan(starts(j))); if(~isempty(j1)); startsm(i) = starts(j(j1(1))); end ;
  j1 = find(~isnan(iclm(j))); if(length(j1)>0); iclmm1(i) = iclm(j(j1(1))); end ;
                              if(length(j1)>1); iclmm2(i) = iclm(j(j1(2))); end ;
                              if(length(j1)>2); iclmm3(i) = iclm(j(j1(3))); end ;
                              if(length(j1)>3); iclmm4(i) = iclm(j(j1(4))); end ;
  j1 = find(~isnan(autos(j))); if(length(j1)>0); autosm1(i) = autos(j(j1(1))); end ;
                              if(length(j1)>1); autosm2(i) = autos(j(j1(2))); end ;
                              if(length(j1)>2); autosm3(i) = autos(j(j1(3))); end ;
  j1 = find(~isnan(gdp(j))); if(~isempty(j1)); gdpm(i) = gdp(j(j1(1))); gdprelm(i) = mmsgdprel(j(j1(1))); end ;
  j1 = find(~isnan(eci(j))); if(~isempty(j1)); ecim(i) = eci(j(j1(1))); end ;
end ;

autosm = autosm1 + nantozip(autosm2) + nantozip(autosm3) ;

% regress next GDP release on the other indicators
gdpmlhs = gdprelm ; % fill in missing monthly GDP data with next released value
i = find(~isnan(gdprelm)); gdpmlhs(i(2:end)-1) = gdprelm(i(2:end)); gdpmlhs(i(2:end)-2) = gdprelm(i(2:end)) ;

gdpmlhs = [gdpmlhs(2:end);NaN] ; % regression will forecast next-month GDP release
%gdpmlags = [[NaN(3,1);gdpmlhs(1:end-3)], [NaN(6,1);gdpmlhs(1:end-6)] ] ; % two lags
gdpmlags = [NaN(3,1);gdpmlhs(1:end-3)] ; % one lag
const = ones(N,1) ;

%beta = ols(gdpmlhs, [const,nantozip([capam,cconfm,cpixm,ismm,ldim,nfpm,unempm,nhomm,ppixm,rsxm,startsm,iclmm1,iclmm2,iclmm3,iclmm4,autosm,gdpm,ecim])]) ;
betamms = ols(gdpmlhs, [const,gdpmlags,nantozip([capam,cpixm,ismm,nfpm,unempm,ppixm,iclmm1,iclmm2,iclmm3,iclmm4,autosm,gdpm,ecim])]) ;






