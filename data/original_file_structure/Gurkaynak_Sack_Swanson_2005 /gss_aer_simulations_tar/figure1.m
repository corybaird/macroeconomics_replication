
clear all

PHIPI = 0 ;
PHIY = 0 ;


% set up AIM pathnames and numerical tolerances:
solve_path = '/mq/home/aim/bin/' ;
dirnam = '/msu/home/m1ets99/papers/term/' ;
modnam = 'cgg' ;
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
for j = 1:3 ;
  
  x = zeros(nlag,neq) ; % initial conditions of the model (steady state is 0)
  shock = zeros(1,neq) ;
  shock(j) = 1 ;
  if (j<3); shock(j)=0; shock(j+3)=1; end ;
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
  subplot(3,3,j); plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,1),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
    title('Inflation (percent)') ;
  subplot(3,3,3+j); plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,2),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
    title('Output Gap (percent)') ;
  subplot(3,3,6+j); plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,3),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
    title('Fed Funds Rate (percent)') ;
  
  % Plot term structure response to the shock:
  figure(2) ;
  hold off ;
  switch j ;
    case 1, tempstr = 'Inflation' ;
    case 2, tempstr = 'Output' ;
    case 3, tempstr = 'Interest Rate' ;
  end ;
  subplot(3,1,j) ;
  hold off ;
  plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,3),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
  title(sprintf('Interest Rate Response to a 1 percent %s Shock',tempstr)) ;
  ylabel('percent') ;
  if (j==3); xlabel('Time (quarters)'); end ;
end ; % end for j=1:3


% set up AIM pathnames and numerical tolerances:
solve_path = '/mq/home/aim/bin/' ;
dirnam = '/msu/home/m1ets99/papers/term/' ;
modnam = 'r2k' ;
parnam = [''] ;
epsi   = 2.2e-16 ;
condn  = 1.e-10 ;
uprbnd = 1 + 1.e-6 ;

% Parse the model file, if desired:
parseflag = 1 ;
SPParser

% Assign numerical values to model parameters:
MU = 0.29 ;


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
for j = 1:3 ;
  
  x = zeros(nlag,neq) ; % initial conditions of the model (steady state is 0)
  shock = zeros(1,neq) ;
  shock(j) = 1 ;
  if (j<3); shock(j)=0; shock(j+4)=1; end ;
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
  subplot(3,3,j); plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,1),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
    title('Inflation (percent)') ;
  subplot(3,3,3+j); plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,2),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
    title('Output Gap (percent)') ;
  subplot(3,3,6+j); plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,3),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
    title('Fed Funds Rate (percent)') ;
  
  % Plot term structure response to the shock:
  figure(2) ;
  hold on ;
  switch j ;
    case 1, tempstr = 'Inflation' ;
    case 2, tempstr = 'Output' ;
    case 3, tempstr = 'Interest Rate' ;
  end ;
  subplot(3,1,j) ; 
  hold on ;
  plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,3),'--r',...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'k') ;
end ; % end for j=1:3

figure(2) ;
subplot(3,1,1) ;
legend('Clarida-Gali-Gertler','Rudebusch') ;
