function savedata(filename, data, t2ym)
% PURPOSE: Save data structure to a csv
% INPUTS:
% filename - filename
% data.y - data matrix, T x N
% data.time - time vector, T x 1
% data.names - variable names, cell 1 x N
% t2ym - function for converting data.time into [year period] vector

N = length(data.names);
if size(data.y,2)~=N, error('data.names inconsistent with data.y'), end
if ~ischar(filename), error('FILENAME must be a string'); end
if ~iscellstr(data.names), error('data.names must be cell array of strings'); end

%turn the names into a single comma seperated string
header_string = 'year,period';
for i = 1:N
    header_string = [header_string,',',data.names{i}];
end

%write the string to a file
fid = fopen(filename,'w');
fprintf(fid,'%s\r\n',header_string);
fclose(fid);

% append the data to the file
m = [t2ym(data.time) data.y];
dlmwrite(filename, m,'-append','delimiter',','); 

end