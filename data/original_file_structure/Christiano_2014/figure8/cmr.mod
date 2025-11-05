%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 10
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
var bankruptcy;
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
model;
bankruptcy          = (normcdf(((log(omegabar) + sigma(-1)^2 / 2) / sigma(-1))));
end;
% Compute the steady state of the model.
steady;

% Compute the eigenvalues of the model linearized around the steady state.
check;

% Specifiy the shocks.
@# include "../cmr_shocks.mod"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Estimation, done to get the smoothed variables
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
% 5. Process Results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the bankruptcy rate from the model.
orient landscape
dd=1981:1/4:2010+1/4;
bankr=100*(oo_.SmoothedVariables.bankruptcy+1) * Fomegabar_p;
[Y,i1]=min(abs(dd-1990));
tt=i1:length(dd);
dd=dd(tt);
bankr=bankr(tt);

% this is DRALACBS, mnemonic from FRED
dates=1985:1/4:2011+3/4;
delinq =  [4.6100
    4.9200
    4.9100
    4.7700
    4.8600
    4.7400
    4.7500
    4.6600
    5.5200
    5.3800
    5.2500
    5.2500
    5.0700
    4.9800
    5.0200
    4.6200
    4.8800
    4.9500
    5.0200
    4.9000
    4.9900
    5.0500
    5.3400
    5.9500
    6.1000
    6.1600
    5.9600
    5.7900
    5.5100
    5.3900
    5.1800
    4.8100
    4.4800
    4.1800
    3.8300
    3.3500
    3.1400
    2.8400
    2.6300
    2.4900
    2.5100
    2.4800
    2.4800
    2.4500
    2.4000
    2.4400
    2.4100
    2.3700
    2.3500
    2.2800
    2.2200
    2.2300
    2.2200
    2.1700
    2.1700
    2.1800
    2.1600
    2.1400
    2.1900
    2.0400
    2.0600
    2.1300
    2.1900
    2.3300
    2.4200
    2.5500
    2.7100
    2.7400
    2.7500
    2.7500
    2.6900
    2.5700
    2.5400
    2.4200
    2.2200
    2.1500
    1.9600
    1.8600
    1.7400
    1.6400
    1.6000
    1.5700
    1.5600
    1.5400
    1.5100
    1.5100
    1.5800
    1.6900
    1.7400
    1.8700
    2.1400
    2.4700
    2.8600
    3.3300
    3.7200
    4.7400
    5.6400
    6.3900
    6.9500
    7.2700
    7.3900
    7.2400
    6.9100
    6.3500
    6.1900
    5.9700
    5.6600
    5.3100];
[Y,i1]=min(abs(dates-(2010+1/4)));
[Y,i2]=min(abs(dates-(1990)));
tt=[i2:i1];
plot(dates(tt),delinq(tt),'-',dd,bankr,'*-')
axis tight

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

plot(dates(tt),delinq(tt),'-',dd,bankr,'*-')
axis tight
suptitle('Figure 8. Model Bankruptcy Rate versus Loan Delinquency Rate')
text(1989, -1,...
{['Shaded areas indicated NBER recession dates.']}, 'clipping', 'off');
legend('Loan delinquency rate, commercial banks','Smoothed bankruptcy rate, model','location','north')
print('-dpdf', 'figure8.pdf')
