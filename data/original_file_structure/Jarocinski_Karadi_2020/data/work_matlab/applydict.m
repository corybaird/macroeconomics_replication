function outarray = applydict(inarray, mydict)
% PURPOSE: In 'inarray' substitute all entries found in mydict.
% INPUTS:
% inarray - array of N strings
% mydict - ? by 2 array of key, value pairs
% OUTPUT:  
% outarray - copy of inarray where each string that was a key in mydict is
%            substituted with the corresponding value
outarray = inarray;
for n = 1:length(outarray)
    i = find(strcmp(outarray(n),mydict(:,1)));
    if ~isempty(i)
        outarray(n) = mydict(i,2);
    end
end