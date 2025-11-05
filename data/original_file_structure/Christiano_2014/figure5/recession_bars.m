%What follows are NBER start and end dates of NBER recessions obtained from
%http://www.nber.org/cycles.html
recession_dates

ylimits=get(gca,'YLim'); %get axis 
 
%put nber recessions as bars
for iiii=1:1:size(NBER_recessions,1),

    %full grey area, without edges 
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9],'EdgeColor','none'); hold on
    
    %edges at bottom
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(1) ylimits(1) ylimits(1) ylimits(1)]',[0.9 0.9 0.9]); hold on
    
    %edges at top
    patch([NBER_recessions(iiii,1),NBER_recessions(iiii,2),NBER_recessions(iiii,2),NBER_recessions(iiii,1)]',...
        [ylimits(2) ylimits(2) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    
    
    %edges left if first recession date is equal to initial date 
    if NBER_recessions(1)<=xlimits(1) && iiii==1,
    patch([xlimits(1),xlimits(1),xlimits(1),xlimits(1)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    end
    
 
    
    %edges right if last recession date is equal to final date 
    if NBER_recessions(end)>=xlimits(2) && iiii==size(NBER_recessions,1),
    patch([xlimits(2),xlimits(2),xlimits(2),xlimits(2)]',...
        [ylimits(1) ylimits(1) ylimits(2) ylimits(2)]',[0.9 0.9 0.9]); hold on
    end
    
    
end


 