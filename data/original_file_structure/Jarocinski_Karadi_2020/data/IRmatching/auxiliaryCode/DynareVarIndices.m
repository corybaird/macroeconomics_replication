function VarIndices = DynareVarIndices(Names,M_,VarType)
%Obtains the indices of dynare endogenous variables
%Input:         %Names:     cell array (row or column vector) of variable names
%               %M_:        Dynare output structure
%               %VarType:   'endo' for endogenous, 'exo' for exogenous
%Output:        %VarIndices: Row or column vector (as Names) of indices (NaN if no match)

switch VarType
    case 'endo'
        DynareNamesCell = cellstr(M_.endo_names);   %Convert string matrix to cell array
    case 'exo'
        DynareNamesCell = cellstr(M_.exo_names);   %Convert string matrix to cell array
end;
VarIndices = NaN(size(Names));
for ii=1:length(VarIndices)
    for jj=1:length(DynareNamesCell)
        if (strcmp(Names{ii},DynareNamesCell{jj}))
            VarIndices(ii) = jj;
        end;
    end;
end;
