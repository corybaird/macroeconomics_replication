function outarray = applydictregexp(inarray, mydict)
% PURPOSE: In 'inarray' substitute all entries found in mydict.
% INPUTS:
% inarray - array of N strings
% mydict - Nd by 2 array of key, value pairs
% OUTPUT:  
% outarray - copy of inarray where each string that was a key in mydict is
%            substituted with the corresponding value
outarray = inarray;

for n = 1:length(outarray)
    count = 0;
    for i = 1:size(mydict,1)
        startIndex = regexp(outarray{n},mydict{i,1});
        if ~isempty(startIndex)
            outarray(n) = mydict(i,2);
            count = count + 1;
        end
    end
    if count>1, error('multiple matches found!'), end
end