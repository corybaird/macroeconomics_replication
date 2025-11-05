function [] = figures(par,model_analysis)
% Function that plots IRFs for the model.

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

% Determine cases for which figures are to be plotted
if strcmp(par.figures.cases,'on')
    if par.cases.run == 0
        par.figures.cases = 'off';
        par.cases.n = 1;
        par.cases.names = {'custom_run'};
    end
elseif strcmp(par.figures.cases,'off')
    if par.cases.run == 0
        par.cases.n = 1;
        par.cases.names = {'custom_run'};
    elseif par.cases.run == 1
        par.cases.n = 1;
    end
end

% Determine robustness for which figures are to be plotted
if strcmp(par.figures.robustness,'on')
    if par.robustness.run == 0
        par.figures.robustness = 'off';
        par.robustness.n = 1;
        par.robustness.names = {'custom_run'};
    end
elseif strcmp(par.figures.robustness,'off')
    if par.robustness.run == 0
        par.robustness.n = 1;
        par.robustness.names = {'custom_run'};
    elseif par.robustness.run == 1
        par.robustness.n = 1;
    end
end

% Create folder structure
% Basic structure: cd/output/figures/cases/robustness
% NOTE: figures folder is replaced each time the code is run with the
%       option save 'on'.
if strcmp(par.figures.save,'on')
    
    if exist('output','dir') ~= 7
        mkdir(cd,'output')
    end
    cd('output')
    
    if exist('figures','dir') == 7
        rmdir('figures','s')
    end
    mkdir('figures')
    cd('figures')
    
    for i = 1:par.cases.n
        mkdir(cd,['case_' par.cases.names{i}])
        cd(['case_' par.cases.names{i}])
        for j = 1:par.robustness.n
            mkdir(cd,['robustness_' par.robustness.names{j}])
            cd(['robustness_' par.robustness.names{j}])
            mkdir(cd,'model_original')
            mkdir(cd,'model_counterfactual')
            mkdir(cd,'model_difference')
            cd ..
        end
        cd ..
    end
    cd ../..
end


% Define and preallocate variables
TT = par.figures.TT;
tol = par.figures.tol;
dt = 0:1:TT;
orIRFs = zeros(TT+1,29,3);
IRFs = zeros(TT+1,12,3);

modelfolders = {'original',...
                'counterfactual',...
                'difference'};

for i = 1:par.cases.n
    for j = 1:par.robustness.n
        
        % STEP 1: grab IRFs
        % Original IRFs
        orIRFs(:,:,1) = model_analysis(i,j).irfs.modelINFO;
        orIRFs(:,:,2) = model_analysis(i,j).irfs.modelINFO_counterfactual;
        orIRFs(:,:,3) = model_analysis(i,j).irfs.modelINFO_difference;
        
        % Construct matrix of IRFs for plotting
        for z = 1:3
            Dy = 4 .* [0; orIRFs(2:end,13,z)-orIRFs(1:end-1,13,z)];
            IRFs(:,:,z) = [orIRFs(:,5,z),...                   % [1] Nominal rate
                           orIRFs(:,5,z)-orIRFs(:,4,z),...     % [2] Real rate
                           orIRFs(:,3,z),...                   % [3] Inflation
                           orIRFs(:,12,z),...                  % [4] Natural rate of interest
                           orIRFs(:,13,z),...                  % [5] Output
                           orIRFs(:,1,z),...                   % [6] Output Gap
                           Dy,...                              % [7] Output Growth
                           orIRFs(:,14,z),...                  % [8] Natural Rate of Output
                           orIRFs(:,9,z),...                   % [9] MP real rate shock
                           orIRFs(:,19,z),...                  % [10] Stock Price
                           orIRFs(:,25,z),...                  % [11] Productivity
                           orIRFs(:,22,z)];                    % [12] Marg Utility
        end
        IRFs(abs(IRFs)<tol) = 0;

        
        % STEP 2: GDP figure -- Compare GDP in Original vs Counterfactual

        % Parameters of figures
        width = 600;            % Window Horizontal Size
        heigth = 500;           % Window Vertical Size
        posx = 10;              % Window position (Lower left corner)
        posy = 10;              % Window position (Lower left corner)

        figure('Position', [posx posy width heigth])
        axis on
        p = plot(dt,IRFs(:,5,1),'b',...
                 dt,IRFs(:,5,2),'r-.');
        title('Output')
        legend('Output (original model)',...
               'Output (counterfactual)',...
               'Location','SouthEast')
        set(p,'LineWidth',2)
        hline = refline(0,0);
        set(hline,'Color','black')

        if strcmp(par.figures.save,'on')
            cd(['output/figures/case_' ...
                par.cases.names{i} ...
                '/robustness_'...
                par.robustness.names{j}])
            fname = strcat('Figure_GDPcomparison');
            set(gcf,'PaperPositionMode','auto');
            hgsave(fname);
            print('-depsc',fname);
            %print('-djpeg',fname,'-r256','-opengl');
            close
            cd ../../../..
        end
        
        
        % STEP 3: Stacked vs Separate Figures
        
        % Parameters of figures
        width = 600;           % Window Horizontal Size
        heigth = 500;           % Window Vertical Size
        posx = 10;              % Window position (Lower left corner)
        posy = 10;              % Window position (Lower left corner)

        for z = 1:3
            % -- FIGURE 1 --
            figure('Position', [posx posy width+200 heigth-75])
            subplot(1,2,1);
            axis on
            p = plot(dt,IRFs(:,1,z),'b',....
                     dt,IRFs(:,2,z),'r-.',...
                     dt,IRFs(:,3,z),'g--',...
                     dt,IRFs(:,4,z),'r.');
            title('Nominal Rates, Real Rates, and Inflation')
            legend('Nominal Rate',...
                   'Real Rate',...
                   'Inflation',...
                   'Natural Rate of Interest',...
                   'Location','NorthEast')
            set(p,'LineWidth',2)
            hline = refline(0,0);
            set(hline,'Color','black')

            subplot(1,2,2)
            axis on
            p = plot(dt,IRFs(:,7,z),'b',...
                     dt,IRFs(:,6,z),'r-.');
            title('Output Growth and Output Gap')
            legend('Output Growth','Output Gap','Location','SouthEast')
            set(p,'LineWidth',2)
            hline = refline(0,0);
            set(hline,'Color','black')

            if strcmp(par.figures.save,'on')
                cd(['output/figures/case_' ...
                par.cases.names{i} ...
                '/robustness_'...
                par.robustness.names{j},...
                '/model_'...
                modelfolders{z}])
                fname = strcat('Figure 1');
                set(gcf,'PaperPositionMode','auto');
                hgsave(fname);
                print('-depsc',fname);
                %print('-djpeg',fname,'-r256','-opengl');
                close
                cd ../../../../..
            end

            % -- FIGURE 2 --
            figure('Position', [posx posy width heigth])
            axis on
            p = plot(dt,IRFs(:,5,z),'b',...
                     dt,IRFs(:,6,z),'r-.',...
                     dt,IRFs(:,8,z),'g--');
            title('Output')
            legend('Output',...
                   'Output Gap',...
                   'Natural rate of output',...
                   'Location','SouthEast')
            set(p,'LineWidth',2)
            hline = refline(0,0);
            set(hline,'Color','black')

            if strcmp(par.figures.save,'on')
                cd(['output/figures/case_' ...
                par.cases.names{i} ...
                '/robustness_'...
                par.robustness.names{j},...
                '/model_'...
                modelfolders{z}])
                fname = strcat('Figure 2');
                set(gcf,'PaperPositionMode','auto');
                hgsave(fname);
                print('-depsc',fname);
                %print('-djpeg',fname,'-r256','-opengl');
                close
                cd ../../../../..
            end

            % -- FIGURE 3 --
            figure('Position', [posx posy width heigth])
            axis on
            p = plot(dt,IRFs(:,2,z),'b',...
                     dt,IRFs(:,9,z),'r-.',...
                     dt,IRFs(:,4,z),'g--');
            title('Real Rate, Rbar, and Natural Rate')
            legend('Real Rate',...
                   'Rbar',...
                   'Natural Rate of Interest',...
                   'Location','NorthEast')
            set(p,'LineWidth',2)
            hline = refline(0,0);
            set(hline,'Color','black')

            if strcmp(par.figures.save,'on')
                cd(['output/figures/case_' ...
                par.cases.names{i} ...
                '/robustness_'...
                par.robustness.names{j},...
                '/model_'...
                modelfolders{z}])
                fname = strcat('Figure 3');
                set(gcf,'PaperPositionMode','auto');
                hgsave(fname);
                print('-depsc',fname);
                %print('-djpeg',fname,'-r256','-opengl');
                close
                cd ../../../../..
            end
        end
    end
end




% % Decide whether to plot stacked or separate figures
% if strcmp(parsedInputs.Results.stacked,'on')
%     % Parameters of figures
%     width = 900;            % Window Horizontal Size
%     heigth = 1000;          % Window Vertical Size
%     posx = 10;              % Window position (Lower left corner)
%     posy = 10;              % Window position (Lower left corner)
%     titles = {'Nominal Rate',...
%               'Real Rate',...
%               'Inflation',...
%               'Natural Rate of Interest',...
%               'Output',...
%               'Output Gap',...
%               'Output Growth',...
%               'Natural Rate of Output',...
%               'Real Rate Shock',...
%               'Stock Price',...
%               'Productivity',...
%               'Marginal Utility'};
%     linestyles = {'-','--','-.',':'};
%     figure('Position', [posx posy width heigth])
%     for i = 1:length(titles)
%         subplot(3,4,i)
%         hold on
%         for j = 1:checks
%             plot(dt,irfs(:,i,j),...
%                  'linewidth',2,'linestyle',linestyles{j});
%         end
%         hold off
%         title(titles{i})
%         if i == length(titles)-1
%             if strcmp(parsedInputs.Results.robustness,'on')
%                 legend('Baseline',...
%                        'No Habits',...
%                        'Alternative MP',...
%                        'No Habits and Alt. MP',...
%                        'Location','SouthEast')
%             end
%         end
%         hline = refline(0,0);
%         set(hline,'Color','black')
%     end
%     if strcmp(parsedInputs.Results.save,'on')
%         fname = strcat('Stacked_IRFs');
%         set(gcf,'PaperPositionMode','auto');
%         hgsave(fname);
%         print('-depsc',fname);
%         %print('-djpeg',fname,'-r256','-opengl');
%         close
%     end
%     

% Reset Matlab Default for the Session
set(0,'DefaultFigureWindowStyle','docked')
end