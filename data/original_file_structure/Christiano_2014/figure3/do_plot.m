
if conf == 1
    lower_bound=rnw-1.96*B(2,1:end-1)';
    upper_bound=rnw+1.96*B(2,1:end-1)';
    hold on    
    confb   = [ttp'  lower_bound(ttp) ; ttm' upper_bound(ttm)];
    patch(nn(confb(:,1)),confb(:,2),[0.9 0.9 0.9],'edgecolor',[0.8 0.8 0.8]);
    if saving ~= 1
        plot(nn,rnwHP,'*-',nn,rnw_pert,'o-',nn,zeros(length(nn),1))
    else
        plot(nn,rnwHP,'*-',nn,zeros(length(nn),1))
    end
    hold off
else
    plot(nn,rnw,nn,rnwHP,'*-',nn,rnw+1.96*B(2,1:end-1)','--',nn,rnw-1.96*B(2,1:end-1)','--',nn,zeros(length(nn),1))
end