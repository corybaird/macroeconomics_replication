function mpe = momentestimation(par,data)

% Performs estimation of empirical moments for Interest Rates, Stocks, and
% GDP data from BlueChip. Dataset arrays in dd and ddGDP must contain
% the appropriate independent variables (path)!

%% Part 1 - Construct News Shock Measure

% 1.1 PCA on baseline sample after 2000
% Prepare dataset for all moments except GDP moments. Computes path factor
% as first principle component of 5 interest rates, and rescales it on the
% nominal yield at 1 year maturity. 
% NOTE: The path factor is computed only on FOMC meeting days and it is 
%       then extrapolated to non-FOMC days.

temp1 = datasetnonGDPmoments(data);

% 1.2 Construct Monthly News Measure (use sample after 1995)
% Note: this is conservative measure that takes out days 1-7 of each month.
% Note: the monthly shock measure is the sum of FOMC only days!!!

temp2 = datasetGDPmoments(data);


%% Part 2 - Compute Moments
% OLS regressions of outcome variables on the path factor

mpe = momentregressions(par,temp1,temp2);

end
