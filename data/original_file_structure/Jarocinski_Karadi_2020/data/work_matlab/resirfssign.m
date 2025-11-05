function irfs_draws = resirfssign(res, nstep, dims_array, test_restr, b_normalize, max_attempts)
% PURPOSE: Compute irfs with sign restrictions
% INPUTS:
% res - struct of VAR results containing res.beta_draws and res.sigma_draws
% nstep - number of periods for which irfs are computed
% dims_array - array of vectors listing dimensions to be rotated
% test_restr - handle to a function which tests restrictions (ret. 1 if ok)
% b_normalize - 1 x N vector with the signs of the shocks, +1/-1
% max_attempts - max. number of random rotations tried
% OUTPUT:
%  irfs_draws - draws of irfs with sign restrictions imposed if possible
%                 N by N by nstep by ndraws*(success rate)
%
% DEPENDS: -
% SUBFUNCTIONS: imulsdtrf, mmult3d2d
% Marek Jarocinski 2007 September 25
% modified 2013 August 29 - update format of variables expected from res
% modified 2015 November - progress reporting
% 2018 January: new argument b_normalize
% 2018 May: return NaN when failed to impose restrictions
% 2019 April: b_normalize changed to a vector

disp('Computing sign restrictions')
if ~iscell(dims_array)
    error('supply a cell array of dimensions');
end

[NPpW, N, ndraws] = size(res.beta_draws);
P = res.lags;

progress_report = 0;
failures = 0;

irfs_draws = nan(N,N,nstep,ndraws);

disp(['Number of draws of the VAR parameters: ' num2str(ndraws)])
timing_start = now;
for i = 1:ndraws
    betadraw = res.beta_draws(1:N*P,:,i);
    sigmadraw = res.sigma_draws(:,:,i);
    % choleski irf
    irfchol = impulsdtrf(reshape(betadraw',N,N,P),chol(sigmadraw),nstep);

    % apply the sign restrictions
    for a = 1:max_attempts
        % create an orthogonal matrix
        Q = eye(N);
        for d = 1:length(dims_array)
            dims = dims_array{d};
            [QQ,R] = qr(randn(length(dims),length(dims))); % draw orthogonal QQ
            Q(dims,dims) = QQ;
        end
        
        if ~isempty(b_normalize) % normalize shocks to have the desired sign
            toflip = find(diag(irfchol(:,:,1)*Q).*b_normalize(:)<0);
            Q(:,toflip) = -Q(:,toflip);
        end
        
        respcand = mmult3d2d(irfchol,Q); % rotate the choleski irf with Q
        
        if test_restr(respcand) % check if Q satisfies restrictions
            irfs_draws(:,:,:,i) = respcand;
            break;
        end
    end
    if isnan(irfs_draws(1,1,1,i)); failures = failures+1; end;
    % end of sign restrictions %
    
    % estimate time and determine if progress reports needed
    if i == 30
        disp([timing_message(i, ndraws, timing_start) '; %failed: ' num2str(failures/i,'%4.2f')]);
        total_time_in_minutes = (now - timing_start)*24*60*ndraws/10;
        progress_report = total_time_in_minutes > 2; % if more than 2 min.
    end
    % progress report
    if progress_report && ~mod(i,round(ndraws/10))
        disp([timing_message(i, ndraws, timing_start) '; %failed: ' num2str(failures/i,'%4.2f')]);
    end
end
disp([timing_message(i, ndraws, timing_start) '; %failed: ' num2str(failures/i,'%4.2f')]);
disp(['total failures: ' num2str(failures)])
end %function


% Sims' code pasted here: NOTE that it assumes: smat'*smat=sigma !
function response=impulsdtrf(B,smat,nstep)
%function response=impulsdtrf(B,smat,nstep)
% Assumes the same model as in rfvar, except here only the By part is used.  
% smat is a square matrix of initial shock vectors.  To produce "orthogonalized
% impulse responses" it should have the property that smat'*smat=sigma, where sigma
% is the Var(u(t)) matrix and u(t) is the residual vector.  One way to get such a smat
% is to set smat=chol(sigma).  To get the smat corresponding to a different ordering,
% use smat=chol(P*Sigma*P')*P, where P is a permutation matrix.
% B is a neq x nvar x nlags matrix.  neq=nvar, of course, but the first index runs over 
% equations.  In response, the first index runs over variables, the second over 
% shocks (in effect, equations), the third over time.
% Code written by Christopher Sims.  This version 6/15/03.
[neq,nvar,nlag]=size(B);
response=zeros(neq,nvar,nstep);
response(:,:,1)=smat';
for it=2:nstep
   for ilag=1:min(nlag,it-1)
      response(:,:,it)=response(:,:,it)+B(:,:,ilag)*response(:,:,it-ilag);
   end
end
end

function prod3d = mmult3d2d(mat3d,mat2d)
% function prod3d = mmult3d2d(mat3d,mat2d)
% INPUT 3-D matrix a by b by c
%       2-D matrix b by d
% OUTPUT 3-D a by d by c matrix, obtained
% by multiplying each of the c 2-D matrices by the second 2-D matrix
[a b c] = size(mat3d);
[b1 d] = size(mat2d);
if b1~=b error('matrices not conformable!'); end;
prod2dstacked = reshape(permute(mat3d,[1 3 2]),a*c,b)*mat2d;
prod3d = ipermute(reshape(prod2dstacked,a,c,d),[1 3 2]);
end