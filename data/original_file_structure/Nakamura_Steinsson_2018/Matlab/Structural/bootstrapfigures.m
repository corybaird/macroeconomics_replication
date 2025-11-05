function [] = bootstrapfigures(par,model,bootstrap)

% Function that plots IRFs for the model, with bootstrapped confidence
% bands.

% Recall ordering of variables in modelINFO
%  [1]    x_t         % output gap 
%  [2]    E_t x_t+1
%  [3]    pi_t        % inflation 
%  [4]    E_t pi_t+1      
%  [5]    r_t         % nominal interest rate 
%  [6]    r_t-1
%  [7]    E_t-1 pi_t
%  [8]    pi_t-1
%  [9]    rbar_t      % MP real rate shock
%  [10]   rbar_t-1
%  [11]   rbar2_t     % 2nd more persistent MP real rate shock
%  [12]   r^n_t       % Natural rate of interest
%  [13]   y_t         % output
%  [14]   y_t^n       % Natural rate of output
%  [15]   lambda_xt    % Marginal utility gap
%  [16]   E_t lambda_xt+1
%  [17]   E_t r^n_t+1
%  [18]   y^n_t-1     % lagged natural rate
%  [19]   sp_t        % Stock price
%  [20]   E_t sp_t+1
%  [21]   E_t y_t+1
%  [22]   lambda_yt   % Marginal utility
%  [23]   E_t lambda_yt+1
%  [24]   Dummy
%  [25]   a_t         % productivity
%  [26]   y^n_t-2     % twice lagged natural rate of output
%  [27]   r^n_t-1     % lagged natural rate of interest
%  [28]   eps_t       % Initial natural rate of output response
%  [29]   E_t y^n_t+1 % Expected future natural rate of output


% Set Matlab plot options
set(0,'DefaultFigureWindowStyle','normal')

% Create folder structure
% Basic structure: cd/output/bootstrap_figures
% NOTE: figures folder is replaced each time the code is run with the
%       option save 'on'.
if strcmp(par.figures.save,'on')
    
    if exist('output','dir') ~= 7
        mkdir(cd,'output')
    end
    cd('output')
    
    if exist('bootstrap_figures','dir') == 7
        rmdir('bootstrap_figures','s')
    end
    mkdir('bootstrap_figures')
    cd('bootstrap_figures')
    
    mkdir(cd,'model_original')
    mkdir(cd,'model_counterfactual')
    mkdir(cd,'model_difference')
    
    cd ../..
end

% Define and preallocate variables
TT = par.figures.TT;
tol = par.figures.tol;
dt = 0:1:TT;
orIRFs = zeros(TT+1,29,7,3);
IRFs = zeros(TT+1,6,7,3);

modelfolders = {'original',...
                'counterfactual',...
                'difference'};

            
% STEP 0: construct quantiles for synthetic variables (output growth and
%         real interest rate).

% Output growth quantiles
% NOTE: use dummy variable [24] to store output growth
model(1,1).irfs.modelINFO(:,24) = 4.*[0; ...
                                   model(1,1).irfs.modelINFO(2:end,13) - ...
                                   model(1,1).irfs.modelINFO(1:end-1,13)];
model(1,1).irfs.modelINFO_counterfactual(:,24) = 4.*[0; ...
                                   model(1,1).irfs.modelINFO_counterfactual(2:end,13) - ...
                                   model(1,1).irfs.modelINFO_counterfactual(1:end-1,13)];
model(1,1).irfs.modelINFO_difference(:,24) = 4.*[0; ...
                                   model(1,1).irfs.modelINFO_difference(2:end,13) - ...
                                   model(1,1).irfs.modelINFO_difference(1:end-1,13)];
for i = 1:par.bootstrap.draws
    bootstrap.distributions.irfs.modelINFO(i,:,24) = ...
        4.*[0; squeeze(bootstrap.distributions.irfs.modelINFO(i,2:end,13))' - ...
            squeeze(bootstrap.distributions.irfs.modelINFO(i,1:end-1,13))'];
    bootstrap.distributions.irfs.modelINFO_counterfactual(i,:,24) = ...
        4.*[0; squeeze(bootstrap.distributions.irfs.modelINFO_counterfactual(i,2:end,13))' - ...
            squeeze(bootstrap.distributions.irfs.modelINFO_counterfactual(i,1:end-1,13))'];
    bootstrap.distributions.irfs.modelINFO_difference(i,:,24) = ...
        4.*[0; squeeze(bootstrap.distributions.irfs.modelINFO_difference(i,2:end,13))' - ...
            squeeze(bootstrap.distributions.irfs.modelINFO_difference(i,1:end-1,13))'];
end
bootstrap.statistics.quantiles.irfs.modelINFO(:,:,24) = ...
    quantile(bootstrap.distributions.irfs.modelINFO(:,:,24),...
             [.005 ,.01, .025, .05, .1, .25, .5 ,.75, .9, .95, .975, .99, .995],...
             1);
bootstrap.statistics.quantiles.irfs.modelINFO_counterfactual(:,:,24) = ...
    quantile(bootstrap.distributions.irfs.modelINFO_counterfactual(:,:,24),...
             [.005 ,.01, .025, .05, .1, .25, .5 ,.75, .9, .95, .975, .99, .995],...
             1);
bootstrap.statistics.quantiles.irfs.modelINFO_difference(:,:,24) = ...
    quantile(bootstrap.distributions.irfs.modelINFO_difference(:,:,24),...
             [.005 ,.01, .025, .05, .1, .25, .5 ,.75, .9, .95, .975, .99, .995],...
             1);

% Real interest rate quantiles
% NOTE: use marginal utility variable [22] to store real interest rate
model(1,1).irfs.modelINFO(:,22) = model(1,1).irfs.modelINFO(:,5) - ...
                                  model(1,1).irfs.modelINFO(:,4);
model(1,1).irfs.modelINFO_counterfactual(:,22) = model(1,1).irfs.modelINFO_counterfactual(:,5) - ...
                                                 model(1,1).irfs.modelINFO_counterfactual(:,4);
model(1,1).irfs.modelINFO_difference(:,22) = model(1,1).irfs.modelINFO_difference(:,5) - ...
                                             model(1,1).irfs.modelINFO_difference(:,4);
for i = 1:par.bootstrap.draws
    bootstrap.distributions.irfs.modelINFO(i,:,22) = ...
        squeeze(bootstrap.distributions.irfs.modelINFO(i,:,5))' - ...
        squeeze(bootstrap.distributions.irfs.modelINFO(i,:,4))';
    bootstrap.distributions.irfs.modelINFO_counterfactual(i,:,22) = ...
        squeeze(bootstrap.distributions.irfs.modelINFO_counterfactual(i,:,5))' - ...
        squeeze(bootstrap.distributions.irfs.modelINFO_counterfactual(i,:,4))';
    bootstrap.distributions.irfs.modelINFO_difference(i,:,22) = ...
        squeeze(bootstrap.distributions.irfs.modelINFO_difference(i,:,5))' - ...
        squeeze(bootstrap.distributions.irfs.modelINFO_difference(i,:,4))';
end
bootstrap.statistics.quantiles.irfs.modelINFO(:,:,22) = ...
    quantile(bootstrap.distributions.irfs.modelINFO(:,:,22),...
             [.005 ,.01, .025, .05, .1, .25, .5 ,.75, .9, .95, .975, .99, .995],...
             1);
bootstrap.statistics.quantiles.irfs.modelINFO_counterfactual(:,:,22) = ...
    quantile(bootstrap.distributions.irfs.modelINFO_counterfactual(:,:,22),...
             [.005 ,.01, .025, .05, .1, .25, .5 ,.75, .9, .95, .975, .99, .995],...
             1);
bootstrap.statistics.quantiles.irfs.modelINFO_difference(:,:,22) = ...
    quantile(bootstrap.distributions.irfs.modelINFO_difference(:,:,22),...
             [.005 ,.01, .025, .05, .1, .25, .5 ,.75, .9, .95, .975, .99, .995],...
             1);


% STEP 1: grab IRFs from model structure and quantiles from bootstrap
% NOTE: Recall quantiles in bootstrap structure are
%       [.005 ,.01, .025, .05, .1, .25, .5 ,.75, .9, .95, .975, .99, .995]

% Original IRFs
orIRFs(:,:,1,1) = model(1,1).irfs.modelINFO;
orIRFs(:,:,1,2) = model(1,1).irfs.modelINFO_counterfactual;
orIRFs(:,:,1,3) = model(1,1).irfs.modelINFO_difference;

% 2.5% Quantile (95% Confidence Interval)
orIRFs(:,:,2,1) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO(3,:,:));
orIRFs(:,:,2,2) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_counterfactual(3,:,:));
orIRFs(:,:,2,3) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_difference(3,:,:));

% 5% Quantile (90% Confidence Interval)
orIRFs(:,:,3,1) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO(4,:,:));
orIRFs(:,:,3,2) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_counterfactual(4,:,:));
orIRFs(:,:,3,3) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_difference(4,:,:));

% 95% Quantile (90% Confidence Interval)
orIRFs(:,:,4,1) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO(10,:,:));
orIRFs(:,:,4,2) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_counterfactual(10,:,:));
orIRFs(:,:,4,3) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_difference(10,:,:));

% 97.5% Quantile (95% Confidence Interval)
orIRFs(:,:,5,1) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO(11,:,:));
orIRFs(:,:,5,2) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_counterfactual(11,:,:));
orIRFs(:,:,5,3) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_difference(11,:,:));

% 10% Quantile (80% Confidence Interval)
orIRFs(:,:,6,1) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO(5,:,:));
orIRFs(:,:,6,2) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_counterfactual(5,:,:));
orIRFs(:,:,6,3) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_difference(5,:,:));

% 90% Quantile (80% Confidence Interval)
orIRFs(:,:,7,1) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO(9,:,:));
orIRFs(:,:,7,2) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_counterfactual(9,:,:));
orIRFs(:,:,7,3) = squeeze(bootstrap.statistics.quantiles.irfs.modelINFO_difference(9,:,:));

% Construct matrix of IRFs for plotting together with quantiles
for z = 1:3
    for j = 1:size(orIRFs,3)
        IRFs(:,:,j,z) = [orIRFs(:,5,j,z),...    % [1] Nom rate
                         orIRFs(:,22,j,z),...   % [2] Real rate
                         orIRFs(:,3,j,z),...    % [3] Inflation
                         orIRFs(:,12,j,z),...   % [4] Nat rate
                         orIRFs(:,1,j,z),...    % [5] Out Gap
                         orIRFs(:,24,j,z)];     % [6] Out Grwth
    end
end
IRFs(abs(IRFs)<tol) = 0;
            
% STEP 2: Figures

%     % Parameters of figures
width = 900;            % Window Horizontal Size
heigth = 600;           % Window Vertical Size
posx = 10;              % Window position (Lower left corner)
posy = 10;              % Window position (Lower left corner)
titles = {'Nominal Rate',...
          'Real Rate',...
          'Inflation',...
          'Natural Rate of Interest',...
          'Output Gap',...
          'Output Growth'};

for z = 1:3
    figure('Position', [posx posy width heigth])
    for i = 1:length(titles)
        subplot(2,3,i)
        hold on
        patch([dt, fliplr(dt)],...
              [IRFs(:,i,5,z)' fliplr(IRFs(:,i,2,z)')],...
              [0 0.4470 0.7410],...
              'facealpha',.15,...
              'edgecolor','none');
        patch([dt, fliplr(dt)],...
              [IRFs(:,i,3,z)' fliplr(IRFs(:,i,4,z)')],...
              [0 0.4470 0.7410],...
              'facealpha',.25,...
              'edgecolor','none');
        patch([dt, fliplr(dt)],...
              [IRFs(:,i,7,z)' fliplr(IRFs(:,i,6,z)')],...
              [0 0.4470 0.7410],...
              'facealpha',.35,...
              'edgecolor','none');
        plot(dt,IRFs(:,i,1,z),'linewidth',2);
        hold off
        title(titles{i})
%         if i == length(titles)-1
%                 legend('Baseline',...
%                        'No Habits',...
%                        'Alternative MP',...
%                        'No Habits and Alt. MP',...
%                        'Location','SouthEast')
%         end
        hline = refline(0,0);
        set(hline,'Color','black')
    end


    if strcmp(par.figures.save,'on')
        cd(['output/bootstrap_figures/model_' modelfolders{z}])
        fname = strcat(['IRFs_' modelfolders{z}]);
        set(gcf,'PaperPositionMode','auto');
        hgsave(fname);
        print('-depsc',fname);
        %print('-djpeg',fname,'-r256','-opengl');
        close
        cd ../../..
    end
end

end