function [temp1] = datasetnonGDPmoments(data)

% Step 1 - Obtain first PC
temp1 = data.dd1;
S = [temp1.S1 temp1.S2 temp1.S3 temp1.S4 temp1.S5];
[~, path] = pca(zscore(S(temp1.FOMCused == 1, : )));
path = path(:,1);

% Step 2 - Rescale PC on DNY1
templm = fitlm(path, temp1.DNY1(temp1.FOMCused == 1, : ));
path = templm.Coefficients{2,1} * path;

% Step 3 - Extrapolate path outside of FOMC meetings
templm = fitlm(S(temp1.FOMCused == 1, : ), path);
temp1.path = [ones(length(S),1) S] * templm.Coefficients{:,1};
clearvars templm S path

end