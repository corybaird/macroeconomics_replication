function objValue = ObjFunc(YY,ObjFuncParams)

global oo_ M_ options_;

v2struct(ObjFuncParams);

XX = var_transform(YY,TransType,'output');

run ../CreateModelIrf.m

%set up objective function
irfDiff = (irf1(:)-irf2Mean(:));
Weight = diag(diag(irf2Var).^(-1));

objValue = (irfDiff'*Weight*irfDiff);