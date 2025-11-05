%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Emi Nakamura and Jon Steinsson, 
% High Frequency Identification of Monetary Non-neutrality
% Code: Stéphane Dupraz & Michele Fornino
% 06/08/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This script performs the estimation part of the paper. This is a SMM
% estimation done two steps. First, estimate the empirical moments in the
% data paralleling the empirical part of the paper. Second, minimize the
% distance between the IRFs of the model and those implied by the estimated
% moments.



%% Housekeeping and Settings
% Create structure par that contains all of the settings used in the
% functions called throughout the code (works like a global variable).

clear
close all
clc
set(0,'DefaultFigureWindowStyle','docked');



% --------------------- Setup of estimation routine ----------------------%
% NOTE: this block defines options that are used to perform both a single
%       run of the code and an optional run where robustness is checked.
% NOTE: refer to the ensuing blocks "Cases" and "Robustness" to turn the
%       respective functions on and off.


% Select moments used in estimation step for XX/PSI/Habits parameters
% 0 = use inflation + output + stock
% 1 = use inflation + output
% 2 = use inflation
par.momentUse     = 1;

% Switch to use tick data instead of daily data
% 0 = daily
% 1 = tick
par.tickdata      = 1;

% Calibration of the remaining parameters of the model
% NOTE: serves as a baseline calibration also for the ESTIMATION ROBUSTNESS 
%       cases, for those parameter that are not changed.
par.calibration.beta    = 0.99;      % Subjective discount factor
par.calibration.alpha   = 0.75;      % nominal rigidity
par.calibration.omega   = 2;         % el of marginal cost to output
par.calibration.gamma   = 1;         % coeff on lagged inflation
par.calibration.psiPi   = 0.01;      % Endogenous feedback in Taylor rule
par.calibration.inftarg = 0.0;       % Inflation target shock
par.calibration.theta   = 10;        % el of substitution across varieties
par.calibration.sigma   = 0.5;        % Intertemporal el of substitution

% Select calibration or estimation of habits/information parameters
% NOTE: estimate refers to minimizing the quadratic loss function.
%       calibration gives up on estimation and requires a specific value
%       for the parameter. the grid search option is useful to assess the
%       robustness of the minimization procedure to local minima.
% 0 = estimate habits parameter        AND estimate information parameter
% 1 = calibrate habits parameter       AND estimate information parameter
% 2 = grid search for habits parameter AND estimate information parameter
% 3 = calibrate habits parameter       AND calibrate information parameter
par.B_PSI_est     = 1;

% Specify grid search array for habits parameter
% NOTE: only used if grid search for habits parameter is wanted.
par.habitsVec     = linspace(0.3,1-1e-4,100);

% Select starting point for optimization routine
% ORDER: AR root 1, AR root 2, Price Rigidity, PSI, Habits
% NOTE: this also serves as calibration of habits / habits+PSI if such
%       options are chosen
% NOTE: the first AR root must be larger than the second for identification
par.x0            = [0.9 0.78 0.1 0.6 0.9];  

% Optimization specifics
% Switch to select between iteration to convergence or iteration until
% maximum number of permitted iterations is reached.
% 0 = Run until maxiter (slower, use for debugging the optimization code)
% 1 = Iterate until convergence is achieved (faster)
par.conviter      = 1;

% Define maximum number of allowed iterations for optimization routine
par.maxiter       = 100;

% Set tolerance for convergence of optimization routine
% NOTE: tolerance level to consider two consecutive iterations as
%       identical.
par.tol           = 1e-3;

% Set solver used for optimization routine
% 'fmincon' = use fmincon for local optimization. Only local optima in the
%             basin of attraction of the starting point are found
% 'GS'      = use GlobalSearch for global optimization. This is much slower
%             but can find global optima.
par.solver        = 'fmincon';

% Set Matlab Options for solver (either FMINCON or GS) - DO NOT ALTER
par.options       = optimset('Diagnostics','off',...
                             'Display','off',...
                             'FunValCheck','on',...
                             'LargeScale','on',...
                             'Algorithm','interior-point',...
                             'TolX',10e-16,...
                             'TolFun',10e-16,...
                             'UseParallel',true);

% -------------------------- Setup of BOOTSTRAP --------------------------%
% This section is used to setup the bootstrap procedure.

% Specify number of bootstrapped datasets to be resampled (must be an
% integer)
par.bootstrap.draws     = 8;

% Decide whether to run the bootstrap algorithm in parallel.
% NOTE: parallellized computation significantly reduces run times. However,
%       the single runs are no longer reproducible.
% NOTE: if serial (not parallel) computation is specified, parallel
%       computation is still used for fmincon and elsewhere wherever
%       possible.
% 0 - run serial bootstrap (reproducible)
% 1 - run parallelized bootstrap (not reproducible, faster)
par.bootstrap.parallel  = 1;

% Specify seed for random number generation used to resample the datasets
% NOTE: in case parallelized bootstrap is spcified, the seed becomes
%       immaterial because the procedure is not anymore reproducible due to
%       the way single bootstrap runs are computed in parallel
%       independently of each other.
% NOTE: must be a positive integer.
par.bootstrap.seed      = 1;


% --------------- Setup of robustness cases for ESTIMATION ---------------%

% NOTE: use this section to set up a set of cases that one wants to check.
%       Useful for checking the properties of the estimation routine.
%       (e.g. robustness of estimates to change in sigma).
%       Use robustness option block to check robustness for given parameter
%       estimates (below).

% Main Switch
% 0 = use parameters defined above to run custom version of the analysis
% 1 = replace parameters above with those in the "cases" below
par.cases.run           = 0;

% Define Cases
par.cases.names         = {'Baseline',...
                           'Sigma0.25',...
                           'Sigma1',...
                           'Sigma0.1',...
                           'NoInfo', ...
			   'NoHabits',...
			   'FullInfo'};
par.cases.n             = length(par.cases.names);

% List all parameters that you wish to change in ESTIMATION robustness
% exercises
% NOTE: once one parameter is chosen, take care of including a suitable
%       vector of parameter values for each of the robustness cases. The
%       name of such parameter vector should be 'par.cases.[NAME OF PARAM]'
% NOTE: must be a *LIST OF STRINGS* among the following:
% - beta      % Subjective discount factor
% - alpha     % nominal rigidity
% - omega     % el of marginal cost to output
% - gamma     % coeff on lagged inflation
% - psiPi     % Endogenous feedback in Taylor rule
% - inftarg   % Inflation target shock
% - theta     % el of substitution across varieties
% - sigma     % Intertemporal el of substitution
par.cases.chgparams     = {'sigma'};

% Define custom values of parameters for robustness cases
par.cases.sigma         = [0.5;...
                           0.25;...
                           1;...
                           0.1;...
                           0.5;...
                           0.5;...
                           0.5];			   
                       
% Define calibration versus estimation of key parameters PSI and Habits
% 0 = estimate habits parameter        AND estimate information parameter
% 1 = calibrate habits parameter       AND estimate information parameter
% 2 = grid search for habits parameter AND estimate information parameter
% 3 = calibrate habits parameter       AND calibrate information parameter
par.cases.B_PSI_est     = [1;...
                           1;...
                           1;...
                           1;...
                           3;...
                           1;...
                           3];

% Define starting points and implicit calibrations of Habits and PSI
% ORDER: AR root 1, AR root 2, Price Rigidity, PSI, Habits (for each row)
% NOTE: this also serves as calibration of habits / habits+PSI if such
%       options are chosen
% NOTE: the first AR root must be larger than the second for identification
par.cases.x0            = [0.9 0.78 0.1 0.6  0.9;...
                           0.9 0.78 0.1 0.6  0.9;...
                           0.9 0.78 0.1 0.6  0.9;...
                           0.9 0.78 0.1 0.6  0.9;...
                           0.9 0.78 0.1 0    0.9;...
                           0.9 0.78 0.1 0.6  0  ;...
                           0.9 0.78 0.1 0.99 0.9];			   

                       
                       
% ------------ Setup of robustness cases for POST-ESTIMATION -------------%

% NOTE: use this section to set up a set of cases that one wants to check.
%       Useful for checking the properties of the model once the estimation
%       step has been performed (e.g., plot habits vs. no habits or optimal 
%       vs. alternative MP).

% NOTE: works together with modelAnalysis routine. Can change Monetary
%       Policy and parameter vector used to compute IRFs.

% Main Switch
% 0 = do not compute robustness cases
% 1 = replace parameters above with those in the "cases" below
par.robustness.run      = 0;

% Define Cases
par.robustness.names    = {'Habits',...
                           'NoHabits',...
                           'HabitsNoInfo',...
                           'NoHabitsNoInfo'};
par.robustness.n        = length(par.robustness.names);

% Monetary Policy
% 'optimal'     = use optimal MP rule
% 'alternative' = use alternative MP rule
par.robustness.MP       = {'optimal',...
                           'optimal',...
                           'optimal',...
                           'optimal'};
                       
% Parameters
% NOTE: Use NaN (Not a Number) to accept the estimated parameter, or insert 
%       a suitable alternative real scalar (e.g., a 1x5 row of NaN will
%       produce IRFs for the estimated parameters without any modification)
par.robustness.params   = [NaN NaN NaN NaN NaN;...
                           NaN NaN NaN NaN 0  ;...
                           NaN NaN NaN 0   NaN;...
                           NaN NaN NaN 0   0  ];

                       
                       
% ---------------------- Figures and Tables Options ----------------------%

% Length of impulse responses and corresponding plots
par.figures.TT          = 40;

% Tolerance to consider small numbers as 0 in plots
% NOTE: helps to solve numerical error issues in plots
par.figures.tol         = 10e-10;

% Produce single stacked figure with all IRFs
% par.figures.stacked     = 'off';

% Save figures to EPS and FIG files, creating a suitable folder structure
% NOTE: figures folder is replaced each time the code is run with the
%       option save 'on'.
par.figures.save        = 'on';

% Save figures of POST-ESTIMATION robustness or ESTIMATION cases
% NOTE: if either corresponding options in the robustness blocks are turned
%       off, then only the custom case will be plotted.
% NOTE: select 'off' to plot only the first case/robustness.
par.figures.robustness  = 'on';
par.figures.cases       = 'on';



% ------------------------ Variables and moments -------------------------%

% (1) Variables used to create path factor
par.pathVar       = {'dffr1', 'dffr2', 'dedfutbeg2_m', 'dedfutbeg3', ...
                     'dedfutbeg4', 'FOMCused', 'DNY1'}; 

% (2) Set of variables for which moments are calculated for full sample
% Nominal Yields
par.allVar_NY     = {'DNY3M','DNY6M','DNY1','DNY2','DNY3','DNY5','DNY10'};
% Nominal Forwards
par.allVar_NF     = {'DNF1','DNF2','DNF3','DNF5','DNF10'};
% Real Yields
par.allVar_RY     = {'DRY2', 'DRY3','DRY5', 'DRY10'};
% Real Forwards
par.allVar_RF     = {'DRF2', 'DRF3','DRF5', 'DRF10'};
% Stock Market
par.allVar_stock  = {'Dlsp500'};
% GDP expectations
par.allVar_GDP    = {'DRealGDP_0q', 'DRealGDP_F1q', 'DRealGDP_F2q', ...
                     'DRealGDP_F3q', 'DRealGDP_F4q', 'DRealGDP_F5q', ...
                     'DRealGDP_F6q', 'DRealGDP_F7q'};
% Inflation
par.allVar_infl   = {'PI2','PI3','PI5','PI10','PIF2','PIF3','PIF5','PIF10'};
% Collection of all moments to be used
par.allVar        = [par.allVar_NY, par.allVar_NF, par.allVar_RY,...
                     par.allVar_RF, par.allVar_stock, par.allVar_GDP,...
                     par.allVar_infl];
                 
% (3) Set of variables for which moments are calculated only after 2004
% Used in the estimation routine to deal with sample size differences
par.after2004     = {'DNY2', 'DNY3', 'DNF2', 'DNF3',...
                     'DRY2', 'DRY3', 'DRF2', 'DRF3'};
                 
% (4) Set of variables that can be used as moments in estimation:
par.estVar_NY     = {'DNY2','DNY3','DNY5','DNY10'};
par.estVar_NF     = {'DNF2','DNF3','DNF5','DNF10'};
par.estVar_RY     = {'DRY2', 'DRY3','DRY5', 'DRY10'};
par.estVar_RF     = {'DRF2', 'DRF3','DRF5', 'DRF10'};
par.estVar_stock  = {'Dlsp500'};
par.estVar_GDP    = {'DRealGDP_0q', 'DRealGDP_F1q', 'DRealGDP_F2q', ...
                     'DRealGDP_F3q', 'DRealGDP_F4q', 'DRealGDP_F5q', ...
                     'DRealGDP_F6q', 'DRealGDP_F7q'};
par.estVar_infl   = {'PI2','PI3','PI5','PI10','PIF2','PIF3','PIF5','PIF10'};
par.estVar        = [par.estVar_NY, par.estVar_NF, par.estVar_RY,...
                     par.estVar_RF, par.estVar_stock, par.estVar_GDP,...
                     par.estVar_infl];
par.numMoments    = length(par.estVar);




%% A) Moments Estimation and SMM Estimation of the Model(s)
% Load datasets and perform reduced form estimation of the target moments
% using datasets from Stata. Then estimates key parameter of the models
% selected above and computes IRFs.

data = loaddata(par);
moments = momentestimation(par,data);
model = modelestimation(par,moments);


%% B) Draw Figures
% NOTE: this section may be skipped.

%figures(par,model);

%% C) Bootstrap
% Run Bootstrap to get confidence intervals for estimated parameters.
[bootstrap.distributions, bootstrap.crashReport] = bootstrapmomentsmodel(par,data);
bootstrap.statistics = bootstrapstats(bootstrap.distributions);
%bootstrapfigures(par,model,bootstrap);
%save data_noinfo.mat
save ALLOUTPUT.mat

