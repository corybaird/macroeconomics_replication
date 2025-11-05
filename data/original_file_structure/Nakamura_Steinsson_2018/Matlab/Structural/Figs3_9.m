%% This file collects the impulse responses in Nakamura & Steinsson's
%% "High Frequency Idenfitication" paper. After running "RUN.m,"
%% under the "baseline" specification described in the README, this
%% code can quickly be run to pull the impulse responses shown in the
%% paper. 

%% Figure 3
figs.f3 = [model.irfs.modelINFO(:,5) - model.irfs.modelINFO(:,4) ...
           model.irfs.modelINFO(:,5) ...
           model.irfs.modelINFO(:,3)];

% Figure 4
figs.f4 = [4 .* [0; model.irfs.modelINFO(2:end,13) - model.irfs.modelINFO(1:end-1,13)] ...
           model.irfs.modelINFO(:,1)];

% Figure 5
figs.f5 = [model.irfs.modelINFO(:,12), ...
           model.irfs.modelINFO(:,5) - model.irfs.modelINFO(:,4)];

% Figure 6
figs.f6 = [model.irfs.modelINFO(:,13), ...
           model.irfs.modelINFO(:,14), ...
           model.irfs.modelINFO(:,1)];

% Figure 7
figs.f7 = [model.irfs.modelINFO(:,13), ...
           model.irfs.modelINFO_counterfactual(:,13)]; 

% Figure 8
figs.f8 = [model.irfs.modelINFO_difference(:,13), ...
           model.irfs.modelINFO_difference(:,14), ...
           model.irfs.modelINFO_difference(:,1)];
          

% Figure 9b (Note: You have to run "RUN.m" a second time (no information)
%                  to get the "no information" line)
figs.f9 = [4 .* [0; model.irfs.modelINFO(2:end,13) - model.irfs.modelINFO(1:end-1,13)]]; 


%plot(1:41, figs.f3)
