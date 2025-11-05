function [bootstrap, ncrash] = bootstrapmomentsmodel(par,data)

% Function that computes bootstrapped distributions of the moments and of
% the model's estimated parameters.

% Step 0: amend parameters structure and define random number generation
% setup
% NOTE: here only the custom case/robustness is considered for bootstrap.
rng(par.bootstrap.seed)
par.cases.run           = 0;
par.robustness.run      = 0;
if par.bootstrap.parallel == 1
    par.options.UseParallel = 0;
end

% Step 1: create strata variables.
% NOTE: here we create strata variables for both datasets (nonGDP and GDP
%       data). The nonGDP dataset has 4 strata, for FOMC meetings and for
%       years prior to 2004 or after 2004.
%       The GDP moments have strata to deal with missing observations
bootstrapdata = bootstrapdataset(data);


% Step 2: run bootstrap

% Step 2.a Run preliminary model to check functionality of the code and
% create suitable structure to allocate the bootstrapped distributions.
                         
% Run model with baseline dataset as a check for consistency.
tempmoments = momentestimation(par,bootstrapdata);
tempmodel = modelestimation(par,tempmoments);

% Create bootstrap structure that contains the whole bootstrap distribution
% of the objects of interest (parameters, irfs etc)
% 1) Moments
bootstrap.moments = tempmoments;
tempmomentsnames = fieldnames(tempmoments);
for i = 1:length(tempmomentsnames)
    bootstrap.moments.(tempmomentsnames{i}) = zeros(par.bootstrap.draws,1);
end
% 2) estimated objects (parameters and IRFs)
% IRFs
bootstrap.irfs = tempmodel.irfs;
tempirfsnames = fieldnames(bootstrap.irfs);
for i = 1:length(tempirfsnames)
    bootstrap.irfs.(tempirfsnames{i}) = ...
        zeros(par.bootstrap.draws,par.figures.TT+1,29);
end
% Stock price
bootstrap.irfs.stockpriceimpact = zeros(par.bootstrap.draws,1);
% Parameters
bootstrap.parameters = tempmodel.parameters.estimated;
tempparameternames = fieldnames(bootstrap.parameters);
for i = 1:length(tempparameternames)
    bootstrap.parameters.(tempparameternames{i}) = ...
        zeros(par.bootstrap.draws,1);
end

% Step 2.b preallocate suitable results matrices and run parfor loop
tempstockMAT = zeros(par.bootstrap.draws,1);
tempirfsMAT = zeros(par.bootstrap.draws,par.figures.TT+1,29,length(tempirfsnames));
tempmomentsMAT = zeros(par.bootstrap.draws,length(tempmomentsnames));
tempparametersMAT = zeros(par.bootstrap.draws,length(tempparameternames));
ncrash = -ones(par.bootstrap.draws, 1);

if par.bootstrap.parallel == 1
    parfor i = 1:par.bootstrap.draws

        % In some very-rare instances, the bootstrap samples causes
        % fmincon to break--so we try-catch the samples, and keep track of this. 
        crashing = true;
	while crashing
	  ncrash(i) = ncrash(i) + 1;
	  try
            % Stratified bootstrap re-sampling
            tempdata = bootstrapsampling(bootstrapdata);

            % Compute moments and model estimates based on resampled data
            tempmoments = momentestimation(par,tempdata);
            tempmodel = modelestimation(par,tempmoments);
	    crashing = false;
	  end
        end

        % Populate output matrices
        % Moments
        a = zeros(1,length(tempmomentsnames));
        for j = 1:length(a)
            a(j) = tempmoments.(tempmomentsnames{j});
        end
        tempmomentsMAT(i,:) = a;
        
        % Stock Price Impact Response
        tempstockMAT(i) = tempmodel.irfs.stockpriceimpact;
        
        % IRFs
        c = zeros(par.figures.TT+1,29,length(tempirfsnames))
        for j = 1:length(tempirfsnames)
            c(:,:,j) = tempmodel.irfs.(tempirfsnames{j});
        end
        tempirfsMAT(i,:,:,:) = c;
        
        % Estimated Parameters
        b = zeros(1,length(tempparameternames));
        for j = 1:length(b)
            b(j) = tempmodel.parameters.estimated.(tempparameternames{j});
        end
        tempparametersMAT(i,:) = b;
    end
elseif par.bootstrap.parallel == 0
  for i = 1:par.bootstrap.draws
    fprintf('%4.0f', i)
        % Stratified bootstrap re-sampling
        tempdata = bootstrapsampling(bootstrapdata);

        % Compute moments and model estimates based on resampled data
        tempmoments = momentestimation(par,tempdata);
        tempmodel = modelestimation(par,tempmoments);

        % Populate output matrices
        % Moments
        a = zeros(1,length(tempmomentsnames));
        for j = 1:length(a)
            a(j) = tempmoments.(tempmomentsnames{j});
        end
        tempmomentsMAT(i,:) = a;
        
        % Stock Price Impact Response
        tempstockMAT(i) = tempmodel.irfs.stockpriceimpact;
        
        % IRFs
        c = zeros(par.figures.TT+1,29,length(tempirfsnames));
        for j = 1:length(tempirfsnames)
            c(:,:,j) = tempmodel.irfs.(tempirfsnames{j});
        end
        tempirfsMAT(i,:,:,:) = c;
        
        % Estimated Parameters
        b = zeros(1,length(tempparameternames));
        for j = 1:length(b)
            b(j) = tempmodel.parameters.estimated.(tempparameternames{j});
        end
        tempparametersMAT(i,:) = b;
    end    
end

% Copy bootstrapped distributions in suitable structure from matrices

for i = 1:par.bootstrap.draws
    % Moments
    for j = 1:length(tempmomentsnames)
        bootstrap.moments.(tempmomentsnames{j})(i) = tempmomentsMAT(i,j);
    end
    
    % IRFs
    for j = 1:length(tempirfsnames)
        if ~strcmp(tempirfsnames{j},'stockpriceimpact')
            bootstrap.irfs.(tempirfsnames{j})(i,:,:) = tempirfsMAT(i,:,:,j);
        end
    end
    
    % Stock Price
    bootstrap.irfs.stockpriceimpact(i) = tempstockMAT(i);
    
    % Parameters
    for j = 1:length(tempparameternames)
        bootstrap.parameters.(tempparameternames{j})(i) = ...
            tempparametersMAT(i,j);
    end
end

end
