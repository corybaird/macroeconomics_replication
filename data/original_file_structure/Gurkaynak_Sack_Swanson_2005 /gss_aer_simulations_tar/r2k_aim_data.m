function [param_,np,modname,neq,nlag,nlead,eqname_,eqtype_,endog_,delay_,vtype_] = ...
     r2k_aim_data()

% r2k_aim_data()
%     This function will return various information about the AIM model,
%     but will not compute the G and H matrices.

  eqname = cell(8, 1);
  param = cell(6, 1);
  endog = cell(8, 1);
  delay = zeros(8, 1);
  vtype = zeros(8, 1);
  eqtype = zeros(8, 1);

  modname = 'r2k';
  neq = 8;
  np = 6;
  nlag = 4;
  nlead = 4;

  eqname(1) = cellstr('INFLATION');
  eqname(2) = cellstr('OUTPUT');
  eqname(3) = cellstr('POLICYRULE');
  eqname(4) = cellstr('DEFLPIBAR');
  eqname(5) = cellstr('EPSPI');
  eqname(6) = cellstr('EPSY');
  eqname(7) = cellstr('i1');
  eqname(8) = cellstr('Di1');
  eqname_ = char(eqname);

  eqtype(1) = 0;     eqtype(2) = 0;     eqtype(3) = 1;   
  eqtype(4) = 1;     eqtype(5) = 0;     eqtype(6) = 0;   
  eqtype(7) = 0;     eqtype(8) = 0;   
  eqtype_ = eqtype;

  param(1) = cellstr('MU');
  param(2) = cellstr('C');
  param(3) = cellstr('A');
  param(4) = cellstr('B');
  param(5) = cellstr('PHIPI');
  param(6) = cellstr('PHIY');
  param_ = char(param);

  endog(1) = cellstr('pi');
  endog(2) = cellstr('y');
  endog(3) = cellstr('i');
  endog(4) = cellstr('lpibar');
  endog(5) = cellstr('epspi');
  endog(6) = cellstr('epsy');
  endog(7) = cellstr('i1');
  endog(8) = cellstr('Di1');
  endog_ = char(endog);

  delay(1) = 0;     delay(2) = 0;     delay(3) = 0;   
  delay(4) = 0;     delay(5) = 0;     delay(6) = 0;   
  delay(7) = 0;     delay(8) = 0;   
  delay_ = delay;

  vtype(1) = 0;     vtype(2) = 0;     vtype(3) = 0;   
  vtype(4) = 0;     vtype(5) = 0;     vtype(6) = 0;   
  vtype(7) = 0;     vtype(8) = 0;   
  vtype_ = vtype;



