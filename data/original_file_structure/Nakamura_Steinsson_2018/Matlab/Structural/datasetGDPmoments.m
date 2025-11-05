function [temp2] = datasetGDPmoments(data)

% Step 1 - Obtain first PC for sample after 1995

p = data.dd2(data.dd2.FOMCused == 1,:);
p.newdate = p.year * 12 + p.month + 1;
tempA = dataset2table(p);
q = data.ddGDP;
q.newdate = q.year * 12 + q.month;
tempB = dataset2table(q);
temp  = table2dataset(outerjoin(tempB,tempA,...
                                'Key','newdate',...
                                'MergeKeys',true));
temp.year_tempA = [];
temp.month_tempA = [];
temp.year = temp.year_tempB;
temp.month = temp.month_tempB;
temp.year_tempB = [];
temp.month_tempB = [];

S = [temp.S1 temp.S2 temp.S3 temp.S4 temp.S5]; % Collect variables
S_red = S(temp.FOMCused == 1, :);
S_red(isnan(S_red)) = 0;
[~, path] = pca(zscore(S_red));
path = path(:,1);

% Step 2 - Rescale PC on DNY1
templm = fitlm(path, temp.DNY1(temp.FOMCused == 1, : ));
path = templm.Coefficients{2,1} * path;

% Step 3 - Extrapolate path outside of FOMC meetings and kill it
templm = fitlm(S_red, path);
temp.path = [ones(length(S),1) S] * templm.Coefficients{:,1};
temp.path(temp.FOMCused ~= 1) = 0; % HOLES IN PATH MEASURE
temp.path(temp.day <= 7) = NaN;

% Realign sample with Stata
% temp.path(and(temp.year == 1995, temp.month == 1)) = NaN;
% temp.path(or(and(temp.year == 2008, temp.month >= 7),...
%              and(temp.year == 2009, temp.month <  7)),:) = NaN;
% temp.path(and(temp.year == 2014, temp.month == 4)) = 0;
% temp.path(and(temp.year == 2014, temp.month > 4)) = NaN;

temp.path(and(temp.year == 1995, temp.month <= 2)) = NaN;
temp.path(or(and(temp.year == 2008, temp.month > 7),...
             and(temp.year == 2009, temp.month < 7)),:) = NaN;
temp.path(and(temp.year == 2014, temp.month == 5)) = 0;
temp.path(and(temp.year == 2014, temp.month >= 5)) = NaN;

% Generate lagged path factor

% temp.path = [NaN; temp.path(1:end-1)]; 


temp2 = temp;

end
