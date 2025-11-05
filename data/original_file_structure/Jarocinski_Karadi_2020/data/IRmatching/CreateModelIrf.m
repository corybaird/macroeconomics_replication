v2struct(ObjFuncParams);

NParams = length(ParamsOptCell);
for ii=1:NParams
    eval(['set_param_value(''' ParamsOptCell{ii} ''',XX(ii))']);
end;

%Calculates impulse responses;
info = stoch_simul([]);  %stoch_simul(var_list_);
if info;
    disp(['Dynare IRF computation fails']);
end;

%Create model's irf matrix
kk=1;
run CreateIrfMatr.m;
