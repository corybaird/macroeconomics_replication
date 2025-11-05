function [param_,np,modname,neq,nlag,nlead,eqname_,eqtype_,endog_,delay_,vtype_] = ...
     r2kpistar_aim_data()

% r2kpistar_aim_data()
%     This function will return various information about the AIM model,
%     but will not compute the G and H matrices.

  eqname = cell(11, 1);
  param = cell(8, 1);
  endog = cell(11, 1);
  delay = zeros(11, 1);
  vtype = zeros(11, 1);
  eqtype = zeros(11, 1);

  modname = 'r2kpistar';
  neq = 11;
  np = 8;
  nlag = 4;
  nlead = 4;

  eqname(1) = cellstr('INFLATION');
  eqname(2) = cellstr('OUTPUT');
  eqname(3) = cellstr('POLICYRULE');
  eqname(4) = cellstr('CBPISTAR');
  eqname(5) = cellstr('PSPISTAR');
  eqname(6) = cellstr('EPSPI');
  eqname(7) = cellstr('EPSY');
  eqname(8) = cellstr('POLICYRULE');
  eqname(9) = cellstr('PIBAR');
  eqname(10) = cellstr('LPIBAR');
  eqname(11) = cellstr('PIGAP');
  eqname_ = char(eqname);

  eqtype(1) = 0;     eqtype(2) = 0;     eqtype(3) = 1;   
  eqtype(4) = 0;     eqtype(5) = 0;     eqtype(6) = 0;   
  eqtype(7) = 0;     eqtype(8) = 1;     eqtype(9) = 0;   
  eqtype(10) = 1;     eqtype(11) = 0;   
  eqtype_ = eqtype;

  param(1) = cellstr('MU');
  param(2) = cellstr('C');
  param(3) = cellstr('A');
  param(4) = cellstr('B');
  param(5) = cellstr('THETA');
  param(6) = cellstr('KAPPA');
  param(7) = cellstr('PHIPI');
  param(8) = cellstr('PHIY');
  param_ = char(param);

  endog(1) = cellstr('pi');
  endog(2) = cellstr('y');
  endog(3) = cellstr('i');
  endog(4) = cellstr('cbpistar');
  endog(5) = cellstr('pspistar');
  endog(6) = cellstr('epspi');
  endog(7) = cellstr('epsy');
  endog(8) = cellstr('pibar');
  endog(9) = cellstr('lpibar');
  endog(10) = cellstr('pigap');
  endog(11) = cellstr('ihat');
  endog_ = char(endog);

  delay(1) = 0;     delay(2) = 0;     delay(3) = 0;   
  delay(4) = 0;     delay(5) = 0;     delay(6) = 0;   
  delay(7) = 0;     delay(8) = 0;     delay(9) = 0;   
  delay(10) = 0;     delay(11) = 0;   
  delay_ = delay;

  vtype(1) = 0;     vtype(2) = 0;     vtype(3) = 0;   
  vtype(4) = 0;     vtype(5) = 0;     vtype(6) = 0;   
  vtype(7) = 0;     vtype(8) = 0;     vtype(9) = 0;   
  vtype(10) = 0;     vtype(11) = 0;   
  vtype_ = vtype;



