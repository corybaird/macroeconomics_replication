function table = table_irf(irfs_draws, ss, horizon, varnames, qtoplot)
% PURPOSE: Print out the table with the irfs of all variables to shocks ss
% at the given horizon.
fprintf('responses at horizon %d: quantiles of the posterior distribution\n', horizon-1)
qq = quantile(irfs_draws(:,:,horizon,:),qtoplot,4);
info = struct;
temp = {};
for s = ss
    temp = [temp; strseq(['s' num2str(s) 'q'],qtoplot*100)];
end
info.cnames = strvcat(temp);
info.rnames = strvcat(['variable',varnames]);
info.width = 200;
table = reshape(permute(qq(:,ss,1:length(qtoplot)), [1 3 2]),size(irfs_draws,1),length(ss)*length(qtoplot));
mprint(table, info);
end