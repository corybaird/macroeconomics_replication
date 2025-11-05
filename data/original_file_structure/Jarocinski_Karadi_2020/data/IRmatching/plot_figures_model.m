function plot_figures_model(ObjFuncParams,M)
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
        eval(['subplot(NRow,NColumn,ii); hold on; plot(1:irfLen,100*irf1(1:irfLen,ii)'',''k'',''LineWidth'',' num2str(lineWid) '); xlim([1 ' num2str(irfLen) ']); title(''' varsCellNames{ii,1} ''',''FontWeight'',''Normal'',''FontSize'',10); set(gcf, ''Color'', ''w''); ']); %''Color'',[0.,0.6,1]
        set(gca,'YGrid','off','XGrid','on','layer','top');
        grid
        if ii==1 
            eval([legend_str]);
        end;
        %if ((ii-1)/NColumn)==floor((ii-1)/NColumn)  %first row
        %    ylabel('%\Delta from ss');
        %end;
        if ceil(ii/NColumn)==NRow   %last row
            xlabel('Quarters');
        end;
    end;
end;
