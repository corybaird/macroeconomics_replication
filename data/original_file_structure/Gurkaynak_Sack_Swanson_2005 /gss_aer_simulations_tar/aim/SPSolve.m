% Solve a linear rational expectations model with AIM.  Check the 
% accuracy of the solution, display the roots of the system, and
% compute the observable structure.

%  Modelez syntax parser:

SPParser

%  Define the parameter vector.

if( length(param_) )
  eval(parnam)
  npar = size(param_,1);
  p = zeros(npar,1);
  for i = 1:npar
    p(i) = eval(param_(i,:)) ;
  end ;
else
  p = [];
end

% Numerical tolerances for aim

epsi   = 2.2e-16;
condn  = 1.e-10;
uprbnd = 1 + 1.e-6;

% ---------------------------------------------------------------------
% Construct structural coefficient matrix.
% ---------------------------------------------------------------------

%  Run compute_aim_matrices.

eval([modnam,'_aim_matrices']);

% Construct cof matrix from cofg, cofh

[rh,ch] = size(cofh);
[rg,cg] = size(cofg);
cof = zeros(rh,ch);
cof(1:rg,1:cg) = cofg;
cof = cof + cofh;

flops(0);

[cofb,rts,ia,nex,nnum,lgrts,aimcode] = SPAmalg(cof,neq,nlag,nlead,condn,uprbnd);

if aimcode>1,
  disp(aimerr(aimcode));
end

scof = SPObstruct(cof,cofb,neq,nlag,nlead);
