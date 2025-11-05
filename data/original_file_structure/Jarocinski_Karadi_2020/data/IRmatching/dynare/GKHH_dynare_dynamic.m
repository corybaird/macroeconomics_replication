function [residual, g1, g2, g3] = GKHH_dynare_dynamic(y, x, params, steady_state, it_)
%
% Status : Computes dynamic model for Dynare
%
% Inputs :
%   y         [#dynamic variables by 1] double    vector of endogenous variables in the order stored
%                                                 in M_.lead_lag_incidence; see the Manual
%   x         [nperiods by M_.exo_nbr] double     matrix of exogenous variables (in declaration order)
%                                                 for all simulation periods
%   steady_state  [M_.endo_nbr by 1] double       vector of steady state values
%   params    [M_.param_nbr by 1] double          vector of parameter values in declaration order
%   it_       scalar double                       time period for exogenous variables for which to evaluate the model
%
% Outputs:
%   residual  [M_.endo_nbr by 1] double    vector of residuals of the dynamic model equations in order of 
%                                          declaration of the equations.
%                                          Dynare may prepend auxiliary equations, see M_.aux_vars
%   g1        [M_.endo_nbr by #dynamic variables] double    Jacobian matrix of the dynamic model equations;
%                                                           rows: equations in order of declaration
%                                                           columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%   g2        [M_.endo_nbr by (#dynamic variables)^2] double   Hessian matrix of the dynamic model equations;
%                                                              rows: equations in order of declaration
%                                                              columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%   g3        [M_.endo_nbr by (#dynamic variables)^3] double   Third order derivative matrix of the dynamic model equations;
%                                                              rows: equations in order of declaration
%                                                              columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

%
% Model equations
%

residual = zeros(45, 1);
lambda__ = (1-params(8))*(1-params(8)*params(55))/params(8);
T33 = params(9)*exp(y(41))*(exp(y(65))-exp(y(25))*params(9))^(-1);
T64 = exp(y(27))*exp(y(38))*(1-params(3))*exp(y(19))/exp(y(23));
T76 = exp(y(41))*exp(y(68))*(exp(y(67))-exp(y(34)));
T77 = params(27)-T76;
T99 = exp(y(26))*(exp(y(21))-exp(y(42)))/exp(y(31));
T181 = exp(y(54))*(exp(y(29))+exp(y(26))*(1-params(4)))/exp(y(4));
T186 = exp(y(56))*exp(y(20))^params(3);
T187 = exp(y(23))^(1-params(3));
T196 = exp(y(24))/exp(y(2));
T197 = T196-1;
T199 = params(6)/2*T197^2;
T208 = exp(y(64))/exp(y(24));
T210 = exp(y(41))*exp(y(66))*params(6)*(T208-1);
T211 = T208^2;
lhs =exp(y(27));
rhs =(exp(y(25))-params(9)*exp(y(3)))^(-1)-T33;
residual(1)= lhs-rhs;
lhs =exp(y(28));
rhs =exp(y(27))/exp(y(5));
residual(2)= lhs-rhs;
lhs =exp(y(41))*exp(y(66))*exp(y(34));
rhs =1;
residual(3)= lhs-rhs;
lhs =params(28)*exp(y(23))^params(1);
rhs =T64;
residual(4)= lhs-rhs;
lhs =exp(y(36));
rhs =exp(y(34))*exp(y(41))*exp(y(68))/T77;
residual(5)= lhs-rhs;
lhs =exp(y(37));
rhs =exp(y(28))*(1-params(2)+exp(y(36))*params(27)*params(2));
residual(6)= lhs-rhs;
lhs =exp(y(36));
rhs =T99;
residual(7)= lhs-rhs;
lhs =exp(y(22));
rhs =exp(y(26))*(exp(y(21))-exp(y(42)))-exp(y(31));
residual(8)= lhs-rhs;
lhs =exp(y(31));
rhs =exp(y(32))+params(26);
residual(9)= lhs-rhs;
lhs =exp(y(32));
rhs =params(2)*(exp(y(7))+(exp(y(33))-exp(y(7)))*exp(y(8)))*exp(y(6));
residual(10)= lhs-rhs;
lhs =exp(y(44));
rhs =(1+params(30)*exp(y(45)))/exp(y(10));
residual(11)= lhs-rhs;
lhs =exp(y(41))*exp(y(68))*(exp(y(69))-exp(y(34)));
rhs =T76;
residual(12)= lhs-rhs;
lhs =exp(y(46));
rhs =params(30)+1/exp(y(45));
residual(13)= lhs-rhs;
lhs =exp(y(47));
rhs =(1+params(31)*exp(y(70)))/exp(y(34));
residual(14)= lhs-rhs;
lhs =exp(y(48));
rhs =params(31)+1/exp(y(47));
residual(15)= lhs-rhs;
lhs =y(60);
rhs =exp(y(46))-exp(y(48))-params(74);
residual(16)= lhs-rhs;
lhs =exp(y(29));
rhs =exp(y(19))*exp(y(38))*params(3)/exp(y(20));
residual(17)= lhs-rhs;
lhs =exp(y(33));
rhs =T181;
residual(18)= lhs-rhs;
lhs =exp(y(19));
rhs =T186*T187;
residual(19)= lhs-rhs;
lhs =exp(y(26));
rhs =1+T199+exp(y(24))*params(6)*T197/exp(y(2))-T210*T211;
residual(20)= lhs-rhs;
lhs =y(55)-params(10)*y(12);
rhs =params(55)*(y(72)-y(55)*params(10))+lambda__*(y(38)-log(params(52)));
residual(21)= lhs-rhs;
lhs =exp(y(40));
rhs =exp(y(34))*exp(y(72));
residual(22)= lhs-rhs;
lhs =y(40);
rhs =params(17)*y(9)+(1-params(17))*(log(params(48))+y(55)*params(11)-(y(38)-log(params(52)))*params(18))+y(57);
residual(23)= lhs-rhs;
lhs =exp(y(19));
rhs =exp(y(25))+exp(y(24))+exp(y(43))+exp(y(24))*T199;
residual(24)= lhs-rhs;
lhs =exp(y(43));
rhs =params(57)*exp(y(59));
residual(25)= lhs-rhs;
lhs =exp(y(21));
rhs =exp(y(24))+exp(y(20))*(1-params(4));
residual(26)= lhs-rhs;
lhs =exp(y(20));
rhs =exp(y(54))*exp(y(1));
residual(27)= lhs-rhs;
lhs =exp(y(42));
rhs =params(29)+exp(y(66))*(exp(y(67))-exp(y(34)))/params(22);
residual(28)= lhs-rhs;
lhs =exp(y(39));
rhs =1/exp(y(38));
residual(29)= lhs-rhs;
lhs =y(56);
rhs =params(20)*y(13)+params(14)*x(it_, 2);
residual(30)= lhs-rhs;
lhs =y(54);
rhs =params(16)*y(11)+params(12)*y(18);
residual(31)= lhs-rhs;
lhs =y(57);
rhs =params(19)*y(14)+params(13)*x(it_, 3);
residual(32)= lhs-rhs;
lhs =y(58);
rhs =params(21)*y(15)-params(15)*x(it_, 4);
residual(33)= lhs-rhs;
lhs =exp(y(41));
rhs =params(55)*exp(y(58));
residual(34)= lhs-rhs;
lhs =y(59);
rhs =params(24)*y(16)+params(25)*x(it_, 5);
residual(35)= lhs-rhs;
lhs =exp(y(30));
rhs =exp(y(19))*exp(y(38))*(1-params(3))/exp(y(23));
residual(36)= lhs-rhs;
lhs =exp(y(35));
rhs =exp(y(67))/exp(y(34));
residual(37)= lhs-rhs;
lhs =exp(y(49));
rhs =(1+params(32)*exp(y(71)))/exp(y(34));
residual(38)= lhs-rhs;
lhs =exp(y(50));
rhs =params(32)+1/exp(y(49));
residual(39)= lhs-rhs;
lhs =y(51);
rhs =y(40)*4;
residual(40)= lhs-rhs;
lhs =y(61);
rhs =y(60)*4;
residual(41)= lhs-rhs;
lhs =y(52);
rhs =y(50)*4;
residual(42)= lhs-rhs;
lhs =y(53);
rhs =y(19)*4;
residual(43)= lhs-rhs;
lhs =y(62);
rhs =x(it_, 1);
residual(44)= lhs-rhs;
lhs =y(63);
rhs =y(17);
residual(45)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(45, 77);

  %
  % Jacobian matrix
  %

T377 = (-(exp(y(19))*exp(y(38))*(1-params(3))/exp(y(23))));
T414 = (-(exp(y(24))*exp(y(2))))/(exp(y(2))*exp(y(2)));
T438 = (-(exp(y(24))*exp(y(64))))/(exp(y(24))*exp(y(24)));
T459 = getPowerDeriv(exp(y(25))-params(9)*exp(y(3)),(-1),1);
T464 = getPowerDeriv(exp(y(65))-exp(y(25))*params(9),(-1),1);
T558 = (-((exp(y(34))*exp(y(41))*exp(y(68))*T77-exp(y(34))*exp(y(41))*exp(y(68))*(-T76))/(T77*T77)));
  g1(1,3)=(-((-(params(9)*exp(y(3))))*T459));
  g1(1,25)=(-(exp(y(25))*T459-params(9)*exp(y(41))*(-(exp(y(25))*params(9)))*T464));
  g1(1,65)=params(9)*exp(y(41))*exp(y(65))*T464;
  g1(1,27)=exp(y(27));
  g1(1,41)=T33;
  g1(2,5)=(-((-(exp(y(27))*exp(y(5))))/(exp(y(5))*exp(y(5)))));
  g1(2,27)=(-(exp(y(27))/exp(y(5))));
  g1(2,28)=exp(y(28));
  g1(3,66)=exp(y(41))*exp(y(66))*exp(y(34));
  g1(3,34)=exp(y(41))*exp(y(66))*exp(y(34));
  g1(3,41)=exp(y(41))*exp(y(66))*exp(y(34));
  g1(4,19)=(-T64);
  g1(4,23)=params(28)*exp(y(23))*getPowerDeriv(exp(y(23)),params(1),1)-(-(exp(y(23))*exp(y(27))*exp(y(38))*(1-params(3))*exp(y(19))))/(exp(y(23))*exp(y(23)));
  g1(4,27)=(-T64);
  g1(4,38)=(-T64);
  g1(5,67)=(-((-(exp(y(34))*exp(y(41))*exp(y(68))*(-(exp(y(41))*exp(y(68))*exp(y(67))))))/(T77*T77)));
  g1(5,34)=(-((exp(y(34))*exp(y(41))*exp(y(68))*T77-exp(y(34))*exp(y(41))*exp(y(68))*(-(exp(y(41))*exp(y(68))*(-exp(y(34))))))/(T77*T77)));
  g1(5,36)=exp(y(36));
  g1(5,68)=T558;
  g1(5,41)=T558;
  g1(6,28)=(-(exp(y(28))*(1-params(2)+exp(y(36))*params(27)*params(2))));
  g1(6,36)=(-(exp(y(28))*exp(y(36))*params(27)*params(2)));
  g1(6,37)=exp(y(37));
  g1(7,21)=(-(exp(y(26))*exp(y(21))/exp(y(31))));
  g1(7,26)=(-T99);
  g1(7,31)=(-((-(exp(y(26))*(exp(y(21))-exp(y(42)))*exp(y(31))))/(exp(y(31))*exp(y(31)))));
  g1(7,36)=exp(y(36));
  g1(7,42)=(-(exp(y(26))*(-exp(y(42)))/exp(y(31))));
  g1(8,21)=(-(exp(y(26))*exp(y(21))));
  g1(8,22)=exp(y(22));
  g1(8,26)=(-(exp(y(26))*(exp(y(21))-exp(y(42)))));
  g1(8,31)=exp(y(31));
  g1(8,42)=(-(exp(y(26))*(-exp(y(42)))));
  g1(9,31)=exp(y(31));
  g1(9,32)=(-exp(y(32)));
  g1(10,6)=(-(params(2)*(exp(y(7))+(exp(y(33))-exp(y(7)))*exp(y(8)))*exp(y(6))));
  g1(10,32)=exp(y(32));
  g1(10,33)=(-(exp(y(6))*params(2)*exp(y(33))*exp(y(8))));
  g1(10,7)=(-(exp(y(6))*params(2)*(exp(y(7))+exp(y(8))*(-exp(y(7))))));
  g1(10,8)=(-(exp(y(6))*params(2)*(exp(y(33))-exp(y(7)))*exp(y(8))));
  g1(11,44)=exp(y(44));
  g1(11,10)=(-((-((1+params(30)*exp(y(45)))*exp(y(10))))/(exp(y(10))*exp(y(10)))));
  g1(11,45)=(-(params(30)*exp(y(45))/exp(y(10))));
  g1(12,67)=(-(exp(y(41))*exp(y(68))*exp(y(67))));
  g1(12,68)=exp(y(41))*exp(y(68))*(exp(y(69))-exp(y(34)))-T76;
  g1(12,41)=exp(y(41))*exp(y(68))*(exp(y(69))-exp(y(34)))-T76;
  g1(12,69)=exp(y(41))*exp(y(68))*exp(y(69));
  g1(13,45)=(-((-exp(y(45)))/(exp(y(45))*exp(y(45)))));
  g1(13,46)=exp(y(46));
  g1(14,34)=(-((-(exp(y(34))*(1+params(31)*exp(y(70)))))/(exp(y(34))*exp(y(34)))));
  g1(14,47)=exp(y(47));
  g1(14,70)=(-(params(31)*exp(y(70))/exp(y(34))));
  g1(15,47)=(-((-exp(y(47)))/(exp(y(47))*exp(y(47)))));
  g1(15,48)=exp(y(48));
  g1(16,46)=(-exp(y(46)));
  g1(16,48)=exp(y(48));
  g1(16,60)=1;
  g1(17,19)=(-(exp(y(19))*exp(y(38))*params(3)/exp(y(20))));
  g1(17,20)=(-((-(exp(y(19))*exp(y(38))*params(3)*exp(y(20))))/(exp(y(20))*exp(y(20)))));
  g1(17,29)=exp(y(29));
  g1(17,38)=(-(exp(y(19))*exp(y(38))*params(3)/exp(y(20))));
  g1(18,4)=(-((-(exp(y(54))*(exp(y(29))+exp(y(26))*(1-params(4)))*exp(y(4))))/(exp(y(4))*exp(y(4)))));
  g1(18,26)=(-(exp(y(54))*exp(y(26))*(1-params(4))/exp(y(4))));
  g1(18,29)=(-(exp(y(29))*exp(y(54))/exp(y(4))));
  g1(18,33)=exp(y(33));
  g1(18,54)=(-T181);
  g1(19,19)=exp(y(19));
  g1(19,20)=(-(T187*exp(y(56))*exp(y(20))*getPowerDeriv(exp(y(20)),params(3),1)));
  g1(19,23)=(-(T186*exp(y(23))*getPowerDeriv(exp(y(23)),1-params(3),1)));
  g1(19,56)=(-(T186*T187));
  g1(20,2)=(-(params(6)/2*T414*2*T197+(exp(y(2))*exp(y(24))*params(6)*T414-exp(y(2))*exp(y(24))*params(6)*T197)/(exp(y(2))*exp(y(2)))));
  g1(20,24)=(-(params(6)/2*T196*2*T197+(exp(y(24))*params(6)*T197+exp(y(24))*params(6)*T196)/exp(y(2))-(T211*exp(y(41))*exp(y(66))*params(6)*T438+T210*T438*2*T208)));
  g1(20,64)=T211*exp(y(41))*exp(y(66))*params(6)*T208+T210*T208*2*T208;
  g1(20,26)=exp(y(26));
  g1(20,66)=T210*T211;
  g1(20,41)=T210*T211;
  g1(21,38)=(-lambda__);
  g1(21,12)=(-params(10));
  g1(21,55)=1-params(55)*(-params(10));
  g1(21,72)=(-params(55));
  g1(22,34)=(-(exp(y(34))*exp(y(72))));
  g1(22,40)=exp(y(40));
  g1(22,72)=(-(exp(y(34))*exp(y(72))));
  g1(23,38)=(-((1-params(17))*(-params(18))));
  g1(23,9)=(-params(17));
  g1(23,40)=1;
  g1(23,55)=(-((1-params(17))*params(11)));
  g1(23,57)=(-1);
  g1(24,19)=exp(y(19));
  g1(24,2)=(-(exp(y(24))*params(6)/2*T414*2*T197));
  g1(24,24)=(-(exp(y(24))+exp(y(24))*T199+exp(y(24))*params(6)/2*T196*2*T197));
  g1(24,25)=(-exp(y(25)));
  g1(24,43)=(-exp(y(43)));
  g1(25,43)=exp(y(43));
  g1(25,59)=(-(params(57)*exp(y(59))));
  g1(26,20)=(-(exp(y(20))*(1-params(4))));
  g1(26,21)=exp(y(21));
  g1(26,24)=(-exp(y(24)));
  g1(27,20)=exp(y(20));
  g1(27,1)=(-(exp(y(54))*exp(y(1))));
  g1(27,54)=(-(exp(y(54))*exp(y(1))));
  g1(28,66)=(-(exp(y(66))*(exp(y(67))-exp(y(34)))/params(22)));
  g1(28,67)=(-(exp(y(66))*exp(y(67))/params(22)));
  g1(28,34)=(-(exp(y(66))*(-exp(y(34)))/params(22)));
  g1(28,42)=exp(y(42));
  g1(29,38)=(-((-exp(y(38)))/(exp(y(38))*exp(y(38)))));
  g1(29,39)=exp(y(39));
  g1(30,13)=(-params(20));
  g1(30,56)=1;
  g1(30,74)=(-params(14));
  g1(31,11)=(-params(16));
  g1(31,54)=1;
  g1(31,18)=(-params(12));
  g1(32,14)=(-params(19));
  g1(32,57)=1;
  g1(32,75)=(-params(13));
  g1(33,15)=(-params(21));
  g1(33,58)=1;
  g1(33,76)=params(15);
  g1(34,41)=exp(y(41));
  g1(34,58)=(-(params(55)*exp(y(58))));
  g1(35,16)=(-params(24));
  g1(35,59)=1;
  g1(35,77)=(-params(25));
  g1(36,19)=T377;
  g1(36,23)=(-((-(exp(y(23))*exp(y(19))*exp(y(38))*(1-params(3))))/(exp(y(23))*exp(y(23)))));
  g1(36,30)=exp(y(30));
  g1(36,38)=T377;
  g1(37,67)=(-(exp(y(67))/exp(y(34))));
  g1(37,34)=(-((-(exp(y(34))*exp(y(67))))/(exp(y(34))*exp(y(34)))));
  g1(37,35)=exp(y(35));
  g1(38,34)=(-((-(exp(y(34))*(1+params(32)*exp(y(71)))))/(exp(y(34))*exp(y(34)))));
  g1(38,49)=exp(y(49));
  g1(38,71)=(-(params(32)*exp(y(71))/exp(y(34))));
  g1(39,49)=(-((-exp(y(49)))/(exp(y(49))*exp(y(49)))));
  g1(39,50)=exp(y(50));
  g1(40,40)=(-4);
  g1(40,51)=1;
  g1(41,60)=(-4);
  g1(41,61)=1;
  g1(42,50)=(-4);
  g1(42,52)=1;
  g1(43,19)=(-4);
  g1(43,53)=1;
  g1(44,73)=(-1);
  g1(44,62)=1;
  g1(45,17)=(-1);
  g1(45,63)=1;

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],45,5929);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],45,456533);
end
end
end
end
