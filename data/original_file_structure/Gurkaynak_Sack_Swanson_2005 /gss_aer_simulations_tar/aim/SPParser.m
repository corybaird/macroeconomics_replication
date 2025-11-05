
% Parser setup for modelez syntax models
if (parseflag) ;
  eval(['! ' solve_path 'mdlez-aim ' dirnam modnam]) ;
end ;

% Run compute_aim_data:
[param_,np,modname,neq,nlag,nlead,eqname_,eqtype_,endog_,delay_,vtype_] = ...
	eval([modnam,'_aim_data']) ;

if (parseflag) ;
  seq  = find(eqtype_==0) ;
  dvar = find(vtype_==0) ;
%  if (length(seq)~=length(dvar)) ;
%    disp(' ') ;
%    warning('Number of data variables not equal to number of stochastic equations.');
%    disp(' ') ;
%  end ;
end ;
