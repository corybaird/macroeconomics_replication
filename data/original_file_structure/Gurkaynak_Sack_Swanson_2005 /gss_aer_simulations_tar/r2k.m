clear all

% set up AIM pathnames and numerical tolerances:
solve_path = 'aim/' ;
dirnam = '' ;
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
PHIPI = 0 ;
PHIY = 0 ;
A = 1.53 ;
B = .93 ;
C = .73 ;
SIGMAE = diag([1.012^2,.833^2,0,0,0,0,0,0]) ;

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
  switch j ;
    case 1, tempstr = 'Inflation' ;
    case 2, tempstr = 'Output' ;
    case 3, tempstr = 'Interest Rate' ;
  end ;
  subplot(3,1,j) ;
  hold off ;
  plot([0:NPERIODS-1]',x(nlag+1:nlag+NPERIODS,3),...
  				   [0:NPERIODS-1]',zeros(NPERIODS,1),'--k') ;
  title(sprintf('Interest Rate Response to 1 percent %s Shock',tempstr)) ;
%    ylabel('percent') ;
end ; % end for j=1:3


% Calculate unconditional volatilities for term structure:
  
% Start by putting the system into AR(1) form with AR(1) matrix arA:
neqar1 = neq*nlag ;
arA = [zeros(neqar1-neq,neq), eye(neqar1-neq)  ; cofb ] ;

% Shocks to the reduced-form model have variance given by:
RFSIGMAE = scof(:,neqar1+(1:neq)) \ SIGMAE / scof(:,neqar1+(1:neq))' ;

% Shocks to the AR(1)-form model have variance given by:
ARSIGMAE = zeros(neqar1,neqar1) ;
ARSIGMAE(neq*(nlag-1)+(1:neq),neq*(nlag-1)+(1:neq)) = RFSIGMAE ;

% The steady-state variance of the state variables X is:
vecSIGMAX = (eye(neqar1^2) - kron(arA,arA)) \ reshape(ARSIGMAE,neqar1^2,1) ;
ARSIGMAX = reshape(vecSIGMAX,neqar1,neqar1) ;
SIGMAX = ARSIGMAX(neq*(nlag-1)+(1:neq),neq*(nlag-1)+(1:neq)) ;
 
% unconditional volatility of spot rate:
varx(:,:,1) = ARSIGMAX ;
for i = 2:NPERIODS ;
  varx(:,:,i) = arA * varx(:,:,i-1) * arA' ;
end ;

voltermstruct1 = sqrt(squeeze(varx(neq*(nlag-1)+7,neq*(nlag-1)+7,:))) ;
voltermstructD1 = sqrt(squeeze(varx(neq*(nlag-1)+8,neq*(nlag-1)+8,:))) ;

 
%figure(3) ;
%plot([0:56],voltermstruct1y) ;
%title(sprintf('MU = %.1f',MU)) ;
%axis([0,56,0,3.5]) ;
%% voltermstruct1y(5)/voltermstruct1y(37)
%
