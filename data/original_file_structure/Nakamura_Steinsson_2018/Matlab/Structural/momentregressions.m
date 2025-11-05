function [mpe] = momentregressions(par,temp1,temp2)

mpe = struct;

% Estimate Moments
% for ii = 1:length(noinfl)
for ii = 1:length(par.allVar)
    
   % Check whether it is a GDP Moment
   if ismember(par.allVar{ii},par.allVar_GDP)
       lm = fitlm(temp2.path(temp2.FOMCused == 1),eval(['temp2.' par.allVar{ii} '(temp2.FOMCused == 1)']));
       eval(['mpe.' par.allVar{ii} ' = lm.Coefficients{2,1};']);
       eval(['mpe.SD_' par.allVar{ii} ' = lm.Coefficients{2,2};']);
       
   % Check whether sample is restricted to after 2004    
   elseif ismember(par.allVar{ii},par.after2004) | ismember(par.allVar{ii},par.allVar_infl)
       lm = fitlm(temp1.path(temp1.FOMCused == 1 & temp1.year > 2003),...
                  eval(['temp1.' par.allVar{ii} ...
                        '(temp1.FOMCused == 1 & temp1.year > 2003)']));
       eval(['mpe.' par.allVar{ii} ' = lm.Coefficients{2,1};']);
       eval(['mpe.SD_' par.allVar{ii} ' = lm.Coefficients{2,2};']);
   
   % Check whether it is an inflation moment (drop 2004 and earlier)
%   elseif ismember(par.allVar{ii},par.allVar_infl)
%       lm = fitlm(temp1.path(temp1.FOMCused == 1 & ...
%                             temp1.year > 2004 & ...
%                             datenum(temp1.year,...
%                                     temp1.month,...
%                                     temp1.day) < datenum(2012,11,14)),...
%                  eval(['temp1.' par.allVar{ii} ...
%                        '(temp1.FOMCused == 1 & temp1.year > 2004 '...
%                         ' & datenum(temp1.year, temp1.month,temp1.day)'...
%                         ' < datenum(2012,11,14))']));
%       eval(['mpe.' par.allVar{ii} ' = lm.Coefficients{2,1};']);
%       eval(['mpe.SD_' par.allVar{ii} ' = lm.Coefficients{2,2};']);
%       
   % Otherwise run standard estimation
   else
       lm = fitlm(temp1.path(temp1.FOMCused == 1),...
               eval(['temp1.' par.allVar{ii} '(temp1.FOMCused == 1)']));
       eval(['mpe.' par.allVar{ii} ' = lm.Coefficients{2,1};']);
       eval(['mpe.SD_' par.allVar{ii} ' = lm.Coefficients{2,2};']);
   end
end

end
