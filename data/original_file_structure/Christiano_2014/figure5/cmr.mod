%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To create figure 5, set cee = 1 in line 38 below and then run 'dynare cmr'.  Then
% set cee = 0 and again run 'dynare cmr'.
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
@# define cee = 0

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
@# if cee == 0
@# if some_financial_data
@# for fvar in financial_data
       @{fvar},
@# endfor
@# endif
@# endif
       inflation_obs, hours_obs,  gdp_obs,
       wage_obs, investment_obs, consumption_obs,  
       Re_obs, pinvest_obs;

options_.weibull = 1;
options_.plot_priors = 0;

@# if cee == 1
estimation(datafile = data_BAAoverTB, order = 1, smoother,
           mode_file = cmr_mode_cee, loglinear, presample = 16, 
           mh_replic = 0, mh_nblocks = 2, mh_jscale = 0.28, 
           mode_compute = 0, nograph) gdp_obs;
@# else
estimation(datafile = data_BAAoverTB, order = 1, smoother,
           mode_file = cmr_mode, loglinear, presample = 16, 
           mh_replic = 0, mh_nblocks = 2, mh_jscale = 0.28, 
           mode_compute = 0, nograph) gdp_obs;
@# endif

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Process resutls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% the following computes the historical decompositions and places them in 
% the matrix oo.shock_decomposition(i,j,t), where i indicates the 
% endogenous variable, j indicates the shock (j=1,...,end-2 has the shocks,
% j=end-1 initial conditions and j=end raw data)
shock_decomposition(parameter_set = posterior_mode) gdp_obs;
close
@# if cee == 1
  cee_shock_decomposition = oo_.shock_decomposition;
  cee_oo_ = oo_;
  save('cee.mat', 'cee_shock_decomposition', 'cee_oo_');
@# else

    load cee.mat
    gdp = squeeze(oo_.shock_decomposition(9, 22, :));
    gdp4=gdp(4:end) + gdp(3:(end-1)) + gdp(2:(end-2)) + gdp(1:(end-3));
    gdps = sum(squeeze(oo_.shock_decomposition(9, 8:16, :)), 1);
    gdps4=gdps(4:end) + gdps(3:(end-1)) + gdps(2:(end-2)) + gdps(1:(end-3));


    eval(['gdps_cee = squeeze(cee_shock_decomposition(7, 9, :));']);
    gdps4_cee=gdps_cee(4:end) + gdps_cee(3:(end-1)) + gdps_cee(2:(end-2)) + gdps_cee(1:(end-3));


    eval(['networth = cumsum(oo_.SmoothedVariables.networth_obs);']);
    networths = cumsum(sum(squeeze(oo_.shock_decomposition(21, 8:16, :)), 1));


    eval(['equity_cee = (squeeze(cee_shock_decomposition(23, 9, :)));']);

    orient landscape
    pp = subplot(2, 2, 1)
    set(pp, 'position', get(pp, 'position') .* [1 .9 1 1])
    plot(2010.25-115/4+(1:115)/4, gdp4 * 100, '-', ...
        2010.25-115/4+(1:115)/4, gdps4 * 100, '*-')
    recession_bars
    plot(2010.25-115/4+(1:115)/4, gdp4 * 100, '-', ...
        2010.25-115/4+(1:115)/4, gdps4 * 100, '*-')
    xlim([1988, 2010.25])
    ylim([-7, 3.5])
    title({'Baseline Model'; '$\phantom{----}\sigma_t$'}, 'Interpreter', 'Latex')
    ylabel({'GDP Growth'; 'Year-Over-Year Percentage Change'})

    pp = subplot(2, 2, 2)
    set(pp, 'position', get(pp, 'position') .* [1 .9 1 1])
    plot(2010.25-115/4+(1:115)/4, gdp4 * 100, '-', ...
        2010.25-115/4+(1:115)/4, gdps4_cee * 100, '*-')
    recession_bars
    plot(2010.25-115/4+(1:115)/4, gdp4 * 100, '-', ...
        2010.25-115/4+(1:115)/4, gdps4_cee * 100, '*-')
    xlim([1988, 2010.25])
    ylim([-7, 3.5])
    title({'Simple Model (CEE)'; '$\phantom{----}\zeta_{I,t}$'}, 'Interpreter', 'Latex')

    subplot(2, 2, 3)
    plot(2010.25-118/4+(1:118)/4, networth, '-', ...
         2010.25-118/4+(1:118)/4, networths, '*-');
    recession_bars
    plot(2010.25-118/4+(1:118)/4, networth, '-', ...
         2010.25-118/4+(1:118)/4, networths, '*-');
    xlim([1988, 2010.25])
    ylim([-0.3, 0.45])
    ylabel({'Equity'; 'Log-Level'})
    
    subplot(2, 2, 4)
    [AX, H1, H2] = plotyy(2010.25-118/4+(1:118)/4, networth, ...
        2010.25-118/4+(1:118)/4, equity_cee);
    set(AX(1), 'xlim', [1988, 2010.25])
    set(AX(1), 'ylim', [-0.3, 0.45])
    set(AX(1), 'ytick', [-0.2:0.1:0.4])
    set(AX(2), 'xlim', [1988, 2010.25])
    set(AX(2), 'ylim', [-0.05, 0.07])
    set(H2, 'marker', '*')
    fs = get(gcf,'defaultaxesfontsize')+4;
    text(1971, 1.6, 'Figure 5. Historical Decompositions in Two Models','fontsize',fs)
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

xlimits=get(AX(1),'XLim'); %get axis 

min_idx=min(find(NBER_recessions(:,1)-xlimits(1)>=0));

NBER_recessions=NBER_recessions(min_idx:end,:);


if NBER_recessions(1,1)<xlimits(1)
    NBER_recessions(1,1)=xlimits(1);
end


if NBER_recessions(end,end)>xlimits(2)
    NBER_recessions(end,end)=xlimits(2);
end
ylimits=get(AX(1),'YLim'); %get axis 
 
%put nber recessions as bars
for iiii=1:1:size(NBER_recessions,1),

    %full grey area, without edges 
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9],'EdgeColor','none'); hold on
    
    %edges at bottom
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(1) ylimits(1)]',[0.9 0.9 0.9]); hold on
    
    %edges at top
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
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
    [AX2, H1, H2] = plotyy(2010.25-118/4+(1:118)/4, networth, ...
        2010.25-118/4+(1:118)/4, equity_cee);
    set(AX2(1), 'xlim', [1988, 2010.25])
    set(AX2(1), 'ylim', [-0.3, 0.45])
    set(AX2(1), 'ytick', [-0.2:0.1:0.4])
    set(AX2(2), 'xlim', [1988, 2010.25])
    set(AX2(2), 'ylim', [-0.05, 0.07])
    set(H2, 'marker', '*')
    text(1957, -0.44,...
      {['Notes: First row of graphs - actual GDP growth (solid line) and model simulated growth (starred line). ']; ...
      ['Second row of graphs - same as first row, except data pertains to log level of real, per capita equity.']; ...
      ['Columns - simulation of indicated model in response to smoothed estimate of indicated shock.']}, ...
      'clipping', 'off');
    print('-dpdf', 'figure5.pdf')
@# endif