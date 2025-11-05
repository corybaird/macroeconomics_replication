function newData = stratBoot(origData, stratVar)

NN = size(origData,1); % number of observations in original data
newData = zeros(size(origData));

stratValues = unique(stratVar);
Nstrat = length(stratValues);

kk = 0;
for ii = 1:Nstrat
    NTemp = sum(stratVar == stratValues(ii));
    DataTemp = origData(stratVar == stratValues(ii),:);
    Draws = ceil(NTemp*rand(NTemp,1));
    newData((kk+1):(kk+NTemp),:) = DataTemp(Draws,:);
    kk = kk + NTemp;
end

end