function [residual, g1, g2, g3] = GKHH_dynare_static(y, x, params)
%
% Status : Computes static model for Dynare
%
% Inputs : 
%   y         [M_.endo_nbr by 1] double    vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1] double     vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1] double   vector of parameter values in declaration order
%
% Outputs:
%   residual  [M_.endo_nbr by 1] double    vector of residuals of the static model equations 
%                                          in order of declaration of the equations.
%                                          Dynare may prepend or append auxiliary equations, see M_.aux_vars
%   g1        [M_.endo_nbr by M_.endo_nbr] double    Jacobian matrix of the static model equations;
%                                                       columns: variables in declaration order
%                                                       rows: equations in order of declaration
%   g2        [M_.endo_nbr by (M_.endo_nbr)^2] double   Hessian matrix of the static model equations;
%                                                       columns: variables in declaration order
%                                                       rows: equations in order of declaration
%   g3        [M_.endo_nbr by (M_.endo_nbr)^3] double   Third derivatives matrix of the static model equations;
%                                                       columns: variables in declaration order
%                                                       rows: equations in order of declaration
%
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

residual = zeros( 45, 1);

%
% Model equations
%

lambda__ = (1-params(8))*(1-params(8)*params(55))/params(8);
T22 = (exp(y(7))-exp(y(7))*params(9))^(-1);
T52 = exp(y(9))*exp(y(20))*(1-params(3))*exp(y(1))/exp(y(5));
T64 = exp(y(23))*exp(y(19))*(exp(y(15))-exp(y(16)));
T65 = params(27)-T64;
T85 = exp(y(8))*(exp(y(3))-exp(y(24)))/exp(y(13));
T150 = exp(y(36))*(exp(y(11))+exp(y(8))*(1-params(4)))/exp(y(8));
T155 = exp(y(38))*exp(y(2))^params(3);
T156 = exp(y(5))^(1-params(3));
lhs =exp(y(9));
rhs =T22-T22*params(9)*exp(y(23));
residual(1)= lhs-rhs;
lhs =exp(y(10));
rhs =1;
residual(2)= lhs-rhs;
lhs =exp(y(23))*exp(y(10))*exp(y(16));
rhs =1;
residual(3)= lhs-rhs;
lhs =params(28)*exp(y(5))^params(1);
rhs =T52;
residual(4)= lhs-rhs;
lhs =exp(y(18));
rhs =exp(y(16))*exp(y(23))*exp(y(19))/T65;
residual(5)= lhs-rhs;
lhs =exp(y(19));
rhs =exp(y(10))*(1-params(2)+exp(y(18))*params(27)*params(2));
residual(6)= lhs-rhs;
lhs =exp(y(18));
rhs =T85;
residual(7)= lhs-rhs;
lhs =exp(y(4));
rhs =exp(y(8))*(exp(y(3))-exp(y(24)))-exp(y(13));
residual(8)= lhs-rhs;
lhs =exp(y(13));
rhs =exp(y(14))+params(26);
residual(9)= lhs-rhs;
lhs =exp(y(14));
rhs =exp(y(13))*params(2)*(exp(y(16))+exp(y(18))*(exp(y(15))-exp(y(16))));
residual(10)= lhs-rhs;
lhs =exp(y(26));
rhs =(1+params(30)*exp(y(27)))/exp(y(27));
residual(11)= lhs-rhs;
lhs =exp(y(23))*exp(y(19))*(exp(y(26))-exp(y(16)));
rhs =T64;
residual(12)= lhs-rhs;
lhs =exp(y(28));
rhs =params(30)+1/exp(y(27));
residual(13)= lhs-rhs;
lhs =exp(y(29));
rhs =(1+exp(y(29))*params(31))/exp(y(16));
residual(14)= lhs-rhs;
lhs =exp(y(30));
rhs =params(31)+1/exp(y(29));
residual(15)= lhs-rhs;
lhs =y(42);
rhs =exp(y(28))-exp(y(30))-params(74);
residual(16)= lhs-rhs;
lhs =exp(y(11));
rhs =exp(y(1))*exp(y(20))*params(3)/exp(y(2));
residual(17)= lhs-rhs;
lhs =exp(y(15));
rhs =T150;
residual(18)= lhs-rhs;
lhs =exp(y(1));
rhs =T155*T156;
residual(19)= lhs-rhs;
lhs =exp(y(8));
rhs =1;
residual(20)= lhs-rhs;
lhs =y(37)-y(37)*params(10);
rhs =params(55)*(y(37)-y(37)*params(10))+lambda__*(y(20)-log(params(52)));
residual(21)= lhs-rhs;
lhs =exp(y(22));
rhs =exp(y(16))*exp(y(37));
residual(22)= lhs-rhs;
lhs =y(22);
rhs =y(22)*params(17)+(1-params(17))*(log(params(48))+y(37)*params(11)-(y(20)-log(params(52)))*params(18))+y(39);
residual(23)= lhs-rhs;
lhs =exp(y(1));
rhs =exp(y(7))+exp(y(6))+exp(y(25));
residual(24)= lhs-rhs;
lhs =exp(y(25));
rhs =params(57)*exp(y(41));
residual(25)= lhs-rhs;
lhs =exp(y(3));
rhs =exp(y(6))+exp(y(2))*(1-params(4));
residual(26)= lhs-rhs;
lhs =exp(y(2));
rhs =exp(y(3))*exp(y(36));
residual(27)= lhs-rhs;
lhs =exp(y(24));
rhs =params(29)+exp(y(10))*(exp(y(15))-exp(y(16)))/params(22);
residual(28)= lhs-rhs;
lhs =exp(y(21));
rhs =1/exp(y(20));
residual(29)= lhs-rhs;
lhs =y(38);
rhs =y(38)*params(20)+params(14)*x(2);
residual(30)= lhs-rhs;
lhs =y(36);
rhs =y(36)*params(16)+params(12)*x(1);
residual(31)= lhs-rhs;
lhs =y(39);
rhs =y(39)*params(19)+params(13)*x(3);
residual(32)= lhs-rhs;
lhs =y(40);
rhs =y(40)*params(21)-params(15)*x(4);
residual(33)= lhs-rhs;
lhs =exp(y(23));
rhs =params(55)*exp(y(40));
residual(34)= lhs-rhs;
lhs =y(41);
rhs =y(41)*params(24)+params(25)*x(5);
residual(35)= lhs-rhs;
lhs =exp(y(12));
rhs =exp(y(1))*exp(y(20))*(1-params(3))/exp(y(5));
residual(36)= lhs-rhs;
lhs =exp(y(17));
rhs =exp(y(15))/exp(y(16));
residual(37)= lhs-rhs;
lhs =exp(y(31));
rhs =(1+exp(y(31))*params(32))/exp(y(16));
residual(38)= lhs-rhs;
lhs =exp(y(32));
rhs =params(32)+1/exp(y(31));
residual(39)= lhs-rhs;
lhs =y(33);
rhs =y(22)*4;
residual(40)= lhs-rhs;
lhs =y(43);
rhs =y(42)*4;
residual(41)= lhs-rhs;
lhs =y(34);
rhs =y(32)*4;
residual(42)= lhs-rhs;
lhs =y(35);
rhs =y(1)*4;
residual(43)= lhs-rhs;
lhs =y(44);
rhs =x(1);
residual(44)= lhs-rhs;
lhs =y(45);
rhs =x(1);
residual(45)= lhs-rhs;
if ~isreal(residual)
  residual = real(residual)+imag(residual).^2;
end
if nargout >= 2,
  g1 = zeros(45, 45);

  %
  % Jacobian matrix
  %

T311 = (-(exp(y(1))*exp(y(20))*(1-params(3))/exp(y(5))));
T347 = (exp(y(7))-exp(y(7))*params(9))*getPowerDeriv(exp(y(7))-exp(y(7))*params(9),(-1),1);
T428 = (-((exp(y(16))*exp(y(23))*exp(y(19))*T65-exp(y(16))*exp(y(23))*exp(y(19))*(-T64))/(T65*T65)));
  g1(1,7)=(-(T347-params(9)*exp(y(23))*T347));
  g1(1,9)=exp(y(9));
  g1(1,23)=T22*params(9)*exp(y(23));
  g1(2,10)=exp(y(10));
  g1(3,10)=exp(y(23))*exp(y(10))*exp(y(16));
  g1(3,16)=exp(y(23))*exp(y(10))*exp(y(16));
  g1(3,23)=exp(y(23))*exp(y(10))*exp(y(16));
  g1(4,1)=(-T52);
  g1(4,5)=params(28)*exp(y(5))*getPowerDeriv(exp(y(5)),params(1),1)-(-(exp(y(5))*exp(y(9))*exp(y(20))*(1-params(3))*exp(y(1))))/(exp(y(5))*exp(y(5)));
  g1(4,9)=(-T52);
  g1(4,20)=(-T52);
  g1(5,15)=(-((-(exp(y(16))*exp(y(23))*exp(y(19))*(-(exp(y(23))*exp(y(19))*exp(y(15))))))/(T65*T65)));
  g1(5,16)=(-((exp(y(16))*exp(y(23))*exp(y(19))*T65-exp(y(16))*exp(y(23))*exp(y(19))*(-(exp(y(23))*exp(y(19))*(-exp(y(16))))))/(T65*T65)));
  g1(5,18)=exp(y(18));
  g1(5,19)=T428;
  g1(5,23)=T428;
  g1(6,10)=(-(exp(y(10))*(1-params(2)+exp(y(18))*params(27)*params(2))));
  g1(6,18)=(-(exp(y(10))*exp(y(18))*params(27)*params(2)));
  g1(6,19)=exp(y(19));
  g1(7,3)=(-(exp(y(8))*exp(y(3))/exp(y(13))));
  g1(7,8)=(-T85);
  g1(7,13)=(-((-(exp(y(8))*(exp(y(3))-exp(y(24)))*exp(y(13))))/(exp(y(13))*exp(y(13)))));
  g1(7,18)=exp(y(18));
  g1(7,24)=(-(exp(y(8))*(-exp(y(24)))/exp(y(13))));
  g1(8,3)=(-(exp(y(8))*exp(y(3))));
  g1(8,4)=exp(y(4));
  g1(8,8)=(-(exp(y(8))*(exp(y(3))-exp(y(24)))));
  g1(8,13)=exp(y(13));
  g1(8,24)=(-(exp(y(8))*(-exp(y(24)))));
  g1(9,13)=exp(y(13));
  g1(9,14)=(-exp(y(14)));
  g1(10,13)=(-(exp(y(13))*params(2)*(exp(y(16))+exp(y(18))*(exp(y(15))-exp(y(16))))));
  g1(10,14)=exp(y(14));
  g1(10,15)=(-(exp(y(13))*params(2)*exp(y(18))*exp(y(15))));
  g1(10,16)=(-(exp(y(13))*params(2)*(exp(y(16))+exp(y(18))*(-exp(y(16))))));
  g1(10,18)=(-(exp(y(13))*params(2)*exp(y(18))*(exp(y(15))-exp(y(16)))));
  g1(11,26)=exp(y(26));
  g1(11,27)=(-((exp(y(27))*params(30)*exp(y(27))-exp(y(27))*(1+params(30)*exp(y(27))))/(exp(y(27))*exp(y(27)))));
  g1(12,15)=(-(exp(y(23))*exp(y(19))*exp(y(15))));
  g1(12,19)=exp(y(23))*exp(y(19))*(exp(y(26))-exp(y(16)))-T64;
  g1(12,23)=exp(y(23))*exp(y(19))*(exp(y(26))-exp(y(16)))-T64;
  g1(12,26)=exp(y(23))*exp(y(19))*exp(y(26));
  g1(13,27)=(-((-exp(y(27)))/(exp(y(27))*exp(y(27)))));
  g1(13,28)=exp(y(28));
  g1(14,16)=(-((-(exp(y(16))*(1+exp(y(29))*params(31))))/(exp(y(16))*exp(y(16)))));
  g1(14,29)=exp(y(29))-exp(y(29))*params(31)/exp(y(16));
  g1(15,29)=(-((-exp(y(29)))/(exp(y(29))*exp(y(29)))));
  g1(15,30)=exp(y(30));
  g1(16,28)=(-exp(y(28)));
  g1(16,30)=exp(y(30));
  g1(16,42)=1;
  g1(17,1)=(-(exp(y(1))*exp(y(20))*params(3)/exp(y(2))));
  g1(17,2)=(-((-(exp(y(1))*exp(y(20))*params(3)*exp(y(2))))/(exp(y(2))*exp(y(2)))));
  g1(17,11)=exp(y(11));
  g1(17,20)=(-(exp(y(1))*exp(y(20))*params(3)/exp(y(2))));
  g1(18,8)=(-((exp(y(8))*exp(y(36))*exp(y(8))*(1-params(4))-exp(y(8))*exp(y(36))*(exp(y(11))+exp(y(8))*(1-params(4))))/(exp(y(8))*exp(y(8)))));
  g1(18,11)=(-(exp(y(11))*exp(y(36))/exp(y(8))));
  g1(18,15)=exp(y(15));
  g1(18,36)=(-T150);
  g1(19,1)=exp(y(1));
  g1(19,2)=(-(T156*exp(y(38))*exp(y(2))*getPowerDeriv(exp(y(2)),params(3),1)));
  g1(19,5)=(-(T155*exp(y(5))*getPowerDeriv(exp(y(5)),1-params(3),1)));
  g1(19,38)=(-(T155*T156));
  g1(20,8)=exp(y(8));
  g1(21,20)=(-lambda__);
  g1(21,37)=1-params(10)-params(55)*(1-params(10));
  g1(22,16)=(-(exp(y(16))*exp(y(37))));
  g1(22,22)=exp(y(22));
  g1(22,37)=(-(exp(y(16))*exp(y(37))));
  g1(23,20)=(-((1-params(17))*(-params(18))));
  g1(23,22)=1-params(17);
  g1(23,37)=(-((1-params(17))*params(11)));
  g1(23,39)=(-1);
  g1(24,1)=exp(y(1));
  g1(24,6)=(-exp(y(6)));
  g1(24,7)=(-exp(y(7)));
  g1(24,25)=(-exp(y(25)));
  g1(25,25)=exp(y(25));
  g1(25,41)=(-(params(57)*exp(y(41))));
  g1(26,2)=(-(exp(y(2))*(1-params(4))));
  g1(26,3)=exp(y(3));
  g1(26,6)=(-exp(y(6)));
  g1(27,2)=exp(y(2));
  g1(27,3)=(-(exp(y(3))*exp(y(36))));
  g1(27,36)=(-(exp(y(3))*exp(y(36))));
  g1(28,10)=(-(exp(y(10))*(exp(y(15))-exp(y(16)))/params(22)));
  g1(28,15)=(-(exp(y(10))*exp(y(15))/params(22)));
  g1(28,16)=(-(exp(y(10))*(-exp(y(16)))/params(22)));
  g1(28,24)=exp(y(24));
  g1(29,20)=(-((-exp(y(20)))/(exp(y(20))*exp(y(20)))));
  g1(29,21)=exp(y(21));
  g1(30,38)=1-params(20);
  g1(31,36)=1-params(16);
  g1(32,39)=1-params(19);
  g1(33,40)=1-params(21);
  g1(34,23)=exp(y(23));
  g1(34,40)=(-(params(55)*exp(y(40))));
  g1(35,41)=1-params(24);
  g1(36,1)=T311;
  g1(36,5)=(-((-(exp(y(5))*exp(y(1))*exp(y(20))*(1-params(3))))/(exp(y(5))*exp(y(5)))));
  g1(36,12)=exp(y(12));
  g1(36,20)=T311;
  g1(37,15)=(-(exp(y(15))/exp(y(16))));
  g1(37,16)=(-((-(exp(y(16))*exp(y(15))))/(exp(y(16))*exp(y(16)))));
  g1(37,17)=exp(y(17));
  g1(38,16)=(-((-(exp(y(16))*(1+exp(y(31))*params(32))))/(exp(y(16))*exp(y(16)))));
  g1(38,31)=exp(y(31))-exp(y(31))*params(32)/exp(y(16));
  g1(39,31)=(-((-exp(y(31)))/(exp(y(31))*exp(y(31)))));
  g1(39,32)=exp(y(32));
  g1(40,22)=(-4);
  g1(40,33)=1;
  g1(41,42)=(-4);
  g1(41,43)=1;
  g1(42,32)=(-4);
  g1(42,34)=1;
  g1(43,1)=(-4);
  g1(43,35)=1;
  g1(44,44)=1;
  g1(45,45)=1;
  if ~isreal(g1)
    g1 = real(g1)+2*imag(g1);
  end
if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],45,2025);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],45,91125);
end
end
end
end
