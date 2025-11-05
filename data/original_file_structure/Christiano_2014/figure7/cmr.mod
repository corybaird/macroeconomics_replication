%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2013 Benjamin K. Johannsen, Lawrence J. Christiano
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or (at
% your option) any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see http://www.gnu.org/licenses/.

% Turn the warnings off because division by zero is not seen as a bug by 
% Dynare so long as it is eventually handled properly once the NaNs are
% produced.  However, this potentially generates many warnings, which
% clutter the screen.
warning off

% One can estimate the baseline version of the model, 
% and versions of the model obtained by dropping none, one or several of the 
% four 'financial variables'. By dropping none of the variables, the user
% simply estimates the baseline model. The financial variables you want
% included in the estimation are in the following list:

@# define financial_data = ["networth_obs", "credit_obs", "premium_obs", "Spread1_obs"]

% Depending on the variables included in the financial data, we need some
% indicator variables.

@# include "../cmr_indicator_variables.mod"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0. Housekeeping, paths, and estimation decisions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('../dynare_code');
addpath('..');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Declaration of variables and parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@# include "../cmr_declarations.mod"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Set parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% when stopshock = 1, then non-risk shocks are all turned off
@# define stopshock = 0

% when stopsignal = 1, then signals on risk are turned off
@# define stopsignal = 0

% when stopunant = 1, then unanticipated risk shock turned off
@# define stopunant = 0

% when signal_corr_nonzero = 1, sig_corr_p can be non zero.
@# define signal_corr_nonzero = 1

@# include "../cmr_parameters.mod"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@# include "../cmr_model.mod"

% Compute the steady state of the model.
steady;

% Compute the eigenvalues of the model linearized around the steady state.
check;

% Specifiy the shocks.
@# include "../cmr_shocks.mod"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Estimation, to get the smoothed variables.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% List all parameters to be estimated and priors.
@# include "../cmr_estimated_params.mod"

% Declare numerical initial values for the optimizer.
@# include "../cmr_estimated_params_init.mod"

% The 'varobs' command lists the names of observed endogenous variables 
% for the estimation procedure. These variables must be available in the 
% data file.

varobs
@# if some_financial_data
@# for fvar in financial_data
       @{fvar},
@# endfor
@# endif
       inflation_obs, hours_obs,  gdp_obs,
       wage_obs, investment_obs, consumption_obs,  
       Re_obs, pinvest_obs;

options_.weibull = 1;
options_.plot_priors = 0;

estimation(datafile = data_BAAoverTB, order = 1, smoother,
           mode_file = cmr_mode, loglinear, presample = 16, 
           mh_replic = 0, mh_nblocks = 2, mh_jscale = 0.28, 
           mode_compute = 0, nograph) volEquity;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Process resutls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%the date on the risk shock when graphed is shifted forward one period.
%only in that way is it comparable to the cross-sectional standard
%deviation of returns.
dates=1981+1/4:1/4:2010+2/4;
dd=1962+2/4:1/4:2010+3/4;
[Y,t1]=min(abs(dd-1985));
tt=t1:length(dd)-1;

[Y,tt1]=min(abs(dates-1985));
ttt=tt1:length(dates);
var_ret_nfin=   [0.124389389803223
   0.158621156822240
   0.141177238600465
   0.147686323365504
   0.160566472839201
   0.153908102314062
   0.183767965002613
   0.165298952442278
   0.157995370320293
   0.140119443812450
   0.195604788192854
   0.137463112753003
   0.179506985138376
   0.245211724295691
   0.251046499353755
   0.143344952692429
   0.127115043628022
   0.180284728321651
   0.271536236690917
   0.246419386300623
   0.229185162331091
   0.206455228767280
   0.162418039398754
   0.253820970394935
   0.191227086717047
   0.182177258860111
   0.132884483205238
   0.149862910539045
   0.150611746042280
   0.194793841048303
   0.167749915080369
   0.150448647632740
   0.223553589194975
   0.192130978811854
   0.248246169774192
   0.166984691758571
   0.162287532079062
   0.156456423502087
   0.219166607985346
   0.172738120928657
   0.147300453607755
   0.170925364650146
   0.184501489812379
   0.174281313933594
   0.266239597768253
   0.232532874494639
   0.276650611761630
   0.177908671275478
   0.172095710011213
   0.260503627162833
   0.428809434663690
   0.286880893389188
   0.185967942832664
   0.212041835812078
   0.352588580996521
   0.195080965874280
   0.189612484620723
   0.206167702512395
   0.232403050110715
   0.208055235560098
   0.202110147029614
   0.217027589834051
   0.215171276717929
   0.253781334788144
   0.259489560247751
   0.167824474455301
   0.242733894532485
   0.246244645070979
   0.221080931470762
   0.240051622062945
   0.215390584957130
   0.221083686004254
   0.305698003522798
   0.304776084926481
   0.248802063359297
   0.266876693259367
   0.184645071318627
   0.246407120321201
   0.222480637486960
   0.228567938587033
   0.262112897220021
   0.379773199029361
   0.347367706790106
   0.329828550375335
   0.212931104956580
   0.218514282923274
   0.226236457105699
   0.212418309977778
   0.246600798005512
   0.233931779788899
   0.300683274839396
   0.251176226879242
   0.228937028005860
   0.283016146385133
   0.332918188744072
   0.289181315482676
   0.231899341855135
   0.243793745782743
   0.363843653722250
   0.267114939549175
   0.256580710085944
   0.205345442447123
   0.317200780378291
   0.263352189482220
   0.242939857487311
   0.231992732745649
   0.272354982201907
   0.267016774682315
   0.270404758653564
   0.253067308681772
   0.290178472186628
   0.311426539002999
   0.262702083727770
   0.301566656322826
   0.469332348722929
   0.307905227124743
   0.330256112491720
   0.330050759496326
   0.392407048194924
   0.241706335220294
   0.258511178137766
   0.329868176712297
   0.315628689609160
   0.287613713953129
   0.290086348924992
   0.264968542433472
   0.242928296417345
   0.222731249940656
   0.264190919042682
   0.252764423383160
   0.290938495361538
   0.307294952776884
   0.312604881420288
   0.279090000605933
   0.314036816053302
   0.308602181353304
   0.245781637327059
   0.277272490650540
   0.262596294527363
   0.292165772477263
   0.330745372186937
   0.262832423534361
   0.318565571114705
   0.282392471721146
   0.244906978945015
   0.424065836047216
   0.368614791128392
   0.377878805031288
   0.319343050991437
   0.546643125294802
   0.500718651918419
   0.336226110082296
   0.352490010024283
   0.362099150860515
   0.399113663354439
   0.415557173901388
   0.294117920876174
   0.456866206743902
   0.337069550147097
   0.312828459598120
   0.260756758354431
   0.353539677423571
   0.304359113642116
   0.436757330540557
   0.331803470922212
   0.298941568310498
   0.284945238685866
   0.231712869898748
   0.220062270444937
   0.290696729962907
   0.240664821257693
   0.215630017109145
   0.263754531320551
   0.226657840629485
   0.280618071434665
   0.206039145221621
   0.202284781231860
   0.241931399620371
   0.217356556211933
   0.219550704973708
   0.230784711269621
   0.240868392103368
   0.236308219120253
   0.296971943688239
   0.272234242175251
   0.275279665309016
   0.357990197306853
   0.468872647351161
   0.370042187716880
   0.257553928299915
   0.247761378157957
   0.209646647617037
   0.241125595300757
   0.259591217907632];

hps=1600;
voleq = oo_.SmoothedVariables.volEquity;
voleq_ss = 0.536401;
fsz = 12;

[datad,datat]=hpfast(var_ret_nfin(tt),hps);
[modeld,modelt]=hpfast((voleq(ttt)+1) * voleq_ss,hps);

orient landscape
subplot(221)
plot(dd(tt),var_ret_nfin(tt),dd(tt),datat)
NBER_recessions=[1948.75, 1949.75;
     1953.25, 1954.25;
     1957.5,  1958.25;
    1960.25, 1961.0;
    1969.75, 1970.75;
    1973.75, 1975.0;
    1980.0, 1980.5;
    1981.5, 1982.75;
    1990.5, 1991.0;
    2001.0, 2001.75;
    2007.75, 2009+1/4];

 
 
xlimits=get(gca,'XLim'); %get axis 

min_idx=min(find(NBER_recessions(:,1)-xlimits(1)>=0));

NBER_recessions=NBER_recessions(min_idx:end,:);


if NBER_recessions(1,1)<xlimits(1)
    NBER_recessions(1,1)=xlimits(1);
end


if NBER_recessions(end,end)>xlimits(2)
    NBER_recessions(end,end)=xlimits(2);
end

ylimits=get(gca,'YLim'); %get axis 

%put nber recessions as bars
for iiii=1:1:size(NBER_recessions,1),

    %full grey area, without edges 
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
          NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9],'EdgeColor','none'); hold on
    
    %edges at bottom
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(1) ylimits(1)]',[0.9 0.9 0.9]); hold on
    
    %edges at top
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(2) ylimits(2) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    
    
    %edges left if first recession date is equal to initial date 
    if NBER_recessions(1)<=xlimits(1) && iiii==1,
    patch([xlimits(1),xlimits(1),xlimits(1),xlimits(1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    end
    
 
    
    %edges right if last recession date is equal to final date 
    if NBER_recessions(end)>=xlimits(2) && iiii==size(NBER_recessions,1),
    patch([xlimits(2),xlimits(2),xlimits(2),xlimits(2)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    end
    
    
end
plot(dd(tt),var_ret_nfin(tt),dd(tt),datat)
title({'A. Uncertainty, Non-Financial Firms'; 'Hodrick-Prescott Trend'})
axis([dd(tt(1)) dd(tt(end)) .2 .55])

subplot(222)
plot(dd(tt),(voleq(ttt)+1)*voleq_ss,dd(tt),modelt);
 
xlimits=get(gca,'XLim'); %get axis 

min_idx=min(find(NBER_recessions(:,1)-xlimits(1)>=0));

NBER_recessions=NBER_recessions(min_idx:end,:);


if NBER_recessions(1,1)<xlimits(1)
    NBER_recessions(1,1)=xlimits(1);
end


if NBER_recessions(end,end)>xlimits(2)
    NBER_recessions(end,end)=xlimits(2);
end

ylimits=get(gca,'YLim'); %get axis 
 
%put nber recessions as bars
for iiii=1:1:size(NBER_recessions,1),

    %full grey area, without edges 
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9],'EdgeColor','none'); hold on
    
    %edges at bottom
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(1) ylimits(1)]',[0.9 0.9 0.9]); hold on
    
    %edges at top
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
          NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(2) ylimits(2) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    
    
    %edges left if first recession date is equal to initial date 
    if NBER_recessions(1)<=xlimits(1) && iiii==1,
    patch([xlimits(1),xlimits(1),xlimits(1),xlimits(1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    end
    
 
    
    %edges right if last recession date is equal to final date 
    if NBER_recessions(end)>=xlimits(2) && iiii==size(NBER_recessions,1),
    patch([xlimits(2),xlimits(2),xlimits(2),xlimits(2)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    end
    
    
end
plot(dd(tt),(voleq(ttt)+1)*voleq_ss,dd(tt),modelt);
title({'B. Model Implication for Uncertainty'; 'Hodrick-Prescott Trend'})
axis([dd(tt(1)) dd(tt(end)) .4 .95])

subplot(212)
plot(dd(tt),modeld,'o-',dd(tt),datad,'*-',dd(tt),zeros(length(tt),1));
 
xlimits=get(gca,'XLim'); %get axis 

min_idx=min(find(NBER_recessions(:,1)-xlimits(1)>=0));

NBER_recessions=NBER_recessions(min_idx:end,:);


if NBER_recessions(1,1)<xlimits(1)
    NBER_recessions(1,1)=xlimits(1);
end


if NBER_recessions(end,end)>xlimits(2)
    NBER_recessions(end,end)=xlimits(2);
end

ylimits=get(gca,'YLim'); %get axis 
 
%put nber recessions as bars
for iiii=1:1:size(NBER_recessions,1),

    %full grey area, without edges 
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9],'EdgeColor','none'); hold on
    
    %edges at bottom
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(1) ylimits(1)]',[0.9 0.9 0.9]); hold on
    
    %edges at top
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),...
           NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(2) ylimits(2) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    
    
    %edges left if first recession date is equal to initial date 
    if NBER_recessions(1)<=xlimits(1) && iiii==1,
    patch([xlimits(1),xlimits(1),xlimits(1),xlimits(1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    end
    
 
    
    %edges right if last recession date is equal to final date 
    if NBER_recessions(end)>=xlimits(2) && iiii==size(NBER_recessions,1),
    patch([xlimits(2),xlimits(2),xlimits(2),xlimits(2)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    end
    
    
end
plot(dd(tt),modeld,'o-',dd(tt),datad,'*-',dd(tt),zeros(length(tt),1));
title('C. Detrended Data')
axis([dd(tt(1)) dd(tt(end)) -.2 .3])
model_data_corr = corrcoef(modeld,datad);
text(2004, .2, ['Correlation = ',num2str(model_data_corr(1,2),'%5.2f%')])
suptitle('Figure 7. Risk and Uncertainty')
legend('Model','Non-financial firm data','location','NorthWest')
text(1984.5, -0.3,...
{['Shaded areas indicated NBER recession dates.']}, 'clipping', 'off');
print('-dpdf', 'figure7.pdf')
