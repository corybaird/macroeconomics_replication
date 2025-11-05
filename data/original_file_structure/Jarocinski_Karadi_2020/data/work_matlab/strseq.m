function strvec = strsec(str, indices)
% STRVEC = strseq(STR,INDICES) returns the string vector STRVEC obtained
% by appending the integer values INDICES to the string STR. For example,
%     strseq('e',[1 2 4])
% returns
%     {'e1';'e2';'e4'}
strvec = cell(length(indices),1);
for i = 1:length(indices)
    strvec{i} = [str num2str(indices(i))];
end