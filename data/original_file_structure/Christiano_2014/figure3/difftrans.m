function [y_growth]=difftrans(gdp_obsU,yoy,I)
y_growth=log(gdp_obsU);
if yoy==1
    dy=zeros(length(y_growth),1);
    for ii = 5:length(y_growth)
        dy(ii)=(y_growth(ii)+y_growth(ii-1)+y_growth(ii-2)+y_growth(ii-3))/4;
    end
    y_growth=dy;
end
y_growth=y_growth(I:end);
