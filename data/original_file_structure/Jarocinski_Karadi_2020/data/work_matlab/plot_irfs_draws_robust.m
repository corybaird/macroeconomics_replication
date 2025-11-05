function handles = plot_irfs_draws_robust(irfs_draws, irfs_l_draws, irfs_u_draws, ...
    varstoplot, shockstoplot, ynames, shocknames, credibility, whichplots, fname)
% PURPOSE: plot robustified impulse response bands of Giacomini, Kitagawa (2015)
% SUBFUNCTION: make_robust_irfbands
handles = [];
if isempty(shockstoplot) || isempty(varstoplot), return, end
if isempty(shocknames), shocknames = ynames; end

nstep = size(irfs_draws,3);
tt = (0:nstep-1)';

% plot irfs to selected shocks
if whichplots(3)
    Nv = length(varstoplot);
    Ns = length(shockstoplot);
    hf = figure('Units','centimeters','Position',[2,2,Ns*5,Nv*3]);
    for iv = 1:Nv
        v = varstoplot(iv);
        for is = 1:Ns
            s = shockstoplot(is);
            subplot(Nv,Ns,(iv-1)*Ns+is);
            toplot0 = squeeze(median(irfs_draws(v,s,:,:),4));
            toplot1 = make_robust_irfbands(v,s,irfs_l_draws,irfs_u_draws,credibility(1));
            toplot2 = make_robust_irfbands(v,s,irfs_l_draws,irfs_u_draws,credibility(2));
            toplot = [toplot0 toplot1(:,3:4) toplot2(:,3:4)]*whichplots(3);
            hold on
            fill([tt' flipud(tt)'], [toplot(:,4)' flipud(toplot(:,5))'], [0.7 0.8 1], 'EdgeColor', 'none')
            fill([tt' flipud(tt)'], [toplot(:,2)' flipud(toplot(:,3))'], [0.5 0.6 1], 'EdgeColor', 'none')
            %plot(tt,toplot2(:,5)','-k'), plot(tt,toplot2(:,6)','-k')
            plot(tt,toplot1(:,1)','-k'), plot(tt,toplot1(:,2)','-k')
            %plot(tt,toplot(:,1)','-k')
            plot(tt,zeros(1,nstep),'-k','LineWidth',2);
            axis tight
            %if iv==1, title(shocknames{s},'Interpreter','none'), end
            if is==1, ylabel(strrep(ynames{v},'_',' ')), end
            %if iv<Nv, set(gca, 'XTickLabel', []); else xlabel('months'); end
            %if s>1, set(gca, 'YTickLabel', []); end
            
            % print out
            if whichplots(1)
                disp(['robust bands for impact response of ' strrep(ynames{v},'\newline',' ') ' to ' shocknames{s}])
                info.cnames = strvcat('median',sprintf('%4.2f:l',credibility(1)),sprintf('%4.2f:u',credibility(1)),sprintf('%4.2f:l',credibility(2)),sprintf('%4.2f:u',credibility(2)));
                mprint(toplot(1,:),info)
            end
        end
    end
    
    if 1
    % align y axes in each row
    for iv = 1:Nv
        AX = nan(1,Ns);
        ylims = nan(Ns,2);
        for is = 1:Ns
            AX(is) = subplot(Nv,Ns,(iv-1)*Ns+is);
            ylims(is,:) = get(AX(is),'YLim');
            % ignore ylim when irf=0 at all horizons (it would be -1,1)
            if squeeze(irfs_l_draws(varstoplot(iv),shockstoplot(is),1:2,1))==[0;0], ylims(is,:) = 0; end
        end
        set(AX, 'YLim', [min(ylims(:,1)) max(ylims(:,2))])
    end
    end
    handles = [handles hf];
end
end

function toplot = make_robust_irfbands(v,s,irfs_l_draws,irfs_u_draws,credibility)
% PURPOSE: construct 

% posterior mean bounds with multiple priors
toplot1 = [squeeze(mean(irfs_l_draws(v,s,:,:),4)) squeeze(mean(irfs_u_draws(v,s,:,:),4))];

% bands how I would compute them
toplot2 = [squeeze(quantile(irfs_l_draws(v,s,:,:),0.5*(1-credibility),4)) ...
    squeeze(quantile(irfs_u_draws(v,s,:,:),1-0.5*(1-credibility),4))];

% bounds of the posterior robustified credible region
ndraws = size(irfs_l_draws,4);
nstep = size(irfs_l_draws,3);
nr = 100;
toplot3 = nan(nstep,2);
for h = 1:nstep
    r = linspace(min(irfs_l_draws(v,s,h,:),[],4), max(irfs_u_draws(v,s,h,:),[],4), nr);
    rr = repmat(r,ndraws,1);
    l = squeeze(irfs_l_draws(v,s,h,:));
    ll = repmat(l,1,nr);
    u = squeeze(irfs_u_draws(v,s,h,:));
    uu = repmat(u,1,nr);
    
    dd = max(abs(rr-ll),abs(rr-uu));
    zr = quantile(dd,credibility);
    [minzr, iminzr] = min(zr);
    toplot3(h,1) = r(iminzr) - minzr;
    toplot3(h,2) = r(iminzr) + minzr;
end

toplot = [toplot1 toplot2 toplot3];
end