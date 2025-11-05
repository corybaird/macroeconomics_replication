function analysis = modelIRFs(par,mpe,varargin)

% Function that computes the IRFs of the model the parameters that are
% given by the input. It also computes the IRFs implied by the
% counterfactual model and the difference between the original IRFs and the
% counterfactual ones.
%
% The parameter policy is passed on to the model code to solve it with the
% alternative MP in which there is no natural rate of interest.
% Policy takes value 1 for default optimal MP and value 2 for alternative
% MP.
%
% Required Arguments:
% par              "global" like structure containing parameters
% mpe              structure containing moment estimates and the results
%                  from the estimation routine.
%
% Optional Arguments:
% 'parameters'     must be a 1 x 5 vector of custom parameter values 
%                  (default is to use the estimated parameters provided 
%                  within mpe)
% 'monetarypolicy' must be either 'optimal' (default), or 'alternative'


% Parse variable inputs
parsedInputs = inputParser;

defaultParameters = mpe.parameter;
checkParameters = @(x) and(isvector(x),size(x,2)==5);

defaultMonetaryPolicy = 'optimal';
validMonetaryPolicy = {'optimal','alternative'};
checkMonetaryPolicy = @(x) any(validatestring(x,validMonetaryPolicy));

addRequired(parsedInputs,'par',@isstruct);
addRequired(parsedInputs,'mpe',@isstruct);
addParameter(parsedInputs,'parameters',defaultParameters,checkParameters)
addParameter(parsedInputs,'monetarypolicy',defaultMonetaryPolicy,checkMonetaryPolicy)

parse(parsedInputs,par,mpe,varargin{:})
parameter = parsedInputs.Results.parameters;
policy = parsedInputs.Results.monetarypolicy;


% IRFs for baseline model
% Solve model and compute IRFs for 100bp shock (default)
[G1,impact]   = modelINFO(parameter,par);
irf = VarImpulse(G1,impact,1,par.figures.TT);

% Rescale to look at 25 bp shock
analysis.modelINFO = irf/4;

             
% IRFs for counterfactual model
% Solve model and compute IRFs using the natural rate of output from
% previous model.
[G1c,impactc]   = modelINFOcounterfactual(parameter,par,'monetarypolicy',policy);
shocks = [zeros(par.figures.TT,1), (irf(2:end,25) - irf(1:end-1,25))];
irf_counterfactual = VarResponse(G1c,impactc,shocks',par.figures.TT);

% Select only overlapping variables between modelINFO and modelINFO_count.
% irf_counterfactual = irf_counterfactual(:,1:23);

% Rescaling to look at 25 bp shock
analysis.modelINFO_counterfactual = irf_counterfactual/4;

% IRFs as difference
analysis.modelINFO_difference = (irf - irf_counterfactual)/4;

% Report Stock Price Impact Response
% Recall [19] is the stock price in modelINFO and modelINFOcounterfactual.
analysis.stockpriceimpact = analysis.modelINFO(2,19);

end