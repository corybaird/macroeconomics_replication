function T = dynamic_g1_tt(T, y, x, params, steady_state, it_)
% function T = dynamic_g1_tt(T, y, x, params, steady_state, it_)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double  vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double  vector of endogenous variables in the order stored
%                                                    in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double  matrix of exogenous variables (in declaration order)
%                                                    for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double  vector of steady state values
%   params        [M_.param_nbr by 1]        double  vector of parameter values in declaration order
%   it_           scalar                     double  time period for exogenous variables for which
%                                                    to evaluate the model
%
% Output:
%   T           [#temp variables by 1]       double  vector of temporary terms
%

assert(length(T) >= 303);

T = cmr.dynamic_resid_tt(T, y, x, params, steady_state, it_);

T(224) = (-1);
T(225) = (-(y(265)*(-T(56))/(T(57)*T(57))/params(25)));
T(226) = (-(y(265)*1/T(57)/params(25)));
T(227) = getPowerDeriv(y(256)*T(11),1-params(4),1);
T(228) = getPowerDeriv(y(256)*T(11),1+params(47),1);
T(229) = getPowerDeriv(T(11)*y(265)*params(69)*y(256)/(y(296)*y(6)),1-params(4),1);
T(230) = T(27)*T(26)*(-(params(69)*y(265)*y(301)*y(258)))/(y(5)*y(5))+T(28)*(-T(26))*(-(params(69)*y(265)*y(301)*y(258)))/(y(5)*y(5));
T(231) = T(27)*T(26)*params(69)*y(265)*y(301)/y(5)+T(28)*(-T(26))*params(69)*y(265)*y(301)/y(5);
T(232) = 2*params(69)*y(601)*y(610)*y(598)/y(258);
T(233) = getPowerDeriv(y(296)*y(6)/(y(265)*params(69)),params(4),1);
T(234) = T(9)*T(12)*y(250)*y(296)/(y(265)*params(69))*T(233);
T(235) = 1/((1-y(262))*(1-y(262)));
T(236) = T(70)*((1-y(262))*(-(params(71)*T(68)*T(235)*log(T(67))))/(1-params(71))/T(69)-log(T(69)));
T(237) = (y(250)*T(10)*T(12)-y(269))*T(9)*(y(262)-1-y(262))/((y(262)-1)*(y(262)-1))*log(y(274));
T(238) = T(9)*T(12)*y(250)*T(233)*(-(y(296)*y(6)*params(69)))/(y(265)*params(69)*y(265)*params(69));
T(239) = T(84)*getPowerDeriv(y(265),params(19),1)+T(25)*T(22)*(-(T(21)*y(270)*y(298)/y(28)))/(T(18)*T(18));
T(240) = getPowerDeriv(T(85),T(24),1);
T(241) = (-(params(72)*T(239)*T(240)))/(1-params(72));
T(242) = getPowerDeriv(T(86),1-params(22)*(1+params(47)),1);
T(243) = getPowerDeriv(T(86),params(22),1);
T(244) = getPowerDeriv(y(29)*T(85),T(39),1);
T(245) = getPowerDeriv(T(102),1/T(39),1);
T(246) = T(27)*T(26)*y(258)*params(69)*y(301)/y(5)+T(28)*(-T(26))*y(258)*params(69)*y(301)/y(5);
T(247) = 1/params(25)/(y(265)/params(25));
T(248) = getPowerDeriv(1/T(17),T(39),1);
T(249) = T(22)*T(16)/T(17)*getPowerDeriv(y(601),params(19),1)+T(23)*T(22)*(-(T(16)*y(603)*y(608)/y(298)))/(T(17)*T(17));
T(250) = getPowerDeriv(T(79),T(24),1);
T(251) = getPowerDeriv(T(80),1-params(22)*(1+params(47)),1);
T(252) = getPowerDeriv(T(79),params(22)*(1+params(47))/(1-params(22)),1);
T(253) = 1/y(268)/y(18);
T(254) = exp((-((T(5)-y(18))*(T(5)-y(18))))/2)/2.506628274631;
T(255) = T(253)*T(254);
T(256) = exp((-(T(5)*T(5)))/2)/2.506628274631;
T(257) = T(71)+y(268)*(-(T(253)*T(256)));
T(258) = exp((-((T(5)-2*y(18))*(T(5)-2*y(18))))/2)/2.506628274631;
T(259) = 1/y(602)/y(283);
T(260) = exp((-((T(33)-y(283))*(T(33)-y(283))))/2)/2.506628274631;
T(261) = T(259)*T(260);
T(262) = exp((-(T(33)*T(33)))/2)/2.506628274631;
T(263) = (-(T(259)*T(262)));
T(264) = T(261)+T(89)+y(602)*T(263);
T(265) = T(1)*getPowerDeriv(y(11),1-params(18),1)/y(270);
T(266) = getPowerDeriv(T(67),1/(1-y(262)),1);
T(267) = getPowerDeriv(T(69),1-y(262),1);
T(268) = getPowerDeriv(T(70),T(36),1);
T(269) = getPowerDeriv(y(13)*T(67),T(36),1);
T(270) = getPowerDeriv(T(93),(1-y(262))/y(262),1);
T(271) = T(25)*T(22)*T(19)*getPowerDeriv(y(11),1-params(20),1)/T(18);
T(272) = (-(params(72)*T(240)*T(271)))/(1-params(72));
T(273) = T(267)*(-(params(71)*T(266)*(-T(3))/(y(270)*y(270))))/(1-params(71));
T(274) = T(6)*getPowerDeriv(y(270),1-params(18),1)/y(603);
T(275) = getPowerDeriv(T(75),1/(1-y(599)),1);
T(276) = T(274)*T(275);
T(277) = getPowerDeriv(T(77),1-y(599),1);
T(278) = getPowerDeriv(T(75),y(599)/(1-y(599)),1);
T(279) = T(14)*getPowerDeriv(y(270),1-params(20),1);
T(280) = getPowerDeriv(T(16),T(24),1);
T(281) = T(25)*T(22)*(-(T(21)*y(265)*y(298)/y(28)))/(T(18)*T(18));
T(282) = (-(params(72)*T(240)*T(281)))/(1-params(72));
T(283) = T(23)*T(22)*(-(T(16)*y(601)*y(608)/y(298)))/(T(17)*T(17));
T(284) = T(2)*getPowerDeriv(y(272),params(18),1)/y(270);
T(285) = T(25)*T(22)*T(20)*getPowerDeriv(y(272),params(20),1)/T(18);
T(286) = (-(params(72)*T(240)*T(285)))/(1-params(72));
T(287) = T(7)*getPowerDeriv(y(604),params(18),1)/y(603);
T(288) = T(275)*T(287);
T(289) = T(15)*getPowerDeriv(y(604),params(20),1);
T(290) = (y(250)*T(10)*T(12)-y(269))*getPowerDeriv(y(274),y(262)/(y(262)-1),1);
T(291) = (y(18)*y(18)-(log(y(268))+T(4)/2))/(y(18)*y(18));
T(292) = (y(283)*y(283)-T(32))/(y(283)*y(283));
T(293) = (-(T(262)*T(292)));
T(294) = T(9)*T(12)*y(250)*T(233)*y(6)/(y(265)*params(69));
T(295) = T(25)*T(22)*(-(T(21)*(-(y(270)*y(265)*y(298)))/(y(28)*y(28))))/(T(18)*T(18));
T(296) = (-(params(72)*T(240)*T(295)))/(1-params(72));
T(297) = T(25)*T(22)*(-(T(21)*y(270)*y(265)/y(28)))/(T(18)*T(18));
T(298) = (-(params(72)*T(240)*T(297)))/(1-params(72));
T(299) = T(23)*T(22)*(-(T(16)*(-(y(603)*y(601)*y(608)))/(y(298)*y(298))))/(T(17)*T(17));
T(300) = T(23)*T(22)*(-(T(16)*y(603)*y(601)/y(298)))/(T(17)*T(17));
T(301) = getPowerDeriv(y(299),params(22)/(params(22)-1),1);
T(302) = T(9)*y(250)*T(10)*T(227)*y(256)*T(301);
T(303) = T(27)*T(26)*y(265)*params(69)*y(258)/y(5)+T(28)*(-T(26))*y(265)*params(69)*y(258)/y(5);

end
