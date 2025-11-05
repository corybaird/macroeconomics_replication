function plot_figures_VAR(ObjFuncParams,M)
%Plotting figures

v2struct(ObjFuncParams);

%Plots
NRow  =   5;
NColumn = 1;
lineWid = 1.5;
irfLen = size(irf1,1);
%Legend
legend_str = ''; %;['legend(''' models_cell{1} '''); '];     

%Load the impulse responses
NVars  =   size(varsCell,1);
NVarsExo = size(varsExoCell,1);

%Calculating the number of plots necessary for each exogenous shock
NPlot     =   ceil(NVars/(NRow*NColumn));

%Create plots for each shocks
for jj=1:NVarsExo
    jjFig = M+(jj-1)*NPlot;
    figure(jjFig);   %Opening a figure
    for ii=1:NVars
        eval(['subplot(NRow,NColumn,ii); fill([1:irfLen flip(1:irfLen)],[100*irf2High(1:irfLen,ii)'' flip(100*irf2Low(1:irfLen,ii)'')],[0.7,0.8,1],''EdgeColor'',''none''); xlim([1 ' num2str(irfLen) ']); ylim(rangePlot(:,ii)''); hold off;']);      
        eval(['subplot(NRow,NColumn,ii); hold on; plot(1:irfLen,100*irf2(1:irfLen,ii)'',''b--'',''LineWidth'',' num2str(lineWid) '); xlim([1 ' num2str(irfLen) ']); hold off;']);
        if ((ii-1)/NColumn)==floor((ii-1)/NColumn)  %first row
            %ylabel('%\Delta');
        end;
    end;
end;
