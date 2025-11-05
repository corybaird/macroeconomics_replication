function [irfs_draws, irfs_l_draws, irfs_u_draws] = resirfssign_robust(res, nstep, dims_array, test_restr, b_normalize, nattempts)
% PURPOSE: Compute irfs with sign restrictions
% including input for robust error bands of Giacomini, Kitagawa (2015). 
% INPUTS:
% res - struct of VAR results containing res.beta_draws and res.sigma_draws
% nstep - number of periods for which irfs are computed
% dims_array - array of vectors listing dimensions to be rotated
% test_restr - handle to a function which tests restrictions (ret. 1 if ok)
% b_normalize - 1: normalize the IRF to be positive on the main diagonal
%               0: do not normalize
% nattempts - number of random rotations tried
% OUTPUT:
%  irfs_draws - draws of irfs with sign restrictions imposed if possible
%                 N by N by nstep by ndraws*(success rate)
%  irfs_l_draws - lowest irfs satisfying test_restr obtained across nattempts rotations
%                 N by N by nstep by ndraws*(success rate)
%  irfs_u_draws - highest irfs satisfying test_restr obtained across nattempts rotations
%                 N by N by nstep by ndraws*(success rate)
%
% DEPENDS: -
% SUBFUNCTIONS: imulsdtrf, mmult3d2d
% Marek Jarocinski 2017 November 13 (based on resirfssign)
% 2018 January: new argument b_normalize, keep only succesful draws

disp('Computing Giacomini-Kitagawa bounds for irfs with sign restrictions')
if ~iscell(dims_array)
    error('supply a cell array of dimensions');
end

[NPpW, N, ndraws] = size(res.beta_draws);
P = res.lags;

failures = 0;

irfs_draws = zeros(N,N,nstep,ndraws);
irfs_l_draws = zeros(N,N,nstep,ndraws);
irfs_u_draws = zeros(N,N,nstep,ndraws);

timing_start = now;
waitbar_handle = waitbar(0,'','Name','Sign restrictions with Giacomini-Kitagawa bands','Units','centimeters','Position',[10 10 11 2]);
for i = 1:ndraws
    betadraw = res.beta_draws(1:N*P,:,i);
    sigmadraw = res.sigma_draws(:,:,i);
    % choleski irf
    irfchol = impulsdtrf(reshape(betadraw',N,N,P),chol(sigmadraw),nstep);

    % apply sign restrictions
    response_attempts = nan(N,N,nstep,nattempts);
    for a = 1:nattempts
        % create an orthogonal matrix
        Q = eye(N);
        for d = 1:length(dims_array)
            dims = dims_array{d};
            [QQ,R] = qr(randn(length(dims),length(dims))); % draw orthogonal QQ
            Q(dims,dims) = QQ;
        end
        
        if b_normalize % normalize shocks to be positive
            toflip = find(diag(irfchol(:,:,1)*Q)<0);
            Q(:,toflip) = -Q(:,toflip);
        end
        
        respcand = mmult3d2d(irfchol,Q); % rotate the choleski irf with Q
        
        if test_restr(respcand) % check if Q satisfies restrictions
            response_attempts(:,:,:,a) = respcand;
        end
    end
    % which attempts succeeded?
    isuccess = ~isnan(squeeze(response_attempts(1,1,1,:)));
    if any(isuccess);
        response_attempts = response_attempts(:,:,:,isuccess);
        irfs_l_draws(:,:,:,i) = min(response_attempts,[],4); 
        irfs_u_draws(:,:,:,i) = max(response_attempts,[],4);
        irfs_draws(:,:,:,i) = response_attempts(:,:,:,1);
    else
        failures = failures + 1;
        irfs_draws(:,:,:,i) = respcand;
    end
    % end of sign restrictions %
    
    if ~rem(i,1)
        waitbar(i/ndraws, waitbar_handle, [timing_message(i, ndraws, timing_start) '; %failed: ' num2str(failures/i,'%4.2f')])
    end
end
close(waitbar_handle)
isuccess = ~isnan(squeeze(irfs_l_draws(1,1,1,:))); % for which posterior draws we found at least one Q
irfs_l_draws = irfs_l_draws(:,:,:,isuccess);
irfs_u_draws = irfs_u_draws(:,:,:,isuccess);
disp([timing_message(i, ndraws, timing_start) '; %failed: ' num2str(failures/i,'%4.2f')]);
end


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