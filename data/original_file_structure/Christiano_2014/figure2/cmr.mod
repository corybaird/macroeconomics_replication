%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code can be used to generate impulse responses from the model shown
% in figure 2.  You have to run dynare twice.  On the first run, set the
% Taylor rule inflation parameter to 1.5 by setting taylor1p5 = 1 below.
% After this runs, set the Taylor rule parameters to its mode by setting
% taylor1p5 = 0.  On this run, you will get a graph.
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

@# define financial_data = ["networth_obs", "credit_obs", "premium_obs", "Spread1_obs"]

@# include "../cmr_indicator_variables.mod"
@# define taylor1p5 = 0

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
@# define signal_corr_nonzero = 0

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
stoch_simul(order = 1, irf = 3000, nograph)
            gdp_obs consumption_obs investment_obs RL
            Rk Spread1_obs rL Re hours_obs sigma RealRe_obs gdp_obs  
            credit_obs networth_obs investment_obs consumption_obs  
            inflation_obs Re_obs premium_obs;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Process Results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Stoch_simul IRF's are for the deviation from steady state, but when the 
% steady state is unity (as in the case of all the _obs variables) then it 
% can also be interpreted as log deviation. This is why the cumsum 
% transformation is being used below to get the log-levels.

yr      = 100 * cumsum(gdp_obs_e_sigma);
cr      = 100 * cumsum(consumption_obs_e_sigma);
ir      = 100 * cumsum(investment_obs_e_sigma);
creditr = 100 * cumsum(credit_obs_e_sigma);
netwr   = 100 * cumsum(networth_obs_e_sigma);
sloper  = 40000 * Spread1_obs_e_sigma;
premr   = 40000 * premium_obs_e_sigma;
riskr   = sigma_e_sigma;
inflr   = 400 * inflation_obs_e_sigma;%

gg = 1:16;

ss = 0:(length(gg) - 1);
%
cr8      = 100 * cumsum(consumption_obs_e_xi8);
yr8      = 100 * cumsum(gdp_obs_e_xi8);
ir8      = 100 * cumsum(investment_obs_e_xi8);
creditr8 = 100 * cumsum(credit_obs_e_xi8);
netwr8   = 100 * cumsum(networth_obs_e_xi8);
sloper8  = 40000 * Spread1_obs_e_xi8;
premr8   = 40000 * premium_obs_e_xi8;
riskr8   = sigma_e_xi8;
inflr8   = 400 * inflation_obs_e_xi8;%

dd=sqrt(sum(premium_obs_e_sigma.^2)*sum(gdp_obs_e_sigma.^2));
dd8=sqrt(sum(premium_obs_e_xi8.^2)*sum(gdp_obs_e_xi8.^2));

for ii = 1:16
   t1=[ii:length(premium_obs_e_sigma)];
   t2=[1:length(premium_obs_e_sigma)-(ii-1)];
   rhoplusk(ii)=sum(gdp_obs_e_sigma(t1).*premium_obs_e_sigma(t2))/dd;
   rhox8plusk(ii)=sum(gdp_obs_e_xi8(t1).*premium_obs_e_xi8(t2))/dd8;
   rhominusk(ii)=sum(gdp_obs_e_sigma(t2).*premium_obs_e_sigma(t1))/dd;
   rhox8minusk(ii)=sum(gdp_obs_e_xi8(t2).*premium_obs_e_xi8(t1))/dd8;
end

rho=[rhominusk([end:-1:1]) rhoplusk([2:end])];
rhox8=[rhox8minusk([end:-1:1]) rhox8plusk([2:end])];


% following are the impulse responses of consumption when the weight on 
% inflation in the Taylor rule is 1.5 and all other parameters are at their
% baseline values (the correlation between the signals, though, is zero)

@# if taylor1p5 == 1
    ccr=cr;
    ccr8=cr8;
    save results_taylor1p5 ccr ccr8;
    return
@# else
    load results_taylor1p5 ccr ccr8;
    orient landscape
    ia = 3;
    ib = 3;
    aa=riskr(1)/max(riskr8);
    subplot(ia, ib, 6)

    plot(ss, cr(gg), ss, cr8(gg)*aa, 'o-');
    hold on;
    plot(ss, ccr(gg), ss, ccr8(gg), 'o-', 'LineWidth', 4)
    ll = legend('Response to unanticipated risk shock, \xi_{0,0}', ...
           'Response to anticipated risk shock, \xi_{8,0}', ...
           'Response to \xi_{0,0} with \alpha_{\pi}=1.5',...
           'Response to \xi_{8,0} with \alpha_{\pi}=1.5');
    pos = get(ll,'position');
    set(ll,'position', [.72, .15 0.2 0.15])
    title('F: Consumption')
    ylabel({'Percent Deviation';'from Steady State'})
    axis tight
    subplot(ia, ib, 4)
    plot(ss, yr(gg), ss, yr8(gg)*aa, 'o-')
    title('D. Output')
    ylabel({'Percent Deviation';'from Steady State'})
    axis tight
    subplot(ia, ib, 8)
    plot(ss, riskr(gg), ss, riskr8(gg)*aa, 'o-')
    title('H. Risk Shock, \sigma_{t}')
    ylabel('Deviation from Steady State')
    axis tight
    subplot(ia, ib, 1)
    plot(ss, premr(gg), ss, premr8(gg)*aa, 'o-')
    title('A. Interest Rate Spread')
    ylabel('Annual Basis Points')
    axis tight
    subplot(ia, ib, 3)
    plot(ss, ir(gg), ss, ir8(gg)*aa, 'o-')
    title('C. Investment')
    ylabel({'Percent Deviation';'from Steady State'})
    axis tight
    subplot(ia, ib, 2)
    plot(ss, creditr(gg), ss, creditr8(gg)*aa, 'o-')
    title('B. Credit')
    ylabel({'Percent Deviation';'from Steady State'})
    axis tight
    subplot(ia, ib, 5)
    plot(ss, netwr(gg), ss, netwr8(gg)*aa, 'o-')
    title('E. Net Worth')
    ylabel({'Percent Deviation';'from Steady State'})
    axis tight
    subplot(ia, ib, 7)
    plot(ss, sloper(gg), ss, sloper8(gg)*aa, 'o-')
    title('G. Slope of Term Structure')
    ylabel('Annual Basis Points')
    axis tight

    str = ['Figure 2. Dynamic Responses to Unanticipated '...
           'and Anticipated Components of the Risk Shock'];
    hout = suptitle(str);
    print('-dpdf', 'figure2.pdf')
@# endif