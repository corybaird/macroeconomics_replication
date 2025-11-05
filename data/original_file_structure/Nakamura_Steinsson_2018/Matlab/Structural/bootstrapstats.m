function statistics = bootstrapstats(distributions)

% Wrapper function that computes the bootstrapped statistics from the model
% Statistics include
% - Means
% - Standard Deviations (i.e., standard errors)
% - Quantiles


% Call functions defined below to compute the desired statistics
statistics.means = bootstrapmeans(distributions);
statistics.stdev = bootstrapstd(distributions);
statistics.quantiles = bootstrapquant(distributions);
% statistics.histograms = bootstraphist(distributions);


end


% Function to compute bootstrapped means
function means = bootstrapmeans(distributions)

% Get field names
categories = fieldnames(distributions);
subcategories = cell(length(categories));
for i = 1:length(categories)
    subcategories{i} = fieldnames(distributions.(categories{i}));
end

% Compute stats and allocate them to suitable structure
for i = 1:length(categories)
    for j = 1:length(subcategories{i})
        means.(categories{i}).(subcategories{i}{j}) ...
        = mean(distributions.(categories{i}).(subcategories{i}{j}),1);
    end
end

end

% Function to compute bootstrapped standard errors
function stdev = bootstrapstd(distributions)

% Get field names
categories = fieldnames(distributions);
subcategories = cell(length(categories));
for i = 1:length(categories)
    subcategories{i} = fieldnames(distributions.(categories{i}));
end

% Compute stats and allocate them to suitable structure
for i = 1:length(categories)
    for j = 1:length(subcategories{i})
        stdev.(categories{i}).(subcategories{i}{j}) ...
        = std(distributions.(categories{i}).(subcategories{i}{j}),1);
    end
end

end

% Function to compute bootstrapped quantiles
function quantiles = bootstrapquant(distributions)

% Get field names
categories = fieldnames(distributions);
subcategories = cell(length(categories));
for i = 1:length(categories)
    subcategories{i} = fieldnames(distributions.(categories{i}));
end

% Compute stats and allocate them to suitable structure
for i = 1:length(categories)
    for j = 1:length(subcategories{i})
        quantiles.(categories{i}).(subcategories{i}{j}) ...
        = quantile(distributions.(categories{i}).(subcategories{i}{j}),...
                   [.005 ,.01, .025, .05, .1, .25, .5 ,.75, .9, .95, .975, .99, .995],1);
    end
end

end

%{
% Function to compute bootstrapped distributions' histograms
function histog = bootstraphist(distributions)

% Suppress displaying histograms
set(0,'DefaultFigureVisible','off')

% Get field names
categories = fieldnames(distributions);
subcategories = cell(length(categories));
for i = 1:length(categories)
    subcategories{i} = fieldnames(distributions.(categories{i}));
end

% Compute stats and allocate them to suitable structure
for i = 1:length(categories)
    for j = 1:length(subcategories{i})
        histog.(categories{i}).(subcategories{i}{j}) ...
        = histogram(distributions.(categories{i}).(subcategories{i}{j}));
    end
end

% Restore default displaying option
set(0,'DefaultFigureVisible','on')

end

%}