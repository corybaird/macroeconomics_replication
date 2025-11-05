function figures_save(pathStr,extStr,modName,M)

for ii=M:M
    fig=figure(ii);
    set(fig,'Position', [100 100 200 800]);  %[100 100 700 350]       
    eval(['export_fig ''' pathStr 'fig_' modName extStr '.pdf'' -pdf;']);  % '_' num2str(ii)
end;
