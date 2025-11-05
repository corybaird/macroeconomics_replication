%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To create figure 4, run 'dynare cmr' in this directory.
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
% 4. Stochastic Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stoch_simul(order = 1, irf = 500, periods = 100000, nograph)
            gdp_obs consumption_obs investment_obs RL
           Rk Spread1_obs rL Re hours_obs sigma RealRe_obs gdp_obs  
           credit_obs networth_obs investment_obs consumption_obs  
           inflation_obs Re_obs premium_obs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Process Resutls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ia=3;
ib=3;

idx = 1:16;
% I want the response of the log level of a variable to a shock, in log 
% deviation from what it would have been if there had been no shock.
yr      = 100 * cumsum(gdp_obs_e_sigma);
cr      = 100 * cumsum(consumption_obs_e_sigma);
ir      = 100 * cumsum(investment_obs_e_sigma);
lrr     = 100 * cumsum(rL_e_sigma);

Rk_p = 0.0188063;
creditr = 100 * cumsum(credit_obs_e_sigma);
netwr   = 100 * cumsum(networth_obs_e_sigma);
sloper  = 40000 * Spread1_obs_e_sigma;
premr   = 40000 * premium_obs_e_sigma;
riskr   = sigma_e_sigma;
inflr   = 400 * inflation_obs_e_sigma;
Rkv     = 400 * (Rk_p * Rk_e_sigma - Re_p * Re_e_sigma);

gg = 1:16;
ss = 0:(length(gg) - 1);

cr8      = 100 * cumsum(consumption_obs_e_xi8);
yr8      = 100 * cumsum(gdp_obs_e_xi8);
ir8      = 100 * cumsum(investment_obs_e_xi8);
creditr8 = 100 * cumsum(credit_obs_e_xi8);
netwr8   = 100 * cumsum(networth_obs_e_xi8);
sloper8  = 40000 * Spread1_obs_e_xi8;
premr8   = 40000 * premium_obs_e_xi8;
riskr8   = sigma_e_xi8;
inflr8   = 400 * inflation_obs_e_xi8;

[Yr, I] = min(yr);

yrmei         = 100 * cumsum(gdp_obs_e_zetai);
[Yrmei, I]    = min(yrmei);
yrmei         = yrmei * Yr / Yrmei;
yrequity      = -100 * cumsum(gdp_obs_e_gamma);
[Yrequity, I] = min(yrequity);
yrequity      = yrequity * Yr / Yrequity;

crmei      = 100 * cumsum(consumption_obs_e_zetai) * Yr / Yrmei;
irmei      = 100 * cumsum(investment_obs_e_zetai) * Yr / Yrmei;
creditrmei = 100 * cumsum(credit_obs_e_zetai) * Yr / Yrmei;
netwrmei   = 100 * cumsum(networth_obs_e_zetai) * Yr / Yrmei;
slopermei  = 40000 * Spread1_obs_e_zetai * Yr / Yrmei;
premrmei   = 40000 * premium_obs_e_zetai * Yr / Yrmei;
riskrmei   = sigma_e_zetai * Yr / Yrmei;
inflrmei   = 400 * inflation_obs_e_zetai * Yr / Yrmei;
Rkmei      = 400 * (Rk_p * Rk_e_zetai - Re_p * Re_e_zetai) ...
                 * Yr / Yrmei;

crequity      = -100 * cumsum(consumption_obs_e_gamma) * Yr / Yrequity;
irequity      = -100 * cumsum(investment_obs_e_gamma) * Yr / Yrequity;
creditrequity = -100 * cumsum(credit_obs_e_gamma) * Yr / Yrequity;
netwrequity   = -100 * cumsum(networth_obs_e_gamma) * Yr / Yrequity;
sloperequity  = -40000 * Spread1_obs_e_gamma * Yr / Yrequity;
premrequity   = -40000 * premium_obs_e_gamma * Yr / Yrequity;
riskrequity   = -sigma_e_gamma * Yr / Yrequity;
inflrequity   = -400 * inflation_obs_e_gamma * Yr / Yrequity;
Rkequity      = -400 * (Rk_p * Rk_e_gamma - Re_p * Re_e_gamma) ...
                    * Yr / Yrequity;

fsz = 10;
orient landscape
subplot(ia, ib, 6)
plot(ss, cr(gg), ss, crmei(gg), 'o-', ss, crequity(gg), '*-')
title('F. Consumption')
axis tight
subplot(ia, ib, 4)
plot(ss, yr(gg), ss, yrmei(gg), 'o-', ss, yrequity(gg), '*-')
title('D. Output')
axis tight
subplot(ia, ib, 1)
plot(ss, premr(gg), ss, premrmei(gg), 'o-', ss, premrequity(gg), '*-')
title({'A. Interest Rate Spread';'Annual Basis Points'})
axis tight
subplot(ia, ib, 3)
plot(ss, ir(gg), ss, irmei(gg), 'o-', ss, irequity(gg), '*-')
title('C. Investment')
axis tight
subplot(ia, ib, 2)
plot(ss, creditr(gg), ss, creditrmei(gg), 'o-', ...
     ss, creditrequity(gg), '*-')
title('B. Credit')
axis tight
subplot(ia, ib, 5)
plot(ss, netwr(gg), ss, netwrmei(gg), 'o-', ss, netwrequity(gg), '*-')
title('E. Net Worth')
axis tight
subplot(ia, ib, 7)
plot(ss, inflr(gg), ss, inflrmei(gg), 'o-', ss, inflrequity(gg), '*-')
title({'G. Inflation';'Annual Percentage Rate'})
axis tight
subplot(ia, ib, 8)
plot(ss, Rkv(gg), ss, Rkmei(gg), 'o-', ss, Rkequity(gg), '*-')
title({'H. Excess Return on Capital'; 'Annual Percentage Rate'})
axis tight
subplot(ia, ib, 9)
plot(ss, sloper(gg), ss, slopermei(gg), 'o-', ss, sloperequity(gg), '*-')
title({'I. Slope of Term Structure';'Annual Basis Points'})
axis tight
suptitle({'Figure 4: Dynamic Responses'; 'to Three Shocks'});
ll=legend('Unanticipated risk shock, \xi_{0,0}', ...
       'Innovation in marginal efficiency of investment, \zeta _{I,t}',...
       'Negative innovation in equity shock, \gamma_{t}');
%set(ll,'position',[.45 -.05 .15 .15])
set(ll,'position',[0.75 .87 .15 .15])
legend boxoff
print('-dpdf', 'figure4.pdf')