function YY=var_transform(XX,trans_type,direction)
%Transforms a 1 x nn vector of variables XX to YY 
%according to a cell of type (exp for positives, tan for between 0 and 1) 
%and direction: input for variable with the real line, output to back

nn_var = length(XX);
YY  =   zeros(1,nn_var);

for ii=1:nn_var
    if strcmp(trans_type{ii},'exp')
        if strcmp(direction,'input')
            YY(ii) = log(XX(ii));
        elseif strcmp(direction,'output')
            YY(ii) = exp(XX(ii));
        end;
    elseif strcmp(trans_type{ii},'tan')
        if strcmp(direction,'input')
            YY(ii) = tan((XX(ii)-0.5)*pi);
        elseif strcmp(direction,'output')
            YY(ii) = atan(XX(ii))/pi+0.5;
        end;
    elseif strcmp(trans_type{ii},'no')
        YY(ii)=XX(ii);
    end;
end;