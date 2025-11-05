%function plot_y(data)
% PURPOSE: plot all variables in the structure 'data'
whichplots = [0 1];
if isfield(data,'totransf')
    totransf = data.totransf;
else
    totransf = logical(zeros(1,size(data.y,2)));
end

[T,N] = size(data.y);
tt = data.time;
ytoplot = data.y;
ytoplot(5:end,totransf) = ytoplot(5:end,totransf) - ytoplot(1:end-4,totransf); ytoplot(1:4,totransf) = NaN;


if whichplots(1)
    for n = 1:N
        figure()
        plot(tt, ytoplot(:,n))
        title(data.names(n), 'Interpreter', 'none')
        axis tight
    end
end

if whichplots(2)
    n1 = ceil(sqrt(N)); n2 = n1;
    %n1 = 6; n2 = 2;
    scnsize = get(0,'ScreenSize');
    plot_position = [0.15*scnsize(3),0.06*scnsize(4),0.7*scnsize(3),1.2*scnsize(4)];
    figure('Position', plot_position)
    for n = 1:N
        subplot(n1,n2,n);
        plot(tt, ytoplot(:,n))
        tit = data.names{n}; if totransf(n), tit = [tit ' (yoy)']; end
        title(tit, 'Interpreter', 'none', 'FontSize', 8)
        axis tight
    end
end
