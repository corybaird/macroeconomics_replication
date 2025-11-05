function cross_corr(spread,ly,lc,premium,credit,li,equity,infl,saving)


addpath('..\PFANN');
yoy=1;

%following are transformations of model data...
%first, do growth transformation..then HP.
if yoy==1
    price=cumsum(infl);
    dly=zeros(length(ly)-4,1);
    dlc=zeros(length(lc)-4,1);
    dli=zeros(length(lc)-4,1);
    Dequity=zeros(length(lc)-4,1);
    dcredit=zeros(length(lc)-4,1);
    Dinfl=zeros(length(lc)-4,1);
    for ii = 5:length(ly)
        dly(ii-4)=(ly(ii)-ly(ii-4))/4;
        dlc(ii-4)=(lc(ii)-lc(ii-4))/4;
        dli(ii-4)=(li(ii)-li(ii-4))/4;
        Dequity(ii-4)=(equity(ii)-equity(ii-4))/4;
        dcredit(ii-4)=(credit(ii)-credit(ii-4))/4;
        Dinfl(ii-4)=(price(ii)-price(ii-4))/4;
    end
    dspread=spread(5:end);
    Dpremium=premium(5:end);    
elseif yoy==0
    dly=diff(ly);
    dlc=diff(lc);
    dli=diff(li);
    Dequity=diff(equity);
    dcredit=diff(credit);
    dspread=spread(2:end);
    Dinfl=infl(2:end);
    Dpremium=premium(2:end);
end

hpparam = 1600;
[lyHP, ty] = hpfast(ly,hpparam);
[spreadHP, ty] = hpfast(spread,hpparam);
[premiumHP, ty] = hpfast(premium,hpparam);
[creditHP, ty] = hpfast(credit,hpparam);
[liHP, ty] = hpfast(li,hpparam);
[equityHP, ty] = hpfast(equity,hpparam);
[consHP, ty] = hpfast(lc,hpparam);
[inflHP, ty] = hpfast(infl,hpparam);

%transformations of the actual data
load ../data_BAAoverTB
tt = 1981:1/4:2010+1/4;
[Y, I] = min(abs(tt-1985));
tt = tt(I:end);

% these are the variables in data_BAAoverTB.mat:
%Re_obs          consumption_obs  gdp_obs          inflation_obs    networth_obs     premium_obs      
%Spread1_obs     credit_obs       hours_obs        investment_obs   pinvest_obs      wage_obs 

[y_growth]=difftrans(gdp_obs,yoy,I);
[dy,ty] = hpfast(cumsum(log(gdp_obs(I:end))), hpparam);

[c_growth] = difftrans(consumption_obs,yoy,I);
[dcons,tS] = hpfast(cumsum(log(consumption_obs(I:end))), hpparam);

[credit_growth] = difftrans(credit_obs,yoy,I);
[dcr,tS] = hpfast(cumsum(log(credit_obs(I:end))), hpparam);

[li_growth] = difftrans(investment_obs,yoy,I);
[di,tS] = hpfast(cumsum(log(investment_obs(I:end))), hpparam);

[equity_growth] = difftrans(networth_obs,yoy,I);
[dequity,tS] = hpfast(cumsum(log(networth_obs(I:end))), hpparam);

spread_growth = log(Spread1_obs(I:end));
[dS,tS] = hpfast(log(Spread1_obs(I:end)), hpparam);

premium_growth = log(premium_obs(I:end));
[dpremium,tS] = hpfast((log(premium_obs(I:end))), hpparam);

[infl_growth]=difftrans(inflation_obs,yoy,I);
[dinfl,tS]=hpfast((log(inflation_obs(I:end))), hpparam);


%df=0;%this means HP filter
%figure('name','figure for manuscript_HP')
%pltt(lyHP,spreadHP,dy,      dS,           premiumHP,dpremium,      creditHP,dcr,          liHP,di,       equityHP,dequity,      consHP,  dcons,   inflHP,dinfl,df,yoy,saving);

df=1;%this means growth
% figure('name','figure for manuscript_growth')
pltt(dly, dspread, y_growth,spread_growth,Dpremium, premium_growth,dcredit, credit_growth,dli, li_growth,Dequity, equity_growth,dlc,     c_growth,Dinfl, infl_growth,df,yoy,saving);
1+1;
