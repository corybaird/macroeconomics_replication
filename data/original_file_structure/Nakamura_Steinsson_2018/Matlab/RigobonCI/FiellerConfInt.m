% Alternative, weak-instruments proof, heteroskedasticity based estimator
%
% Emi Nakamura and Jon Steinsson, Nov 2013
%
% In order to produce all three sets of estimates (i.e., one for the
% 30-minute policy news shock, one for the 1-day policy news shock,
% and one for the 1-day 2-year Treasury yields), you have to run this
% three times, replacing the value of par.indepVar, below, to each
% of ['path_intra_wide' 'path' 'DNY2_long'], respectively
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

s = RandStream('mt19937ar','Seed',10032013); % Seed set to: March 10th 2013 (date when it was first set)
RandStream.setGlobalStream(s);

%% Set Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of iterations in bootstrap
par.NBootAll = 5000;

% Set the independent variable to be used
par.indepVar = 'path_intra_wide'; % 'path_intra_wide' 'path' 'DNY2_long' 

% The level of the confidence interval to be constructed
if strmatch(par.indepVar,'DNY2_long')
  par.CILevel = 0.90;
else
  par.CILevel = 0.95;
end

% The full set of assets for which statistics are to be calculated:
par.estVar1 = {'DNY3M', 'DNY6M', 'DNY1', 'DNY5', 'DNY10', 'DNF1', 'DNF5', 'DNF10', 'DRY5' ...
           'DRY10', 'DRF5', 'DRF10', 'Dbkeveny5','Dbkeveny10','DIF5','DIF10'};

% The following four moments must be separated since the sample for them
% begins in 2004
par.estVar2 = {'DNY2', 'DNY3', 'DNF2', 'DNF3', 'DRY2', 'DRY3', 'DRF2', 'DRF3', ...
	      'Dbkeveny2','Dbkeveny3','DIF2','DIF3'};
par.estVar = [par.estVar1, par.estVar2];

% Choose asset to plot scatter of Dcov and Dvar as well as quantiles of
% g(gamma) as a function of gamma
par.VarToPlot = {'DNF2'};

% Grid for gamma
par.gammaLow = -10;
par.gammaHigh = 10;
par.gammaStep = 0.01;

par.plotgamma = 3; % +/- what to plot for g(gamma)

%% Read data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tablein= readtable('../../Stata/IntermediateFiles/dataForMatlabAltEstTick.csv');
tablein.date_daily = datenum(tablein.date_daily,23);
tablein.Properties.VariableNames([4:8]) = {'dffr1','dffr2','dedfutbeg2_m','dedfutbeg3','dedfutbeg4'};
dd = table2struct(tablein, 'ToScalar',true);

clearvars tablein

%% Point Estimates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Place estimate in a structure pe (for point estimates)

pe = struct;
for ii = 1:size(par.estVar1,2) % recall that par.estVar1 is defined at the top
    depVar = par.estVar1{ii};
    eval(['omegaFOMC = cov(dd.' par.indepVar '(dd.FOMCused==1,:),dd.' depVar '(dd.FOMCused==1,:),0);']);
    eval(['omegaCONT = cov(dd.' par.indepVar '(dd.FOMCused==0,:),dd.' depVar '(dd.FOMCused==0,:),0);']);
    omega = omegaFOMC - omegaCONT;
    eval(['pe.' depVar '=omega(1,2)/omega(1,1);']);
end
% The assets in par.estVar2 need to be in a separate loop because the sample 
% for them begins in 2004
for ii = 1:size(par.estVar2,2) % recall that par.estVar2 is defined at the top
    depVar = par.estVar2{ii};
    eval(['omegaFOMC = cov(dd.' par.indepVar '((dd.FOMCused==1&dd.year>2003),:),dd.' depVar '((dd.FOMCused==1&dd.year>2003),:),0);']);
    eval(['omegaCONT = cov(dd.' par.indepVar '((dd.FOMCused==0&dd.year>2003),:),dd.' depVar '((dd.FOMCused==0&dd.year>2003),:),0);']);
    omega = omegaFOMC - omegaCONT;
    eval(['pe.' depVar '=omega(1,2)/omega(1,1);']);
end
clearvars omega omegaFOMC omegaCONT depVar iin

%% Bootstrap Dcov, Dvar, and estimator (Dcov/Dvar)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Place bootstraped Dcov, Dvar and estimator in structure bst (for bootstrap)
% Notice that there is on Dcov and estimator for each dependent variable

bst = struct;
for ii = 1:size(par.estVar,2)
    depVar = par.estVar{ii};
    eval(['bst.Dcov'  depVar '=zeros(' num2str(par.NBootAll) ',1);']);
    eval(['bst.Dvar'  depVar '=zeros(' num2str(par.NBootAll) ',1);']);
end
clearvars depVar ii

% Create variable to use to stratify the bootstrap. Bootstrap needs to be
% divided into four strata: FOMCused==1&year<2004, FOMCused==0&year<2004, 
% FOMCused==1&year>=2004, FOMCused==0&year>=2004.
dd.stratNew = zeros(size(dd.dffr1,1),1);
dd.stratNew(dd.FOMCused==1&dd.year<2004,1) = 1;
dd.stratNew(dd.FOMCused==0&dd.year<2004,1) = 2;
dd.stratNew(dd.FOMCused==1&dd.year>=2004,1) = 3;
dd.stratNew(dd.FOMCused==0&dd.year>=2004,1) = 4;

% Create matrix named origData with original data to be bootstrapped
origData = zeros(size(dd.dffr1,1),2+size(par.estVar1,2)+size(par.estVar2,2)); 
eval(['origData(:,1)=dd.' par.indepVar ';']);
origData(:,2) = dd.FOMCused;

for ii = 1:size(par.estVar1,2)
    depVar = par.estVar1{ii};
    eval(['origData(:,' num2str(ii+2) ')=dd.' depVar ';']);
end
for ii = 1:size(par.estVar2,2)
    depVar = par.estVar2{ii};
    eval(['origData(:,' num2str(ii+2+size(par.estVar1,2)) ')=dd.' depVar ';']);
end
clearvars depVar ii

% Bootstrap empirical moments
fprintf('Bootstrap Dcov and Dvar: \n')
for ii = 1:par.NBootAll
    % Stratified resampling
    newData = stratBoot(origData, dd.stratNew);
    tempFOMCused = newData(:,2);
    
    % Calculate Dcov for each dependent variable
    for jj = 1:size(par.estVar1,2) % recall that par.estVar1 is defined at the top
        depVar = par.estVar1{jj};
        omegaFOMC = cov(newData(tempFOMCused==1,1),newData(tempFOMCused==1,2+jj),0);
        omegaCONT = cov(newData(tempFOMCused==0,1),newData(tempFOMCused==0,2+jj),0);
        omega = omegaFOMC - omegaCONT;
        eval(['bst.Dcov' depVar '(' num2str(ii) ',1)=omega(1,2);']);
        eval(['bst.Dvar' depVar '(' num2str(ii) ',1)=omega(1,1);']);
        eval(['bst.est' depVar '(' num2str(ii) ',1)=omega(1,2)/omega(1,1);']);
    end

    % The assets in par.estVar2 need to be in a separate loop because the sample
    % for them begins in 2004
    tempNotMissing = ~isnan(newData(:,2+size(par.estVar1,2)+1));
    for jj = 1:size(par.estVar2,2) % recall that par.estVar2 is defined at the top
        depVar = par.estVar2{jj};
        omegaFOMC = cov(newData((tempFOMCused==1&tempNotMissing),1),newData((tempFOMCused==1&tempNotMissing),2+size(par.estVar1,2)+jj),0);
        omegaCONT = cov(newData((tempFOMCused==0&tempNotMissing),1),newData((tempFOMCused==0&tempNotMissing),2+size(par.estVar1,2)+jj),0);
        omega = omegaFOMC - omegaCONT;
        eval(['bst.Dcov' depVar '(' num2str(ii) ',1)=omega(1,2);']);
        eval(['bst.Dvar' depVar '(' num2str(ii) ',1)=omega(1,1);']);
        eval(['bst.est' depVar '(' num2str(ii) ',1)=omega(1,2)/omega(1,1);']);
    end
    clearvars omega omegaFOMC omegaCONT depVar jj newData temp*
    
    % Print progress indicator
    if rem(ii,50) == 0
        fprintf('%1.0f ',ii)
    end
    if rem(ii,1000) == 0
        fprintf('\n')
    end
end
fprintf('\n')

%% Construct Confidence intervals etc. using g(gamma)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% g(gamma) = Dcov - gamma*Dvar
% g(gamma) = 0 when gamma = Dcov/Dvar
% We include in confidence interval values of gamma for which 
% g(gamma) = 0 cannot be rejected

pLow = (1-par.CILevel)/2;
pHigh = 1 - pLow;

% Range of gamma values considered
gammavec = (par.gammaLow:par.gammaStep:par.gammaHigh)';
par.NN = size(gammavec,1);

% Create structure to store results. 
% Results for each asset will be in separate sub-structure
results = struct;
results.gammavec = gammavec;

fprintf('Calculate CI, etc. for each asset: \n')
for ii = 1:size(par.estVar,2)
    eval(['results.' par.estVar{ii} ' = struct;']);
    
    % Construct regular bootstrap standard error
    eval(['results.' par.estVar{ii} '.BootSE = std(bst.Dcov' par.estVar{ii} './bst.Dvar' par.estVar{ii} ');']);
    
    % Calculate distribution of g(gamma) for each gamma on grid
    distGgamma = struct;
    distGgamma.pLow = zeros(par.NN,1);
    distGgamma.p50 = zeros(par.NN,1);
    distGgamma.pHigh = zeros(par.NN,1);
    for jj = 1:par.NN
        eval(['gofgamma = bst.Dcov' par.estVar{ii} ' - gammavec(jj,1)*bst.Dvar' par.estVar{ii} ';']);
        distGgamma.pLow(jj,1) = quantile(gofgamma,pLow);
        distGgamma.p50(jj,1) = quantile(gofgamma,0.5);
        distGgamma.pHigh(jj,1) = quantile(gofgamma,pHigh);
    end
    eval(['results.' par.estVar{ii} '.GgammapLow = distGgamma.pLow;']);
    eval(['results.' par.estVar{ii} '.GgammaP50 = distGgamma.p50;']);
    eval(['results.' par.estVar{ii} '.GgammapHigh = distGgamma.pHigh;']);
    
    % Construct median unbiased estimate of gamma
    [temp tempInd] = min(abs(distGgamma.p50));
    eval(['results.' par.estVar{ii} '.MedianUnbiased = gammavec(tempInd);']);
    
    % Construct lower bound 95% confidence interval (and check wether CI is an interval)
    q025LZero = (distGgamma.pLow < 0);
    q025GZero = (distGgamma.pLow >= 0);
    if sum(q025LZero) == 0
        % If all values of gamma rejected because g(gamma) > 0
        CILow = Inf;
        CILowNotInt = 0;
    else
        % Set lower end of confidence interval to smallest value for which
        % q025 of g(gamma) is less than zero
        minLZero = find(q025LZero,1,'first');
        CILow = gammavec(minLZero,1);
        % Check whether any larger values have (q025 of g(gamma)) > 0
        if size(find(q025LZero),1) == par.NN
            CILowNotInt = 0;
        else
            maxGZero = find(q025GZero,1,'last');
            CILowNotInt = (maxGZero > minLZero);
        end
    end
    eval(['results.' par.estVar{ii} '.CILow = CILow;' ]);
    
    % Construct upper bound 95% confidence interval (and check wether CI is an interval)
    q975LZero = (distGgamma.pHigh < 0);
    q975GZero = (distGgamma.pHigh >= 0);
    if sum(q975GZero) == 0
        % If all values of gamma rejected because g(gamma) < 0
        CIHigh = -Inf;
        CIHighNotInt = 0;
    else
        % Set upper end of confidence interval to largest value for which
        % q975 of g(gamma) is larger than zero
        maxGZero = find(q975GZero,1,'last');
        CIHigh = gammavec(maxGZero,1);
        % Check whether any smaller values have (q975 of g(gamma)) < 0
        if size(find(q975GZero),1) == par.NN
            CIHighNotInt = 0;
        else
            minLZero = find(q975LZero,1,'first');
            CIHighNotInt = (minLZero < maxGZero);
        end
    end
    CINotInt = (CIHighNotInt | CILowNotInt);
    eval(['results.' par.estVar{ii} '.CIHigh = CIHigh;']);
    eval(['results.' par.estVar{ii} '.CINotInt = (CIHighNotInt | CILowNotInt);']);    
    
    % Print progress indicator
    fprintf('%1.0f ',ii)
    if rem(ii,20) == 0
        fprintf('\n')
    end 
end

clear distGgamma CI* q025* q975* minLZero maxGZero temp tempInd ii jj gofgamma gammavec

f = fopen(['Output/FiellerTable_', par.indepVar, '.txt'], 'w');
% Plot the results
fprintf(f,'          P.E.    BstSE     M.U.         %1.2f CI         CINotInt \n',par.CILevel);
fprintf(f,'----------------------------------------\n');
fprintf(f,'DNY1:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DNY1, results.DNY1.BootSE, results.DNY1.MedianUnbiased, ...
    results.DNY1.CILow, results.DNY1.CIHigh, results.DNY1.CINotInt );
fprintf(f,'DNY2:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DNY2, results.DNY2.BootSE, results.DNY2.MedianUnbiased, ...
    results.DNY2.CILow, results.DNY2.CIHigh, results.DNY2.CINotInt );
fprintf(f,'DNY3:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DNY3, results.DNY3.BootSE, results.DNY3.MedianUnbiased, ...
    results.DNY3.CILow, results.DNY3.CIHigh, results.DNY3.CINotInt );
fprintf(f,'DNY5:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DNY5, results.DNY5.BootSE, results.DNY5.MedianUnbiased, ...
    results.DNY5.CILow, results.DNY5.CIHigh, results.DNY5.CINotInt );
fprintf(f,'DNY10:   %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DNY10, results.DNY10.BootSE, results.DNY10.MedianUnbiased, ...
    results.DNY10.CILow, results.DNY10.CIHigh, results.DNY10.CINotInt );
fprintf(f,'-----------------------------------------\n');
fprintf(f,'DRY2:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DRY2, results.DRY2.BootSE, results.DRY2.MedianUnbiased, ...
    results.DRY2.CILow, results.DRY2.CIHigh, results.DRY2.CINotInt );
fprintf(f,'DRY3:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DRY3, results.DRY3.BootSE, results.DRY3.MedianUnbiased, ...
    results.DRY3.CILow, results.DRY3.CIHigh, results.DRY3.CINotInt );
fprintf(f,'DRY5:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DRY5, results.DRY5.BootSE, results.DRY5.MedianUnbiased, ...
    results.DRY5.CILow, results.DRY5.CIHigh, results.DRY5.CINotInt );
fprintf(f,'DRY10:   %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DRY10, results.DRY10.BootSE, results.DRY10.MedianUnbiased, ...
    results.DRY10.CILow, results.DRY10.CIHigh, results.DRY10.CINotInt );
fprintf(f,'-----------------------------------------\n');
fprintf(f,'DNF2:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DNF2, results.DNF2.BootSE, results.DNF2.MedianUnbiased, ...
    results.DNF2.CILow, results.DNF2.CIHigh, results.DNF2.CINotInt );
fprintf(f,'DNF3:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DNF3, results.DNF3.BootSE, results.DNF3.MedianUnbiased, ...
    results.DNF3.CILow, results.DNF3.CIHigh, results.DNF3.CINotInt );
fprintf(f,'DNF5:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DNF5, results.DNF5.BootSE, results.DNF5.MedianUnbiased, ...
    results.DNF5.CILow, results.DNF5.CIHigh, results.DNF5.CINotInt );
fprintf(f,'DNF10:   %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DNF10, results.DNF10.BootSE, results.DNF10.MedianUnbiased, ...
    results.DNF10.CILow, results.DNF10.CIHigh, results.DNF10.CINotInt );
fprintf(f,'-----------------------------------------\n');
fprintf(f,'DRF2:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DRF2, results.DRF2.BootSE, results.DRF2.MedianUnbiased, ...
    results.DRF2.CILow, results.DRF2.CIHigh, results.DRF2.CINotInt );
fprintf(f,'DRF3:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DRF3, results.DRF3.BootSE, results.DRF3.MedianUnbiased, ...
    results.DRF3.CILow, results.DRF3.CIHigh, results.DRF3.CINotInt );
fprintf(f,'DRF5:    %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DRF5, results.DRF5.BootSE, results.DRF5.MedianUnbiased, ...
    results.DRF5.CILow, results.DRF5.CIHigh, results.DRF5.CINotInt );
fprintf(f,'DRF10:   %1.2f    (%1.2f)    %1.2f     [%1.2f, %1.2f]       %1.0f \n',pe.DRF10, results.DRF10.BootSE, results.DRF10.MedianUnbiased, ...
    results.DRF10.CILow, results.DRF10.CIHigh, results.DRF10.CINotInt );
fprintf(f,'-----------------------------------------\n');
fprintf(f,'\n');
fclose(f);

figure(1)
axis on

% Export results to excel
outOrder = {'DNY3M', 'DNY6M', 'DNY1', 'DNY2', 'DNY3', 'DNY5', 'DNY10', ...
	    'DRY2', 'DRY3', 'DRY5' 'DRY10', 'Dbkeveny2','Dbkeveny3', 'Dbkeveny5','Dbkeveny10' ...
	    'DNF1', 'DNF2', 'DNF3','DNF5', 'DNF10', 'DRF2', 'DRF3', 'DRF5', 'DRF10', ...
	    'DIF2','DIF3','DIF5','DIF10'};

f = fopen(['Output/FiellerOutput_', par.indepVar, '.csv'], 'w');
fprintf(f, 'Variable,Beta,BootSE,MedianUnbiased, CILow, CIhigh, CINoInt\n')
for ii = 1:length(outOrder)
  OutVec = zeros(1,6);
    OutVec(1) = eval(['pe.' outOrder{ii}]);
    OutVec(2) = eval(['results.' outOrder{ii} '.BootSE']);
    OutVec(3) = eval(['results.' outOrder{ii} '.MedianUnbiased']);
    OutVec(4) = eval(['results.' outOrder{ii} '.CILow']);
    OutVec(5) = eval(['results.' outOrder{ii} '.CIHigh']);
    OutVec(6) = eval(['results.' outOrder{ii} '.CINotInt']);
    fprintf(f, [outOrder{ii}, ',%4.2f,%4.2f,%4.2f,%4.2f,%4.2f,%4.2f\n'],OutVec);
end
fclose(f)

% Produce figures for one asset
mGvec = floor(size(results.gammavec,1)/2);
nGvec = par.plotgamma*100;
p = plot(results.gammavec((mGvec-nGvec+1):(mGvec+nGvec)),eval(['results.' par.VarToPlot{1} '.GgammaP50((mGvec-nGvec+1):(mGvec+nGvec))']),'b',...
         results.gammavec((mGvec-nGvec+1):(mGvec+nGvec)),eval(['results.' par.VarToPlot{1} '.GgammapHigh((mGvec-nGvec+1):(mGvec+nGvec))']),'b--',...
         results.gammavec((mGvec-nGvec+1):(mGvec+nGvec)),eval(['results.' par.VarToPlot{1} '.GgammapLow((mGvec-nGvec+1):(mGvec+nGvec))']),'b--');
title('g(gamma)')
legend('Median','q97.5','q2.5','Location','NorthEast')
set(p,'LineWidth',1)
hline = refline(0,0);
set(hline,'Color','black')

FiellerFigure = [ results.gammavec((mGvec-nGvec+1):(mGvec+nGvec)) ...
    eval(['results.' par.VarToPlot{1} '.GgammaP50((mGvec-nGvec+1):(mGvec+nGvec))']) ...
    eval(['results.' par.VarToPlot{1} '.GgammapHigh((mGvec-nGvec+1):(mGvec+nGvec))']) ...
    eval(['results.' par.VarToPlot{1} '.GgammapLow((mGvec-nGvec+1):(mGvec+nGvec))']) ];
xlswrite(['Output/FiellerFigure_', par.indepVar, '.xls'],FiellerFigure)

figure(2)
axis on
eval(['p = scatter(bst.Dcov' par.VarToPlot{1} ',bst.Dvar' par.VarToPlot{1} ');']);
title('Dvar and Dcov')
xlabel('Dcov')
ylabel('Dvar')
set(p,'LineWidth',1)
hline = refline(0,0);
set(hline,'Color','black')
clear p hline
    
FiellerScatter = [ eval(['bst.Dcov' par.VarToPlot{1}]) ...
    eval(['bst.Dvar' par.VarToPlot{1}]) ];
xlswrite(['Output/FiellerScatter_', par.indepVar, '.xls'],FiellerScatter)  
