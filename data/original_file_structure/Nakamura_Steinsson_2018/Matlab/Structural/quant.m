function [Q]=quant(vector)
%% quant
Q=[quantile(vector,0.025), quantile(vector,0.10), quantile(vector,0.25), quantile(vector,0.75), quantile(vector,0.90), quantile(vector,0.975)];
end
    


