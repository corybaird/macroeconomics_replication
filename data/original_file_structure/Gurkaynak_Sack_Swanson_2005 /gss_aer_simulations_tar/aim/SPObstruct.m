% scof = SPObstruct(cof,cofb,neq,nlag,nlead)
%
% Construct the coefficients in the observable structure.
%    
%   Input arguments:
%
%            cof    structural coefficients; often referred to as H
%            cofb   backward-looking reduced form; often referred to as B
%            neq    number of equations
%            nlag   number of lags;  often referred to as tau
%            nlead  number of leads; often referred to as theta
%
%   Output arguments:
%
%            scof  backward-looking structural (semi-reduced) form
%
%   in other words:
%
%   cofb is observable reduced form: X_t = cofb*[X_{t-nlag} ... X_{t-1}]'
%   scof is the semi-reduced form: scof*[X_{t-nlag} ... X_t]' = 0
%     where shocks to the scof form are the structural shocks
%
%   thus cofb = scof(lastblock) \ scof(first nlag-1 blocks)
%   so one can use the inverse of scof(lastblock) to map the structural
%     shocks to shocks in the reduced-form model
%
%   Appendix A of Fuhrer-Moore (1995 QJE) contains more description
%

function scof = SPObstruct(cof,cofb,neq,nlag,nlead)

% Append the negative identity to cofb
cofb = sparse([cofb, -eye(neq)]) ;
cof = sparse(cof) ;

q = sparse(neq*nlead,neq*(nlag+nlead)) ;
q(1:neq,1:neq*(nlag+1)) = cofb ;
for i = 1:nlead-1
  q(i*neq+(1:neq),i*neq+(1:neq*(nlag+1))) = cofb ;
end

% Note that q has been defined so that
%   q*[X_{t-nlag} ... X_{t+nlead-1}]' = 0
%   also q*[X_{t-nlag+1} ... X_{t+nlead}]' = 0
% By inverting the rightmost neq*nlead columns of q, we can solve for
%   [X_{t+1} ... X_{t+nlead}]' as a function of [X_{t-nlag} ... X_t]'

qrinvqlneg = - q(:,neq*nlag+(1:neq*nlead)) \ q(:,1:neq*nlag) ;


% Finally, generate the backward-looking semi-reduced form
%   = [H_{-nlag} ... H_0] + [0, [H_1 ... H_{nlead}]*(qrinvqlneg)]

scof = cof(:,1:neq*(nlag+1)) + ...
       [zeros(neq,neq), cof(:,neq*(nlag+1)+(1:neq*nlead))*qrinvqlneg];

scof = full(scof) ;
return

% program code written by Gary Anderson
% modified by Eric Swanson 4/21/00
