function err = devAsset(asString,out,mpe)

% Simply calculates difference between data and model moment for
% whatever moment is indicated in asString.

err = 0;
if strcmp(asString,'DNY3M')
    eval(['err = out.Nyields(1,1) - mpe.' asString ';']);
elseif strcmp(asString,'DNY6M')
    eval(['err = out.Nyields(1,2) - mpe.' asString ';']);
elseif strcmp(asString,'DNY1')
    eval(['err = out.Nyields(1,4) - mpe.' asString ';']);
elseif strcmp(asString,'DNY2')
    eval(['err = out.Nyields(1,8) - mpe.' asString ';']);
elseif strcmp(asString,'DNY3')
    eval(['err = out.Nyields(1,12) - mpe.' asString ';']);
elseif strcmp(asString,'DNY5')
    eval(['err = out.Nyields(1,20) - mpe.' asString ';']);
elseif strcmp(asString,'DNY10')
    eval(['err = out.Nyields(1,40) - mpe.' asString ';']);
elseif strcmp(asString,'DNF1')
    eval(['err = out.Nforwards(1,4) - mpe.' asString ';']);
elseif strcmp(asString,'DNF2')
    eval(['err = out.Nforwards(1,8) - mpe.' asString ';']);
elseif strcmp(asString,'DNF3')
    eval(['err = out.Nforwards(1,12) - mpe.' asString ';']);
elseif strcmp(asString,'DNF5')
    eval(['err = out.Nforwards(1,20) - mpe.' asString ';']);
elseif strcmp(asString,'DNF10')
    eval(['err = out.Nforwards(1,40) - mpe.' asString ';']);
elseif strcmp(asString,'DRY2')
    eval(['err = out.Ryields(1,8) - mpe.' asString ';']);
elseif strcmp(asString,'DRY3')
    eval(['err = out.Ryields(1,12) - mpe.' asString ';']);
elseif strcmp(asString,'DRY5')
    eval(['err = out.Ryields(1,20) - mpe.' asString ';']);
elseif strcmp(asString,'DRY10')
    eval(['err = out.Ryields(1,40) - mpe.' asString ';']);
elseif strcmp(asString,'DRF2')
    eval(['err = out.Rforwards(1,8) - mpe.' asString ';']);
elseif strcmp(asString,'DRF3')
    eval(['err = out.Rforwards(1,12) - mpe.' asString ';']);
elseif strcmp(asString,'DRF5')
    eval(['err = out.Rforwards(1,20) - mpe.' asString ';']);
elseif strcmp(asString,'DRF10')
    eval(['err = out.Rforwards(1,40) - mpe.' asString ';']);
elseif strcmp(asString,'DRealGDP_0q')
    eval(['err = out.RGDP(1,1) - mpe.' asString ';']);
elseif strcmp(asString,'DRealGDP_F1q')
    eval(['err = out.RGDP(1,2) - mpe.' asString ';']);
elseif strcmp(asString,'DRealGDP_F2q')
    eval(['err = out.RGDP(1,3) - mpe.' asString ';']);
elseif strcmp(asString,'DRealGDP_F3q')
    eval(['err = out.RGDP(1,4) - mpe.' asString ';']);
elseif strcmp(asString,'DRealGDP_F4q')
    eval(['err = out.RGDP(1,5) - mpe.' asString ';']);
elseif strcmp(asString,'DRealGDP_F5q')
    eval(['err = out.RGDP(1,6) - mpe.' asString ';']);
elseif strcmp(asString,'DRealGDP_F6q')
    eval(['err = out.RGDP(1,7) - mpe.' asString ';']);
elseif strcmp(asString,'DRealGDP_F7q')
    eval(['err = out.RGDP(1,8) - mpe.' asString ';']);
elseif strcmp(asString,'Dlsp500')
    eval(['err = out.stocks(1,1) - mpe.' asString ';']);
elseif strcmp(asString,'PI2')
    eval(['err = out.expinflY(1,8) - mpe.' asString ';']);
elseif strcmp(asString,'PI3')
    eval(['err = out.expinflY(1,12) - mpe.' asString ';']);
elseif strcmp(asString,'PI5')
    eval(['err = out.expinflY(1,20) - mpe.' asString ';']);
elseif strcmp(asString,'PI10')
  eval(['err = out.expinflY(1,40) - mpe.' asString ';']);
elseif strcmp(asString,'PIF2')
    eval(['err = out.expinflF(1,8) - mpe.' asString ';']);
elseif strcmp(asString,'PIF3')
    eval(['err = out.expinflF(1,12) - mpe.' asString ';']);
elseif strcmp(asString,'PIF5')
    eval(['err = out.expinflF(1,20) - mpe.' asString ';']);
elseif strcmp(asString,'PIF10')
    eval(['err = out.expinflF(1,40) - mpe.' asString ';']);
end

end
