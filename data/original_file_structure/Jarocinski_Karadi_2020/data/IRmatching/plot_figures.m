function plot_figures(ObjFuncParams,M,TypeStr,FigureLine,plotID)
%Plotting figures

v2struct(ObjFuncParams);

%Plots
NRow  =   5;   %2;   %
NColumn = 1;   %3;   %
lineWid = 1;
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
        switch TypeStr
            case 'VAR'
                eval(['subplot(NRow,NColumn,ii); fill([1:irfLen flip(1:irfLen)],[100*irf2High2Sd(1:irfLen,ii)'' flip(100*irf2Low2Sd(1:irfLen,ii)'')],[0.7,0.8,1],''EdgeColor'',''none''); xlim([1 ' num2str(irfLen) ']); ylim(rangePlot(:,ii)''); hold off;']);      
                eval(['subplot(NRow,NColumn,ii); hold on; fill([1:irfLen flip(1:irfLen)],[100*irf2High1Sd(1:irfLen,ii)'' flip(100*irf2Low1Sd(1:irfLen,ii)'')],[0.5,0.6,1],''EdgeColor'',''none''); xlim([1 ' num2str(irfLen) ']); ylim(rangePlot(:,ii)''); hold off;']);      
                eval(['subplot(NRow,NColumn,ii); hold on; ' plotID '=plot(1:irfLen,100*irf2(1:irfLen,ii)'',''' FigureLine ''',''LineWidth'',' num2str(lineWid) '); xlim([1 ' num2str(irfLen) ']); hold off;']);
%                 if ii==1
%                 eval(['subplot(NRow,NColumn,ii); hold on; f=plot(1:irfLen,100*irf2(1:irfLen,ii)'',''' FigureLine ''',''LineWidth'',' num2str(lineWid) ',''DisplayName'',''' Legend '''); xlim([1 ' num2str(irfLen) ']); hold off;']);
%                 end;
            case 'Model'
                eval(['subplot(NRow,NColumn,ii); hold on; ' plotID '=plot(1:irfLen,100*irf1(1:irfLen,ii)'',''' FigureLine ''',''LineWidth'',' num2str(lineWid) '); xlim([1 ' num2str(irfLen) ']); title(''' varsCellNames{ii,1} ''',''FontWeight'',''Normal'',''FontSize'',10); set(gcf, ''Color'', ''w''); hold off;']); %''Color'',[0.,0.6,1]
                %eval(['subplot(NRow,NColumn,ii); hold on; plot(1:irfLen,100*irf2Low(1:irfLen,ii)'',''r--'',''LineWidth'',' num2str(lineWid) '); xlim([1 ' num2str(irfLen) ']); hold off;']);
                %eval(['subplot(NRow,NColumn,ii); hold on; plot(1:irfLen,100*irf2High(1:irfLen,ii)'',''r--'',''LineWidth'',' num2str(lineWid) '); xlim([1 ' num2str(irfLen) ']); hold off;']);
%                 if ii==1 
%                     eval(['subplot(NRow,NColumn,ii); hold on; g=plot(1:irfLen,100*irf1(1:irfLen,ii)'',''' FigureLine ''',''LineWidth'',' num2str(lineWid) ',''DisplayName'',''' Legend '''); xlim([1 ' num2str(irfLen) ']); title(''' varsCellNames{ii,1} ''',''FontWeight'',''Normal'',''FontSize'',10); set(gcf, ''Color'', ''w''); ']); %''Color'',[0.,0.6,1]
%                 end;
                %set(gca,'YGrid','off','XGrid','off','layer','top');
                %grid
                if ((ii-1)/NColumn)==floor((ii-1)/NColumn)  %first row
                    ylabel('Percent');
               end;
                if (ii+NColumn)>NVars %ceil(ii/NColumn)==floor(NVars/NColumn) %NRow   %last row
                    xlabel('Quarters');
                end;
            case 'ZeroLine'
                eval(['subplot(NRow,NColumn,ii); hold on; ' plotID '=plot(1:irfLen,zeros(1,irfLen),''' FigureLine ''',''LineWidth'',2); xlim([1 ' num2str(irfLen) ']);']);
        end;
    end;
end;
