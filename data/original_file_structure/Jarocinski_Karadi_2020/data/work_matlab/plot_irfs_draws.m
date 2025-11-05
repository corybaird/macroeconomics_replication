function handles = plot_irfs_draws(irfs_draws, varstoplot, shockstoplot, ...
    ynames_plot, ynames_table, shocknames, schemename, qtoplot, whichplots, ...
    fname, ylimits, transf, irfs1, varstoplot1, shockstoplot1)
% PURPOSE: plots impulse responses
% transf - N x 2 matrix, first col: order of differencing, 2nd col: scaling
% SUBFUNCTION: subplotnumber
handles = [];
if isempty(shockstoplot) || isempty(varstoplot), return, end
if nargin < 15, shockstoplot1 = shockstoplot; end
if nargin < 14, varstoplot1 = varstoplot; end
if nargin < 13, irfs1 = []; end
if nargin < 12, transf = []; end
if nargin < 11, ylimits = []; end
if nargin < 10, fname = []; end

[N,N2,nstep,n_draws] = size(irfs_draws);
tt = (0:nstep-1)';
if isempty(shocknames), shocknames = ynames_table; end
if isempty(transf), transf = nan(N,2); end

scnsize = get(0,'ScreenSize');
if N<5
    plot_position = get(0,'defaultfigureposition');
else
    plot_position = [0.35*scnsize(3),0.05*scnsize(4),0.85*scnsize(4),0.8*scnsize(4)];
end

% we want qtoplot to contain: [median narrow1 narrow2 wide1 wide2]
if length(qtoplot)==2 || length(qtoplot)==4
    qtoplot = [NaN; qtoplot(:)]';
end
if length(qtoplot)==1 || length(qtoplot)==3
    qtoplot = [qtoplot(:); nan(5-length(qtoplot),1)]';
end


% for each shock of interest: one plot with responses of all variables of interest
if whichplots(1)
    if length(varstoplot)<9, ncol = 2; else ncol = 3; end
    for is = 1:length(shockstoplot)
        s = shockstoplot(is);
        hf = figure('Position', plot_position);
        for iv = 1:length(varstoplot);
            v = varstoplot(iv);
            subplot(ceil(length(varstoplot)/ncol),ncol,iv);
            toplot = squeeze(quantile(irfs_draws(v,s,:,:),qtoplot,4))*whichplots(1);
            hold on
            fill([tt' flipud(tt)'], [toplot(:,4)' flipud(toplot(:,5))'], [0.7 0.8 1], 'EdgeColor', 'none')
            fill([tt' flipud(tt)'], [toplot(:,2)' flipud(toplot(:,3))'], [0.5 0.6 1], 'EdgeColor', 'none')
            plot(tt,zeros(1,nstep),'-k');
            plot(tt,toplot(:,1)','-k','LineWidth',2)
            title([schemename ':' shocknames{s} '->' ynames_table{v}],'Interpreter','none');
            axis tight
            % save irf data to csv
            %csvwrite(['out/irf-' ynames{v} '-' ynames{s} '-' schemename '.csv'],[tt' toplot]);
            if ~isempty(fname) % save irf data to Excel
                xlswrite([fname shocknames{s} '.xlsx'], [tt' toplot], ynames_table{v}, 'A2');
            end
        end
        handles = [handles hf];
    end
end

% for each shock of interest: one plot for each variable of interest
if whichplots(2)
    for is = 1:length(shockstoplot)
        s = shockstoplot(is);
        for iv = 1:length(varstoplot);
            hf = figure();
            v = varstoplot(iv);
            toplot = squeeze(quantile(irfs_draws(v,s,:,:),qtoplot,4))*whichplots(2);
            hold on
            fill([tt' flipud(tt)'], [toplot(:,4)' flipud(toplot(:,5))'], [0.7 0.8 1], 'EdgeColor', 'none')
            fill([tt' flipud(tt)'], [toplot(:,2)' flipud(toplot(:,3))'], [0.5 0.6 1], 'EdgeColor', 'none')
            plot(tt,toplot(:,1)','-k',tt,zeros(1,nstep),'-k');
            if ~isempty(nicenames)
                title(nicenames{iv});
            else
                title([schemename ':' char(ynames_table(s)) '->' char(ynames(v))],'Interpreter','none');
            end
            axis tight
            handles = [handles hf];
            % save irf data
            %csvwrite(['out/irf-' ynames_table{v} '-' ynames{s} '-' schemename '.csv'],[tt' toplot]);
        end
    end
end

% plot irfs to selected shocks
if whichplots(3)
    Nv = length(varstoplot);
    Ns = length(shockstoplot);
    hf = figure('Units','centimeters','Position',[2,1,Ns*5,Nv*3]);
    for iv = 1:Nv
        v = varstoplot(iv);
        irfs_draws_v = permute(irfs_draws(v,:,:,:),[3 2 4 1]);
        if ~isnan(transf(v,1))
            d = min(transf(v,1),nstep);
            temp = cat(1, zeros(d,N,n_draws), irfs_draws_v(1:end-d,:,:));
            irfs_draws_v = irfs_draws_v - temp;
        end
        if ~isnan(transf(v,2)), irfs_draws_v = irfs_draws_v*transf(v,2); end
        for is = 1:Ns
            s = shockstoplot(is);
            subplot(Nv,Ns,(iv-1)*Ns+is);
            toplot = squeeze(quantile(irfs_draws_v(:,s,:),qtoplot,3))*whichplots(3);
            hold on
            fill([tt' flipud(tt)'], [toplot(:,4)' flipud(toplot(:,5))'], [0.7 0.8 1], 'EdgeColor', 'none')
            fill([tt' flipud(tt)'], [toplot(:,2)' flipud(toplot(:,3))'], [0.5 0.6 1], 'EdgeColor', 'none')
            plot(tt,toplot(:,1)','-k')
            if ~isempty(irfs1)
                v1 = varstoplot1(iv);
                s1 = shockstoplot1(is);
                plot(tt, squeeze(irfs1(v1,s1,:))', ':k','LineWidth',1)
            end
            plot(tt,zeros(1,nstep),'-k','LineWidth',2);
            axis tight
            if ~isempty(ylimits), if ~isnan(sum(ylimits(v,:),2)), ylim(ylimits(v,:)); end, end
            %if iv==1, title(shocknames{s},'Interpreter','none'), end
            if is==1, ylabel(strrep(ynames_plot{v},'_',' ')), end
            %if iv<Nv, set(gca, 'XTickLabel', []); else xlabel('months'); end
            %if s>1, set(gca, 'YTickLabel', []); end
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
            if squeeze(irfs_draws(varstoplot(iv),shockstoplot(is),1:2,1))==[0;0], ylims(is,:) = 0; end
        end
        set(AX, 'YLim', [min(ylims(:,1)) max(ylims(:,2))])
    end
    end
    handles = [handles hf];
end

if ~isempty(fname) % save irf data to Excel, one file per shock
    Nv = length(varstoplot);
    Ns = length(shockstoplot);
    for is = 1:Ns
        s = shockstoplot(is);
        xlsfname = [fname ' shock ' shocknames{s} '.xlsx'];
        for iv = 1:Nv
            v = varstoplot(iv);
            toplot = squeeze(quantile(irfs_draws(v,s,:,:),qtoplot,4));
            xlswrite(xlsfname, [tt toplot], ynames_table{v}, 'A2');
            xlswrite(xlsfname, [{'horizon'} strseq('pct',qtoplot)'], ynames_table{v}, 'A1');
        end
    end
end
end

function sn = subplotnumber(R, C, r, c)
% PURPOSE: Compute the number of the subplot which is at position (r,c).
% Matlab 'subplot' command requires the number of the subplot, counting
% subplots by row. This function computes that number. The intended usage
% is: subplot(R, C, subplotnumber(R, C, r, c))
% INPUTS: R, C - total number of Rows and Columns
%         r, c - row and column position of the subplot
% RETURN: sn - subplot number
X = zeros(R,C);
X(r,c) = 1;
sn = find(X');
end
