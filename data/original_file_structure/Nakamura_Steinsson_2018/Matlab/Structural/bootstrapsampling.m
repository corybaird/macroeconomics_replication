function [newData] = bootstrapsampling(origData)

% Function that performs stratified sampling of the datasets used to
% compute both GDP moments (at a monthly frequency) and inflation/interest
% rates/stock price moments.


% Step 1
% Leave unchanged the daily/tick data to be used for the creation of the
% dataset to be used for computation of GDP moments. Recall that this
% dataset is not resampled because the resampled monthly dataset from Blue
% Chip is then used as a basis to merge FOMC meetings and compute the path
% factor.
newData.dd2 = origData.dd2;


% Step 2
% Create a resampled dataset of daily/tick observations to be used to
% compute all non-GDP moments.

stratvalues = unique(origData.dd1.stratum);
stratvar = origData.dd1.stratum;
origData.dd1.stratum = [];
varnames = origData.dd1.Properties.VarNames;
temp = table2array(dataset2table(origData.dd1));

tempnewdata = zeros(size(temp));

kk = 0;
for ii = 1:length(stratvalues)
    NTemp = sum(stratvar == stratvalues(ii));
    DataTemp = temp(stratvar == stratvalues(ii),:);
    Draws = ceil(NTemp*rand(NTemp,1));
    tempnewdata((kk+1):(kk+NTemp),:) = DataTemp(Draws,:);
    kk = kk + NTemp;
end

newData.dd1 = table2dataset(array2table(tempnewdata));
newData.dd1.Properties.VarNames = varnames;

% Step 3
% Create a resampled dataset of monthly observations to be used to compute
% GDP moments.

stratvalues = unique(origData.ddGDP.stratum);
stratvar = origData.ddGDP.stratum;
origData.ddGDP.stratum = [];
varnames = origData.ddGDP.Properties.VarNames;
temp = table2array(dataset2table(origData.ddGDP));

tempnewdata = zeros(size(temp));

kk = 0;
for ii = 1:length(stratvalues)
    NTemp = sum(stratvar == stratvalues(ii));
    DataTemp = temp(stratvar == stratvalues(ii),:);
    Draws = ceil(NTemp*rand(NTemp,1));
    tempnewdata((kk+1):(kk+NTemp),:) = DataTemp(Draws,:);
    kk = kk + NTemp;
end

newData.ddGDP = table2dataset(array2table(tempnewdata));
newData.ddGDP.Properties.VarNames = varnames;

end