function [model] = modelestimation(par,mpe)

% Wrapper function for structuralestimation routine. Also perform model 
% analysis and robustness cases for ESTIMATION and POST-ESTIMATION.
% Inputs:
% par - structure array with the parameters as defined in RUN.m
% mpe - structure array with the moment estimated in reduced form


% Case 1 - Custom run of the code
if par.cases.run == 0
    
    % Compute parameter estimates
    temp_output = structuralestimation(par,mpe);
    
    % Compute IRFs
    if par.robustness.run == 0
        model.estimation = temp_output;
        model.irfs = modelIRFs(par,temp_output);
        model.parameters = modelParameters(par,temp_output);
        
    elseif par.robustness.run == 1
        for j = 1:par.robustness.n
            tempa = temp_output.parameter;
            idx = ~isnan(par.robustness.params(j,:));
            tempa(idx) = par.robustness.params(j,idx);
            tempb = par.robustness.MP{j};
            model(1,j).estimation = temp_output;
            model(1,j).irfs = modelIRFs(par,...
                                        temp_output,...
                                        'parameters',tempa,...
                                        'monetarypolicy',tempb);
            model(1,j).parameters = modelParameters(par,temp_output);
            clear temp1 temp2 idx j
        end
    end
    
% Case 2 - Run Robustness Cases for the ESTIMATION STAGE
elseif par.cases.run == 1
    for i = 1:par.cases.n
        % Assign cases parameter to par structure
        par.x0 = par.cases.x0(i,:);
        par.B_PSI_est = par.cases.B_PSI_est(i);
        
        % Loop to set custom parameter values (of those calibrated)
        for z = 1:length(par.cases.chgparams)
            eval(['par.calibration.' ...
                  par.cases.chgparams{z} ...
                  ' = par.cases.' ...
                  par.cases.chgparams{z} ...
                  '(i);']);
        end
        
        % Compute point estimates
        temp_output = structuralestimation(par,mpe);
        
        % Compute IRFs
        if par.robustness.run == 0
            model(i,1).irfs = modelIRFs(par,temp_output);
            model(i,1).estimation = temp_output;
            model(i,1).parameters = modelParameters(par,temp_output);
            
        elseif par.robustness.run == 1
            for j = 1:par.robustness.n
                tempa = temp_output.parameter;
                idx = ~isnan(par.robustness.params(j,:));
                tempa(idx) = par.robustness.params(j,idx);
                tempb = par.robustness.MP{j};
                model(i,j).irfs = modelIRFs(par,...
                                            temp_output,...
                                            'parameters',tempa,...
                                            'monetarypolicy',tempb);
                model(i,j).estimation = temp_output;
                model(i,j).parameters = modelParameters(par,temp_output);
            end
        end
        
        clear temp_output
    end
end

end