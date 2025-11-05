%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calibrate the parameters.
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

stdlambdaf_p   =   0.010955960700000  ;  
stdmuup_p      =   0.003985791800000  ;	 
stdg_p         =   0.022812723300000  ;	 
stdmuzstar_p   =   0.007148784800000  ;	 
stdgamma_p     =   0.008103540300000  ;	 
stdepsil_p     =   0.004633811900000  ;	 
stdxp_p        =   0.489344620900000  ;	 
stdzetac_p     =   0.023325355100000  ;	 
stdzetai_p     =   0.054964824400000  ;	 
stdterm_p      =   0.001603753000000  ;	 
% Place holder for net worth
@# if sticky_wages
xiw_p          =   0.812796311400000  ;	 
@# else
xiw_p          =   0.0                ;
@# endif
b_p            =   0.735843822700000  ;	 
Fomegabar_p    =   0.005588569300000  ;	 
mu_p           =   0.214894511100000  ;	 
sigmaa_p       =   2.535553419500000  ;	 
Sdoupr_p       =  10.780000003400000  ;	 
@# if sticky_prices
xip_p          =   0.741218603400000  ;	 
@# else
xip_p          =   0.0                ;
@# endif
@# if taylor1p5 == 1
aptil_p        =   1.5;
@# else
aptil_p        =   2.396495942700000  ;	 
@# endif
rhotil_p       =   0.850296450300000  ;	 
iota_p         =   0.897367052100000  ;	 
iotaw_p        =   0.489073535900000  ;	 
iotamu_p       =   0.936565280700000  ;	 
adytil_p       =   0.364943654300000  ;
@# if some_financial_data
@# if signal_corr_nonzero	 
signal_corr_p  = 0.3861343781103740 ;	 
@# else
signal_corr_p  = 0                  ;
@# endif
@# else
signal_corr_p  = 0                  ;
@# endif
rholambdaf_p   = 0.9108528528580380 ;	 
rhomuup_p      = 0.9870257396836700 ;	 
rhog_p         = 0.9427215849959780 ;	 
rhomuzstar_p   = 0.1459051086113400 ;	 
rhoepsil_p     = 0.8089285617540170 ;	 
rhosigma_p     = 0.9706370265612010 ;	 
rhozetac_p     = 0.8968400853887450 ;	 
rhozetai_p     = 0.9086616567125290 ;	 
rhoterm_p      = 0.9743991813961140 ;	 
@# if stopsignal == 0  
stdsigma2_p    = 0.0282985295279650 ;
@# else
stdsigma2_p    = 0                  ;
@# endif
stdsigma1_p    = 0.0700061676650730 ;	 
	
		 

// Calibrated parameters.
actil_p           = 0;
adptil_p          = 0;
alpha_p           = 0.4;
aytil_p           = 0;
beta_p            = 0.998704208591811;
bigtheta_p        = 0.005;
c_p               = 1.545858551297361;
delta_p           = 0.025;
epsil_p           = 1;
etag_p            = 0.2043;
g_p               = 0.586751768198739;
gamma_p           = 0.985;
i_p               = 0.739400293322006;
lambdaf_p         = 1.2;
lambdaw_p         = 1.05;
muup_p            = 1;
muzstar_p         = 1.004124413586981;
pi_p              = 1.006010795406775;
pibar_p           = 1.006010795406775;
pitarget_p        = 1.006010795406775;
psik_p            = 0;
psil_p            = 0;
psiL_p            = 0.7705;
Re_p              = 0.011470654984364;
rhogamma_p        = 0;
rhopitarget_p     = 0.975;
sigmaL_p          = 1;
sigma_p           = 0.327545843119697;
stdpitarget_p     = 0.0001;
tauc_p            = 0.047;
taud_p            = 0;
tauk_p            = 0.32;
taul_p            = 0.241;
tauo_p            = 1;
term_p            = 1;
upsil_p           = 1.004223171829000;
we_p              = 0.005;
zeta_p            = 1;
zetac_p           = 1;
zetai_p           = 1;
