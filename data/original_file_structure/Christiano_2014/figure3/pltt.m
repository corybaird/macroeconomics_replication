function pltt(lyHP,spreadHP,dy,dS,premiumHP,dpremium,creditHP,dcr,liHP,di,equityHP,dequity,consHP,dcons,inflHP,dinfl,df,yoy,saving)
%dbstop at 14
ia=2;
ib=4;
l=2;
thet=1;
lag=12;
conf=1;%plot a shaded area for the empirical confidence interval on the correlation, and not the point estimate
%saving=0;%if unity, save the model cross-correlations to a mat file. Otherwise, read it from there.
inflat=0;%if zero, delete inflation panel in graphs...but, must have had the same setting for inflat in the saving = 1 run
adj=1;%if unity, compute the correlation function in a way that all data are used for each correlation


%model
[V,rnwHP,snsw,B,S,T]=correlate(lyHP,spreadHP,lag,thet,l);
%data
[V,rnw,snsw,B,S,T]=correlate(dy,dS,lag,thet,l);
%correlate computes each correlation using the same data length data set,
%so a lot of data are discarded. corr_ uses all data available to compute
%each correlation
if adj == 1
    [cc] = corr_(dy,dS,lag);
    rnw(1:2*lag+1)=cc';
end
orient landscape
nn=[-lag:lag];
ttp=1:length(rnwHP);
ttm=length(rnwHP):-1:1;
if saving == 1
    rnw_pert=rnwHP;
    if df==0
        save corr_slope_HP rnw_pert
    else
        save corr_slope_diff rnw_pert
    end
else
    if df==0
        load corr_slope_HP rnw_pert
    else
        load corr_slope_diff rnw_pert
    end
end
if inflat==1;q=8;end
if inflat==0;q=7;end
subplot(ia,ib,q)
do_plot
if inflat==1
    title('H. Slope at t minus k');
else
    title('G. Slope at t minus k');
end

xlabel('k')
axis tight
if saving ~= 1
    %ll=legend('95% Confidence interval for empirical point estimates',...
    %    'All shocks','Only risk shocks (anticipated and unanticipated)');
    ll=legend('95 percent confidence interval',...
        'All shocks','Only risk shocks');
    set(ll,'position', [.73 .25 0.2 0.15])
end

if conf ~= 1
    if df == 0
        ll=legend('HP filtered data','HP filtered model',...
               'upper conf','lower conf');
    elseif df == 1
        if yoy==0
            ll=legend('quarterly differenced data',...
                'quarterly differenced model','upper conf','lower conf');
        else
            ll=legend('y-o-y differenced data','y-o-y differenced model',...
                'upper conf','lower conf');
        end
    end
end
%model
[V,rnwHP,snsw,B,S,T]=correlate(lyHP,premiumHP,lag,thet,l);
%data
[V,rnw,snsw,B,S,T]=correlate(dy,dpremium,lag,thet,l);
if adj == 1
    [cc] = corr_(dy,dpremium,lag);
    rnw(1:2*lag+1)=cc';
end

if saving == 1
    rnw_pert=rnwHP;
    if df==0
        save corr_premium_HP rnw_pert
    else
        save corr_premium_diff rnw_pert
    end
else
    if df==0
        load corr_premium_HP rnw_pert
    else
        load corr_premium_diff rnw_pert
    end
end
subplot(ia,ib,1)
do_plot
title('A. Credit Spread at t minus k')
xlabel('k')
axis tight

%model
[V,rnwHP,snsw,B,S,T]=correlate(lyHP,creditHP,lag,thet,l);
%data
[V,rnw,snsw,B,S,T]=correlate(dy,dcr,lag,thet,l);
if adj == 1
    [cc] = corr_(dy,dcr,lag);
    rnw(1:2*lag+1)=cc';
end
if saving == 1
    rnw_pert=rnwHP;
    if df==0
        save corr_credit_HP rnw_pert
    else
        save corr_credit_diff rnw_pert
    end
else
    if df==0
        load corr_credit_HP rnw_pert
    else
        load corr_credit_diff rnw_pert
    end
end

subplot(ia,ib,2)
do_plot
title('B. Credit at t minus k')
xlabel('k')
axis tight

%model
[V,rnwHP,snsw,B,S,T]=correlate(lyHP,liHP,lag,thet,l);

%data
[V,rnw,snsw,B,S,T]=correlate(dy,di,lag,thet,l);
if adj == 1
    [cc] = corr_(dy,di,lag);
    rnw(1:2*lag+1)=cc';
end
if saving == 1
    rnw_pert=rnwHP;
    if df==0
        save corr_invest_HP rnw_pert
    else
        save corr_invest_diff rnw_pert
    end
else
    if df==0
        load corr_invest_HP rnw_pert
    else
        load corr_invest_diff rnw_pert
    end
end

subplot(ia,ib,3)
do_plot
title('C. Investment at t minus k')
xlabel('k')
axis tight

%model
[V,rnwHP,snsw,B,S,T]=correlate(lyHP,lyHP,lag,thet,l);

%data
[V,rnw,snsw,B,S,T]=correlate(dy,dy,lag,thet,l);
if adj == 1
    [cc] = corr_(dy,dy,lag);
    rnw(1:2*lag+1)=cc';
end
if saving == 1
    rnw_pert=rnwHP;
    if df==0
        save corr_output_HP rnw_pert
    else
        save corr_output_diff rnw_pert
    end
else
    if df==0
        load corr_output_HP rnw_pert
    else
        load corr_output_diff rnw_pert
    end
end

subplot(ia,ib,4)
do_plot
title('D. Output at t minus k')
xlabel('k')
axis tight

%model
[V,rnwHP,snsw,B,S,T]=correlate(lyHP,equityHP,lag,thet,l);

%data
[V,rnw,snsw,B,S,T]=correlate(dy,dequity,lag,thet,l);
if adj == 1
    [cc] = corr_(dy,dequity,lag);
    rnw(1:2*lag+1)=cc';
end

if saving == 1
    rnw_pert=rnwHP;
    if df==0
        save corr_equity_HP rnw_pert
    else
        save corr_equity_diff rnw_pert
    end
else
    if df==0
        load corr_equity_HP rnw_pert
    else
        load corr_equity_diff rnw_pert
    end
end

subplot(ia,ib,5)
do_plot
title('E. Equity at t minus k')
xlabel('k')
axis tight

%model
[V,rnwHP,snsw,B,S,T]=correlate(lyHP,consHP,lag,thet,l);
%data
[V,rnw,snsw,B,S,T]=correlate(dy,dcons,lag,thet,l);
if adj == 1
    [cc] = corr_(dy,dcons,lag);
    rnw(1:2*lag+1)=cc';
end

if saving == 1
    rnw_pert=rnwHP;
    if df==0
        save corr_cons_HP rnw_pert
    else
        save corr_cons_diff rnw_pert
    end
else
    if df==0
        load corr_cons_HP rnw_pert
    else
        load corr_cons_diff rnw_pert
    end
end

subplot(ia,ib,6)
do_plot
title('F. Consumption at t minus k')
xlabel('k')
axis tight

if inflat == 1
    %model
    [V,rnwHP,snsw,B,S,T]=correlate(lyHP,inflHP,lag,thet,l);
    %data
    [V,rnw,snsw,B,S,T]=correlate(dy,dinfl,lag,thet,l);
    if adj == 1
        [cc] = corr_(dy,dinfl,lag);
        rnw(1:2*lag+1)=cc';
    end
    if saving == 1
        rnw_pert=rnwHP;
        if df==0
            save corr_infl_HP rnw_pert
        else
            save corr_infl_diff rnw_pert
        end
    else
        if df==0
            load corr_infl_HP rnw_pert
        else
            load corr_infl_diff rnw_pert
        end
    end
    
    subplot(ia,ib,7)
    do_plot
    title('G. Inflation at t minus k')
    xlabel('k')
    axis tight
end
suptitle('Figure 3. Selected Cross-Correlations with Contemporaneous Output, Model and Data')