function [param_,np,modname,neq,nlag,nlead,eqname_,eqtype_,endog_,delay_,vtype_] = ...
     cgg_aim_data()

% cgg_aim_data()
%     This function will return various information about the AIM model,
%     but will not compute the G and H matrices.

  eqname = cell(5, 1);
  param = cell(8, 1);
  endog = cell(5, 1);
  delay = zeros(5, 1);
  vtype = zeros(5, 1);
  eqtype = zeros(5, 1);

  modname = 'cgg';
  neq = 5;
  np = 8;
  nlag = 3;
  nlead = 1;

  eqname(1) = cellstr('INFLATION');
  eqname(2) = cellstr('OUTPUT');
  eqname(3) = cellstr('POLICYRULE');
  eqname(4) = cellstr('EPSPI');
  eqname(5) = cellstr('EPSY');
  eqname_ = char(eqname);

  eqtype(1) = 0;     eqtype(2) = 0;     eqtype(3) = 1;   
  eqtype(4) = 0;     eqtype(5) = 0;   
  eqtype_ = eqtype;

  param(1) = cellstr('DELTA');
  param(2) = cellstr('LAMBDA');
  param(3) = cellstr('GAMMA');
  param(4) = cellstr('C');
  param(5) = cellstr('A');
  param(6) = cellstr('B');
  param(7) = cellstr('PHIPI');
  param(8) = cellstr('PHIY');
  param_ = char(param);

  endog(1) = cellstr('pi');
  endog(2) = cellstr('y');
  endog(3) = cellstr('i');
  endog(4) = cellstr('epspi');
  endog(5) = cellstr('epsy');
  endog_ = char(endog);

  delay(1) = 0;     delay(2) = 0;     delay(3) = 0;   
  delay(4) = 0;     delay(5) = 0;   
  delay_ = delay;

  vtype(1) = 0;     vtype(2) = 0;     vtype(3) = 0;   
  vtype(4) = 0;     vtype(5) = 0;   
  vtype_ = vtype;



