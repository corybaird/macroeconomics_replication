for ii=1:NVars
        for jj=1:NVarsExo
            irfNameStr = [varsCell{ii,kk} '_' varsExoCell{jj,kk}];
            if kk==1   %Model
                if strcmp(varsCell{ii,kk},'P');   %if it is the price level in dynare, cumulate inflation response
                    eval(['irf' num2str(kk) '(:,' num2str(ii) ')= cumsum(oo_.irfs.infl_' varsExoCell{jj,kk} ')'';']);
                else
                    eval(['irf' num2str(kk) '(:,' num2str(ii) ')= oo_.irfs.' irfNameStr ''';']);
                end;
            elseif kk==2 %VAR
                eval(['irf' num2str(kk) '(:,' num2str(ii) ')=' VARModelStr '.' irfNameStr ''';']);
                eval(['irf' num2str(kk) 'High(:,' num2str(ii) ')=' VARModelStr 'High.' irfNameStr ''';']);
                eval(['irf' num2str(kk) 'Low(:,' num2str(ii) ')=' VARModelStr 'Low.' irfNameStr ''';']);
            end;
        end;
end;

    