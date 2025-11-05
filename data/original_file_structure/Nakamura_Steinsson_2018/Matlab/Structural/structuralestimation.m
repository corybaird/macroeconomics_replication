function [R] = structuralestimation(par,mpe)

% Routine that performs the minimization procedure for implementing SMM for
% the model.
%
% Takes as inputs:
% - mpe: structure containing moment point estimates that we want to target
% - par: structure containing global settings

% Generate weighting matrix based on standard deviations (except inflation)
A_base = eye(par.numMoments);
for ii = 1:par.numMoments
    eval(['A_base(ii,ii) = mpe.SD_' par.estVar{ii} '.^-1;']);
end


% Iterative Procedure (using GS or FMINCON)
% First Estimate AR roots fixing other parameters. Then, estimate other
% parameters using the estimated values of the AR roots. Reiterate n times
% using the estimataed values of the 3 parameters as initial conditions
% at each pass. Optional grid search for habits or calibration
% NOTE: only REAL MOMENTS used for AR roots. only INFLATION (GDP, Stock)
%       used for other 3 parameters.

% Setup Grid Search for Habits
if par.B_PSI_est == 2
    gridHabits = length(par.habitsVec);
else
    gridHabits = 1;
end

% Set initial conditions
x0 = zeros(1,length(par.x0),gridHabits);
for ii = 1:gridHabits
    if par.B_PSI_est == 2
        x0(1,:,ii) = [par.x0(1:4) par.habitsVec(ii)];
    else
        x0(1,:,ii) = par.x0;
    end
end

% Preallocate arrays for results
parameter = zeros(2 * par.maxiter + 1,size(x0,2),gridHabits);
parameter(1,:,:) = x0(1,:,:);              % Set initial conditions
exitflag = zeros(2*par.maxiter,gridHabits);
loss = zeros(2*par.maxiter,gridHabits);
exitline = (2 * par.maxiter + 1) .* ones(1,gridHabits);

% Define Weighting Matrix and Objective for AR ROOTS
A_AR = A_base;
for ii = 1:par.numMoments
    if ~ismember(par.estVar{ii},[par.estVar_RY, ...
                                 par.estVar_RF])
        A_AR(ii,ii) = 0;
    end
end

% Define Weighting Matrix and Objective for PSI XX and Habits
A_rest = A_base;
for ii = 1:par.numMoments
    if par.momentUse == 0
        if ~ismember(par.estVar{ii},[par.estVar_infl, ...
                                     par.estVar_GDP, ...
                                     par.estVar_stock])
            A_rest(ii,ii) = 0;
        end
    elseif par.momentUse == 1
        if ~ismember(par.estVar{ii},[par.estVar_infl, ...
                                     par.estVar_GDP])
            A_rest(ii,ii) = 0;
        end
    elseif par.momentUse == 2
        if ~ismember(par.estVar{ii},[par.estVar_infl])
            A_rest(ii,ii) = 0;
        end
    end
end

% Define Weighting Matrix and Objective for LOSS FUNCTION ANALYSIS
A_loss = A_base;
for ii = 1:par.numMoments
    if ~ismember(par.estVar{ii},[par.estVar_infl,...
                                 par.estVar_RY,...
                                 par.estVar_RF,...
                                 par.estVar_GDP,...
                                 par.estVar_infl,...
                                 par.estVar_stock])
        A_loss(ii,ii) = 0;
    end
end

% Upper bound for the "price rigidity" parameter which, equivalently,
% imposes that the minimizer only looks for Phillips curve slopes in [0,1]
ub_pc = (1-1e-4)/((1 - par.calibration.alpha) * (1 - par.calibration.alpha * par.calibration.beta ) / ...
         ( par.calibration.alpha * ( 1 + par.calibration.omega * par.calibration.theta ) ));

% Status update
for kk = 1:gridHabits
    for jj = 1:par.maxiter
        % Part 1: SOLVE FOR AR ROOTS
        % Define Objective Function
        obj_AR = @(yy) objectiveEstINFO(par,mpe,[yy parameter(2*jj-1,3:5,kk)],A_AR);

        % Define Optimization Problem and Run Minimization
        problem = createOptimProblem('fmincon',...
                                     'objective',obj_AR,...
                                     'x0',parameter(2*jj-1,1:2,kk),...
                                     'Aineq',[-1 1],...
                                     'bineq',-10^-3,...
                                     'Aeq',[],...
                                     'beq',[],...
                                     'lb',[-1+1e-4 -1+1e-4],...
                                     'ub',[1-1e-4 1-1e-4],...
                                     'nonlcon',[],...
                                     'options',par.options);

        % Decide solver and minimize
        if strcmp(par.solver,'GS')
            GS = GlobalSearch('Display','off','MaxTime',300);
            [par_ar, loss(2*jj-1,kk), exitflag(2*jj-1,kk), ~] = run(GS,problem);
        elseif strcmp(par.solver,'fmincon')
            [par_ar, loss(2*jj-1,kk), exitflag(2*jj-1,kk), ~] = fmincon(problem);
        else
            error('Solver can be fmincon, GS')
        end

        % Store output
        parameter(2*jj,:,kk) = [par_ar parameter(2*jj-1,3:5,kk)];


        % Part 2: SOLVE FOR REMAINING PARAMETERS
        % Decide whether to calibrate/grid search or optimize Habits parameter
        if par.B_PSI_est == 1 || par.B_PSI_est == 2

            % Define Objective Function
            obj_rest = @(yy) objectiveEstINFO(par,...
                                              mpe,...
                                              [parameter(2*jj-1,1:2,kk) yy x0(1,5,kk)],...
                                              A_rest);

            % Define Optimization Problem and Run Minimization
            problem = createOptimProblem('fmincon',...
                                         'objective',obj_rest,...
                                         'x0',parameter(2*jj,3:4,kk),...
                                         'Aineq',[],...
                                         'bineq',[],...
                                         'lb',[1e-4 1e-4],...
                                         'ub',[ub_pc 1-1e-4],...
                                         'nonlcon',[],...
                                         'options',par.options);

            % Decide solver and minimize
            if strcmp(par.solver,'GS')
                GS = GlobalSearch('Display','off','MaxTime',300);
                [par_rest, loss(2*jj,kk), exitflag(2*jj,kk), ~] = run(GS,problem);
            elseif strcmp(par.solver,'fmincon')
                [par_rest, loss(2*jj,kk), exitflag(2*jj,kk), ~] = fmincon(problem);
            else
                error('Solver can one of fmincon, GS')
            end

            % Store output
            parameter(2*jj+1,:,kk) = [parameter(2*jj,1:2,kk) par_rest x0(1,5,kk)];

        elseif par.B_PSI_est == 0
            obj_rest = @(yy) objectiveEstINFO(par,mpe,[parameter(2*jj-1,1:2) yy],A_rest);
            % Define Optimization Problem and Run Minimization
            problem = createOptimProblem('fmincon',...
                                         'objective',obj_rest,...
                                         'x0',parameter(2*jj,3:5),...
                                         'Aineq',[],...
                                         'bineq',[],...
                                         'lb',[1e-4 1e-4 1e-4],...
                                         'ub',[ub_pc 1-1e-4 1-1e-4],...
                                         'nonlcon',[],...
                                         'options',par.options);

            % Decide solver and minimize
            if strcmp(par.solver,'GS')
                GS = GlobalSearch('Display','off','MaxTime',300);
                [par_rest, loss(2*jj), exitflag(2*jj), ~] = run(GS,problem);
            elseif strcmp(par.solver,'fmincon')
                [par_rest, loss(2*jj), exitflag(2*jj), ~] = fmincon(problem);
            else
                error('Solver can be one of fmincon, GS')
            end

            % Store output
            parameter(2*jj+1,:) = [parameter(2*jj,1:2) par_rest];

        elseif par.B_PSI_est == 3
            
            % Define Objective Function
            obj_rest = @(yy) objectiveEstINFO(par,...
                                              mpe,...
                                              [parameter(2*jj-1,1:2,kk) yy x0(1,4:5,kk)],...
                                              A_rest);

            % Define Optimization Problem and Run Minimization
            problem = createOptimProblem('fmincon',...
                                         'objective',obj_rest,...
                                         'x0',parameter(2*jj,3,kk),...
                                         'Aineq',[],...
                                         'bineq',[],...
                                         'lb',1e-4,...
                                         'ub',ub_pc,...
                                         'nonlcon',[],...
                                         'options',par.options);

            % Decide solver and minimize
            if strcmp(par.solver,'GS')
                GS = GlobalSearch('Display','off','MaxTime',300);
                [par_rest, loss(2*jj,kk), exitflag(2*jj,kk), ~] = run(GS,problem);
            elseif strcmp(par.solver,'fmincon')
                [par_rest, loss(2*jj,kk), exitflag(2*jj,kk), ~] = fmincon(problem);
            else
                error('Solver can one of fmincon, GS')
            end

            % Store output
            parameter(2*jj+1,:,kk) = [parameter(2*jj,1:2,kk) par_rest x0(1,4:5,kk)];
            
        end

        % Decide whether to break from for loop upon convergence
        if par.conviter == 1
            if max(abs(parameter(2*jj+1,:,kk) - parameter(2*jj-1,:,kk))) < par.tol
                exitline(kk) = 2*jj+1;
%                 display(['Iterative procedure stopped earlier because ' ...
%                          'tolerance condition was met.'])
                break;            
            end
        end
    end
end

% Return Output
% Optimization details and complete set of parameters
R.lossSeq = loss;
R.exitflag = exitflag;
R.parameterSeq = parameter;
R.exitlineSeq = exitline;

% Find minimum for Grid Search Case
if par.B_PSI_est == 2
    R.lossEnd = zeros(gridHabits,1);
    for kk = 1:gridHabits
        R.lossEnd(kk) = loss(exitline(kk)-1,kk);
    end
    [R.minloss, R.minloss_idx] = min(R.lossEnd);
    R.loss = R.lossEnd(R.minloss_idx);
    R.parameter = parameter(exitline(R.minloss_idx),:,R.minloss_idx);
else
    R.loss = loss(exitline-1);
    R.parameter = parameter(exitline,:);
end

% Perform loss function analysis
[~, devVec] = objectiveEstINFO(par,mpe,R.parameter,A_loss);
R.lossAnalysis.RealYields = devVec(9:12)' * A_loss(9:12,9:12) * devVec(9:12);
R.lossAnalysis.RealForwards = devVec(13:16)' * A_loss(13:16,13:16) * devVec(13:16);
R.lossAnalysis.Stock = devVec(17)' * A_loss(17,17) * devVec(17);
R.lossAnalysis.GDP = devVec(18:25)' * A_loss(18:25,18:25) * devVec(18:25);
R.lossAnalysis.Inflation = devVec(26:29)' * A_loss(26:29,26:29) * devVec(26:29);

end
