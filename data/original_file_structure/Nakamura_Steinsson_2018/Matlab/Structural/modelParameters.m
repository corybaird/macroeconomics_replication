function R = modelParameters(par,output)

% Routine that extracts the set of R used in each run of the
% program. These are subdivided in two subfields, namely calibrated and
% estimated R.
%
% NOTE: only the parametrization of the model brought to the data is
%       considered here. In other words, if a robustness check is made by
%       changing some parameters of the model (e.g., setting habits to
%       nil), then the set of reported parameters still reflects the ones
%       that were used in the estimation part of the routine !!!

R.calibrated.beta = par.calibration.beta;        % Subjective discount factor
R.calibrated.alpha = par.calibration.alpha;      % nominal rigidity
R.calibrated.omega = par.calibration.omega;      % el of marginal cost to output
R.calibrated.gamma = par.calibration.gamma;      % coeff on lagged inflation
R.calibrated.psiPi = par.calibration.psiPi;      % Endogenous feedback in Taylor rule
R.calibrated.inftarg = par.calibration.inftarg;  % Inflation target shock
R.calibrated.theta = par.calibration.theta;      % el of substitution across varieties
R.calibrated.sigma = par.calibration.sigma;      % Intertemporal el of substitution


if par.B_PSI_est == 1 || par.B_PSI_est == 3
    R.calibrated.b = par.x0(5);    % Habits parameter
end

if par.B_PSI_est == 3
    R.calibrated.PSI = par.x0(4);  % Information parameter

end


R.estimated.AR1 = output.parameter(1);
R.estimated.AR2 = output.parameter(2);
R.estimated.slopePC = output.parameter(3) * ...
                               ((1 - par.calibration.alpha) ...
                               * (1 - par.calibration.alpha ... 
                               * par.calibration.beta ) / ...
                               ( par.calibration.alpha * ...
                               ( 1 + par.calibration.omega * ...
                               par.calibration.theta ) ));


if par.B_PSI_est == 0 || par.B_PSI_est == 2
    R.estimated.b = output.parameter(5);   % Habits parameter
end

if par.B_PSI_est ~= 3
    R.estimated.PSI = output.parameter(4); % Information parameter
end

end