clear all

% set up AIM pathnames and numerical tolerances:
solve_path = 'aim/' ;
dirnam = '' ;
modnam = 'cggpistar' ;
parnam = [''] ;
epsi   = 2.2e-16 ;
condn  = 1.e-10 ;
uprbnd = 1 + 1.e-6 ;

% Parse the model file, if desired:
parseflag = 1 ;
SPParser

% Assign numerical values to model parameters:
DELTA = .99 ;
LAMBDA = .3 ;
GAMMA = 1 ;
PHIPI = 0.8 ;
PHIY = 0.8 ;
THETA = 0.1 ;
KAPPA = 0.1 ;
A = 1.53 ;
B = .93 ;
C = .73 ;

% Set up AIM:
[param_,np,modname,neq,nlag,nlead,eqname_,eqtype_,endog_,delay_,vtype_] = ...
						eval([modnam,'_aim_data']) ;
eval([modnam,'_aim_matrices']) ;
cof = cofh + [cofg, zeros(neq,neq*nlead)] ; % construct cof from cofg, cofh

% Call AIM:
[cofb,rts,ia,nex,nnum,lgrts,err] = SPAmalg(cof,neq,nlag,nlead,condn,uprbnd) ;
if (err>1); disp(aimerr(err)); end ;

% Compute "semi-structural" backward-looking matrix S, and reduced-form
%  backward-looking matrix bmat
scof = SPObstruct(cof,cofb,neq,nlag,nlead) ;
bmat = inv(scof(:,nlag*neq+(1:neq))) ;

% Calculate impulse responses of interest rates to shocks to each equation:
NPERIODS = 61 ;
for j = 1:4 ;

  x = zeros(nlag,neq) ; % initial conditions of the model (steady state is 0)
  shock = zeros(1,neq) ;
  switch j ;
    case 1 ; shock(6) = 1/3.3978 ;
    case 2 ; shock(7) = 1/1.5537 ;
    case 3 ; shock(3) = 1/.5974 ;
    case 4 ; shock(4) = -1 ;
  end ;
  shocks = [zeros(nlag,neq); shock] ; % zeros out shocks in pds t-nlag to t-1
  shocks(size(shocks,1)+1:nlag+NPERIODS,:) = ...
  				   zeros(NPERIODS+nlag-size(shocks,1),neq) ;
  
  % Now, run the system forward:
  for i = nlag+1:nlag+NPERIODS ; % note the system runs out to time t+NPERIODS
    x1 = reshape(x(i-nlag:i-1,:)',neq*nlag,1) ;
    xc = cofb*x1 + bmat*shocks(i,:)' ;
    x(i,:) = xc' ;
  end ;
  
  % Plot impulse responses to the shock:
  figure(1); hold off ;

  subplot(5,4,j); plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,1),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
  switch j ;
    case 1 ; title('inflation shock (\epsilon^\pi)') ;
    case 2 ; title('output shock (\epsilon^y)') ;
    case 3 ; title('funds rate shock (\epsilon^i)') ;
    case 4 ; title('inflation target shock (\epsilon^{\pi*})') ;
  end ;
  subplot(5,4,4+j); plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,2),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
  subplot(5,4,8+j); plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,3),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
  subplot(5,4,12+j); plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,4),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
  subplot(5,4,16+j); plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,5),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
  if (j==1) ;
    subplot(5,4,j) ;
    ylabel('inflation (pct)') ;
    subplot(5,4,4+j) ;
    ylabel('output gap (pct)') ;
    subplot(5,4,8+j) ;
    ylabel('fed funds rate (pct)') ;
    subplot(5,4,12+j) ;
    ylabel('central bank \pi* (pct)') ;
    subplot(5,4,16+j) ;
    ylabel('private sector \pi* (pct)') ;
  end ;


%  % Plot term structure response to the shock:
%  figure(2) ;
%  switch j ;
%    case 1, tempstr = 'Inflation' ;
%    case 2, tempstr = 'Output' ;
%    case 3, tempstr = 'Interest Rate' ;
%  end ;
%  subplot(3,1,j) ;
%  hold off ;
%  plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,3),...
%				    [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
%  title(sprintf('Interest Rate Response to 1-percent %s Shock',tempstr)) ;
%%  ylabel('percent') ;

end ; % end for j=1:3

