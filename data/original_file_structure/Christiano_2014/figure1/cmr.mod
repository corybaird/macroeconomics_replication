%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To create figure 1, run 'dynare cmr' in this directory.
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

load cmr_mode
parameter_names(strcmp('iota1_p',parameter_names),:) = {'iota_p'};
parameter_names(strcmp('iotaw1_p',parameter_names),:) = {'iotaw_p'};
parameter_names(strcmp('stdsigmax_p',parameter_names),:) = {'stdsigma2_p'};
parameter_names(strcmp('stdsigma_p',parameter_names),:) = {'stdsigma1_p'};
parameter_names(strcmp('par8_p',parameter_names),:) = {'signal_corr_p'};
save cmr_mode xparam1 hh parameter_names


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
           mode_compute = 0, nograph) sigma;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Process resutls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the following computes the historical decompositions and places them in 
% the matrix oo_.shock_decomposition(i,j,t), where i indicates the 
% endogenous variable, j indicates the shock (j=1,...,end-2 has the shocks,
% j=end-1 initial conditions and j=end raw data)
shock_decomposition(parameter_set = posterior_mode) gdp_obs;
close
orient landscape
gdp = squeeze(oo_.shock_decomposition(9, 22, :));
gdp4=gdp(4:end) + gdp(3:(end-1)) + gdp(2:(end-2)) + gdp(1:(end-3));
gdps = sum(squeeze(oo_.shock_decomposition(9, 8:16, :)), 1);
gdps4=gdps(4:end) + gdps(3:(end-1)) + gdps(2:(end-2)) + gdps(1:(end-3));
subplot(2, 3, 1)
plot(2010.25-115/4+(1:115)/4, gdp4 * 100, '-', ...
    2010.25-115/4+(1:115)/4, gdps4 * 100, '*-')
xlim([1988, 2010.25])
ylim([-7, 3.5])
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
plot(2010.25-115/4+(1:115)/4, gdp4 * 100, '-', ...
     2010.25-115/4+(1:115)/4, gdps4 * 100, '*-')
title({'A. GDP Growth'; 'Year-Over-Year Percentage Change'})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval(['networth = cumsum(oo_.SmoothedVariables.networth_obs);']);
networths = cumsum(sum(squeeze(oo_.shock_decomposition(21, 8:16, :)), 1));
subplot(2, 3, 2)
plot(2010.25-118/4+(1:118)/4, networth, '-', ...
     2010.25-118/4+(1:118)/4, networths, '*-')
xlim([1988, 2010.25])
ylim([-0.3, 0.45])
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
plot(2010.25-118/4+(1:118)/4, networth, '-', ...
     2010.25-118/4+(1:118)/4, networths, '*-')
title({'B. Equity'; 'Log-Level'})


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

credit = squeeze(oo_.shock_decomposition(3, 22, :));
credit4=credit(4:end) + credit(3:(end-1)) + credit(2:(end-2)) + credit(1:(end-3));
credits = sum(squeeze(oo_.shock_decomposition(3, 8:16, :)), 1);
credits4=credits(4:end) + credits(3:(end-1)) + credits(2:(end-2)) + credits(1:(end-3));
subplot(2, 3, 3)
plot(2010.25-115/4+(1:115)/4, credit4 * 100, '-', ...
     2010.25-115/4+(1:115)/4, credits4 * 100, '*-')
xlim([1988, 2010.25])
ylim([-10, 8])
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
plot(2010.25-115/4+(1:115)/4, credit4 * 100, '-', ...
     2010.25-115/4+(1:115)/4, credits4 * 100, '*-');
title({'C. Credit';'Year-Over-Year Percentage Change'})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval(['spread = squeeze(oo_.shock_decomposition(48, 22, :));']);
spreads = sum(squeeze(oo_.shock_decomposition(48, 8:16, :)), 1);
subplot(2, 3, 4)
plot(2010.25-118/4+(1:118)/4, spread * 400, '-', ...
     2010.25-118/4+(1:118)/4, spreads * 400, '*-')
xlim([1988, 2010.25])
ylim([-4.2, 5])
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
plot(2010.25-118/4+(1:118)/4, spread * 400, '-', ...
     2010.25-118/4+(1:118)/4, spreads * 400, '*-')
title({'D. Slope'; 'Long-Term Rate Minus Short-Term Rate'})


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval(['premium = squeeze(oo_.shock_decomposition(27, 22, :));']);
premiums = sum(squeeze(oo_.shock_decomposition(27, 8:16, :)), 1);
subplot(2, 3, 5)
plot(2010.25-118/4+(1:118)/4, premium * 400, '-', ...
     2010.25-118/4+(1:118)/4, premiums * 400, '*-')
xlim([1988, 2010.25])
ylim([-0.8, 2.75])
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
plot(2010.25-118/4+(1:118)/4, premium * 400, '-', ...
     2010.25-118/4+(1:118)/4, premiums * 400, '*-')

title({'E. Credit Spread'; 'Percentage Points Per Annum'})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval(['premium = squeeze(oo_.shock_decomposition(27, 22, :));']);
eval(['sig = squeeze(oo_.shock_decomposition(38, 22, :));']);
subplot(2, 3, 6)
plot(2010.25-118/4+(1:118)/4, premium * 100, '-', ...
     2010.25-118/4+(1:118)/4, sig, '*-')
xlim([1988, 2010.25])
ylim([-0.25, 0.75])
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
plot(2010.25-118/4+(1:118)/4, premium * 100, '-', ...
     2010.25-118/4+(1:118)/4, sig, '*-')
title({'F. Risk Shock and Credit Spread'; 'Percentage Points'})

 text(1924, -0.47,...
{['Whith the exception of Panels B and F, the solid line is the data. ', ...
  'Panel B shows the smoothed equity data, which differ from the actual ', ...
  'data by a small'];['estimated measurement error. The starred line is the', ...
  ' result of feeding only the estimated risk shock to the model. ', ...
  'Panel F displays the demeaned credit'];['spread and the risk shock (the ',...
  'latter expressed as a ratio to its steady state value, minus unity). ', ...
  'Shaded areas indicated NBER recession dates.']}, 'clipping', 'off');

suptitle('Figure 1. The Role of the Risk Shock in Selected Variables');
print('-dpdf', 'figure1.pdf')