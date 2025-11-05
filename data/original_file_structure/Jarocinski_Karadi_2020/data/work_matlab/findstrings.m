function idx = findstrings(astr1, astr2)
% PURPOSE: Find the position of each string from astr1 (array of strings)
% in astr2 (another array of strings).
% INPUT:
% astr1 - array of strings to look for
% astr2 - array of strings in which we look
% OUTPUT:
% idx - vector of the same length as astr1, where
%       idx(i) contains the location of astr1(i) in astr2
% Marek Jarocinski, 2013-12-03

if ischar(astr1)
    astr1 = {astr1};
end

idx = nan(1,length(astr1));
for i = 1:length(astr1)
    %astr1{i}
    if isempty(find(strcmp(astr2, astr1{i})))
        error(['string ' astr1{i} ' not found'])
    else
        idx(i) = find(strcmp(astr2, astr1{i}));
    end
end
