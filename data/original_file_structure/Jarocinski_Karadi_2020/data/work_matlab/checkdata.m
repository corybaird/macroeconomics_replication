function dataout = checkdata(data, t2datestr, ignorecols)
% PURPOSE: Check data structure for missing data
% INPUTS:
% data.y - data matrix, T x N
% data.time - time vector, T x 1
% data.names - variable names, cell 1 x N
% ignorecols - indexes of columns to ignore
if nargin<3, 
    ignorecols = [];
end

N = length(data.names);
[T,N2] = size(data.y);
if N2~=N, error('data.names inconsistent with data.y'), end

ibegend = nan(N,3);
for n = 1:N
       ifirst = find(~isnan(data.y(:,n)),1,'first');
       ilast = find(~isnan(data.y(:,n)),1,'last');
       if isempty(ifirst), ifirst = 1; end
       if isempty(ilast), ilast = T; end
       nmid = sum(isnan(data.y(ifirst:ilast,n)));
       ibegend(n,:) = [ifirst ilast nmid];
       %fprintf(1,'%-18s %s-%s   #internal NaNs: %d\n', data.names{n}, t2datestr(data.time(ifirst)), t2datestr(data.time(ilast)), nmid);
end
disp([char(data.names) repmat(' ',N,1) t2datestr(data.time(ibegend(:,1))) repmat(' - ',N,1) t2datestr(data.time(ibegend(:,2))) repmat('   #internal NaNs: ',N,1) num2str(ibegend(:,3))])
% info.rnames = char([{' '} data.names]);
% info.cnames = char({'beg',' ','end',' ','#NaN'});
% info.fmt = char({'%4d','%2d','%4d','%2d','%3d'});
% table = [t2ym(data.time(ibegend(:,1))) t2ym(data.time(ibegend(:,2))) ibegend(:,3)];
% mprint(table,info)
ibegend(ignorecols,:) = [];
ifirst = max(ibegend(:,1));
ilast = min(ibegend(:,2));
if ifirst>1 || ilast<size(data.y,1)
    disp(' ')
    disp(['Truncating sample from: ' t2datestr(data.time(1)) '-' t2datestr(data.time(end))])
    disp(['         to new sample: ' t2datestr(data.time(ifirst)) '-' t2datestr(data.time(ilast))])
else
    disp(' ')
    disp('No need to truncate the sample')
end
dataout = data;
dataout.y = data.y(ifirst:ilast,:);
dataout.time = data.time(ifirst:ilast,:);
if isfield(data,'w'), dataout.w = data.w(ifirst:ilast,:); end
disp(['Number of observations: ' num2str(size(dataout.y,1)) ', number of variables: ' num2str(size(dataout.y,2))])
end