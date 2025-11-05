function T = static_resid_tt(T, y, x, params)
% function T = static_resid_tt(T, y, x, params)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%
% Output:
%   T         [#temp variables by 1]  double   vector of temporary terms
%

assert(length(T) >= 141);

T(1) = y(26)^params(18);
T(2) = y(24)^(1-params(18));
T(3) = T(1)*T(2);
T(4) = T(3)/y(24);
T(5) = T(4)^(1/(1-y(16)));
T(6) = (1-params(71)*T(5))/(1-params(71));
T(7) = T(6)^(1-y(16));
T(8) = y(38)^2;
T(9) = (log(y(22))+T(8)/2)/y(38);
T(10) = normcdf(T(9)-y(38),0,1);
T(11) = 1-normcdf(T(9),0,1);
T(12) = T(10)+y(22)*T(11);
T(13) = y(22)*T(11)+T(10)*(1-params(23));
T(14) = y(28)^(y(16)/(y(16)-1));
T(15) = (y(51)*y(15)/(y(19)*params(69)))^params(4);
T(16) = y(54)^(params(22)/(params(22)-1));
T(17) = (y(10)*T(16))^(1-params(4));
T(18) = T(14)*(y(4)*T(15)*T(17)-y(23));
T(19) = y(26)^params(20);
T(20) = y(24)^(1-params(20));
T(21) = T(19)*T(20);
T(22) = y(19)^params(19);
T(23) = params(25)^(1-params(19));
T(24) = T(23)*T(21)/(y(24)*y(19));
T(25) = T(22)*T(24);
T(26) = 1/(1-params(22));
T(27) = (1-params(72)*T(25)^T(26))/(1-params(72));
T(28) = T(27)^(1-params(22)*(1+params(47)));
T(29) = y(53)*T(28);
T(30) = y(6)*T(29)/params(32);
T(31) = sqrt(params(46)/2);
T(32) = T(31)*(exp(T(31)*(params(69)*y(19)*y(56)-params(69)*params(25)))-exp((params(69)*y(19)*y(56)-params(69)*params(25))*(-T(31))));
T(33) = log((y(22)))+(y(38))^2/2;
T(34) = T(33)/(y(38))-(y(38));
T(35) = params(13)*((y(1))+(y(12)))/(1-params(13));
T(36) = normpdf(T(9),0,1);
T(37) = y(16)/(1-y(16));
T(38) = (T(7))^T(37);
T(39) = (T(4)*y(28))^T(37);
T(40) = (1-params(71))*T(38)+params(71)*T(39);
T(41) = T(40)^((1-y(16))/y(16));
T(42) = T(4)^T(37);
T(43) = params(71)*params(8)*T(42);
T(44) = params(72)*params(8)*params(25)^((1-params(19))/(1-params(22)));
T(45) = T(44)*y(19)^(params(19)/(1-params(22))-1);
T(46) = T(21)^T(26);
T(47) = T(45)*T(46)/y(24);
T(48) = 1/(y(24)*y(19));
T(49) = params(22)/(1-params(22));
T(50) = T(48)^T(49);
T(51) = T(47)*T(50);
T(52) = (y(10)*T(16))^(1+params(47));
T(53) = params(72)*params(8)*T(25)^(params(22)*(1+params(47))/(1-params(22)));
T(54) = (1-params(72))*T(27)^params(22)+params(72)*(y(54)*T(25))^T(49);
T(55) = (T(16)*y(19)*params(69)*y(10)/(y(51)*y(15)))^(1-params(4));
T(56) = (y(34)/params(4))^params(4);
T(57) = (y(53)/(1-params(4)))^(1-params(4));
T(58) = T(56)*T(57);
T(59) = (y(34))*(exp(params(49)*(y(51)-1))-1)/params(49)*params(67);
T(60) = T(11)-params(23)*T(36)/y(38);
T(61) = T(11)/T(60);
T(62) = (1+y(35))/(1+y(30))*(T(12)-T(10)*params(23))-1;
T(63) = params(69)*y(19)*y(12)*y(56)*(-T(32));
T(64) = 1+T(63)/y(12)-(exp(T(31)*(params(69)*y(19)*y(56)-params(69)*params(25)))+exp((params(69)*y(19)*y(56)-params(69)*params(25))*(-T(31)))-2);
T(65) = (params(69)*y(19)*y(56)*y(12)/y(12))^2;
T(66) = T(32)*y(29)*y(17)*y(55)*params(8);
T(67) = params(27)*1/params(33)*(1-params(45))*params(5);
T(68) = (params(10)+params(17))/(1-params(13));
T(69) = y(19)/params(25);
T(70) = (1-params(45))*1/(params(33)*4)*params(6);
T(71) = y(8)/(y(24)*y(19));
T(72) = y(15)*y(29)*(1+y(35))/y(20);
T(73) = 1-normcdf(T(9)-2*y(38),0,1);
T(74) = sqrt(exp(T(8))/T(11)*T(73)-((1-T(10))/T(11))^2);
T(75) = params(23)*normcdf(T(34),0,1)*(1+(y(35)));
T(76) = exp(y(15)*y(29)*(1+y(35))*(T(12)-T(13))/(y(15)*y(29)-y(20))-(y(15))*T(75)/((y(15))-(y(20))));
T(77) = log(y(7)/T(35));
T(78) = params(26)^2;
T(79) = sqrt(1-T(78));
T(80) = params(62)*T(79);
T(81) = params(26)^3;
T(82) = params(26)^4;
T(83) = params(26)^5;
T(84) = params(26)^6;
T(85) = params(26)^7;
T(86) = y(49)/(y(24)*y(19));
T(87) = (params(8)*(1+y(36)))^40;
T(88) = y(55)*T(87);
T(89) = T(86)*T(86)*T(86)*T(86)*T(86)*T(86)*T(86)*T(86)*T(86)*T(86)*y(17)*T(88);
T(90) = T(86)*T(89);
T(91) = T(86)*T(90);
T(92) = T(86)*T(91);
T(93) = T(86)*T(92);
T(94) = T(86)*T(93);
T(95) = T(86)*T(94);
T(96) = T(86)*T(95);
T(97) = T(86)*T(96);
T(98) = T(86)*T(97);
T(99) = T(86)*T(98);
T(100) = T(86)*T(99);
T(101) = T(86)*T(100);
T(102) = T(86)*T(101);
T(103) = T(86)*T(102);
T(104) = T(86)*T(103);
T(105) = T(86)*T(104);
T(106) = T(86)*T(105);
T(107) = T(86)*T(106);
T(108) = T(86)*T(107);
T(109) = T(86)*T(108);
T(110) = T(86)*T(109);
T(111) = T(86)*T(110);
T(112) = T(86)*T(111);
T(113) = T(86)*T(112);
T(114) = T(86)*T(113);
T(115) = T(86)*T(114);
T(116) = T(86)*T(115);
T(117) = T(86)*T(116);
T(118) = T(86)*T(117);
T(119) = T(86)*T(118);
T(120) = (params(8)*y(33))^40;
T(121) = y(55)*T(120);
T(122) = y(17)*T(121)/y(19)/y(19);
T(123) = T(122)/y(19)/y(19);
T(124) = T(123)/y(19)/y(19);
T(125) = T(124)/y(19)/y(19);
T(126) = T(125)/y(19)/y(19);
T(127) = T(126)/y(19)/y(19);
T(128) = T(127)/y(19)/y(19);
T(129) = T(128)/y(19)/y(19);
T(130) = T(129)/y(19)/y(19);
T(131) = T(130)/y(19)/y(19);
T(132) = T(131)/y(19)/y(19);
T(133) = T(132)/y(19)/y(19);
T(134) = T(133)/y(19)/y(19);
T(135) = T(134)/y(19)/y(19);
T(136) = T(135)/y(19)/y(19);
T(137) = T(136)/y(19)/y(19);
T(138) = T(137)/y(19)/y(19);
T(139) = T(138)/y(19)/y(19);
T(140) = T(139)/y(19)/y(19);
T(141) = T(140)/y(19)/y(19);

end
