function data = loaddata(par)

% Routine that loads the data for the analysis and saves it into 3 datasets
% that will be used in other routines.
% The datasets are arranged in a structure called data for convenience.
% Be sure that data is already in the working directory!

cd data

if par.tickdata
    % Dataset for asset moments (Restricted Sample after 2000)
    dd1 = dataset('File','dataForMatlabTick.csv',...
                 'Delimiter',',',...
                 'ReadVarNames','on');
    dd1.Properties.VarNames{1,27} = 'PI2';
    dd1.Properties.VarNames{1,28} = 'PI3';
    dd1.Properties.VarNames{1,29} = 'PI5';
    dd1.Properties.VarNames{1,30} = 'PI10';
    dd1.Properties.VarNames{1,31} = 'S1';
    dd1.Properties.VarNames{1,32} = 'S2';
    dd1.Properties.VarNames{1,33} = 'S3';
    dd1.Properties.VarNames{1,34} = 'S4';
    dd1.Properties.VarNames{1,35} = 'S5';
    dd1.Properties.VarNames{1,36} = 'PIF2';
    dd1.Properties.VarNames{1,37} = 'PIF3';
    dd1.Properties.VarNames{1,38} = 'PIF5';
    dd1.Properties.VarNames{1,39} = 'PIF10';    
    
    % Dataset for GDP moments' shock (Full Sample 1995 onwards)
    dd2 = dataset('File','dataForMatlabTick_m.csv',...
                 'Delimiter',',',...
                 'ReadVarNames','on');
    dd2.Properties.VarNames{1,5} = 'S1';
    dd2.Properties.VarNames{1,6} = 'S2';
    dd2.Properties.VarNames{1,7} = 'S3';
    dd2.Properties.VarNames{1,8} = 'S4';
    dd2.Properties.VarNames{1,9} = 'S5';
    
    % Dataset for GDP from BlueChip
    ddGDP = dataset('File','dataForMatlabBlueChipGDPTick.csv',...
                    'Delimiter',',',...
                    'ReadVarNames','on');
else
    % Dataset for asset moments (Restricted Sample after 2000)
    dd1 = dataset('File','dataForMatlabDaily.csv',...
                 'Delimiter',',',...
                 'ReadVarNames','on');
    dd1.Properties.VarNames{1,27} = 'PI2';
    dd1.Properties.VarNames{1,28} = 'PI3';
    dd1.Properties.VarNames{1,29} = 'PI5';
    dd1.Properties.VarNames{1,30} = 'PI10';
    dd1.Properties.VarNames{1,31} = 'S1';
    dd1.Properties.VarNames{1,32} = 'S2';
    dd1.Properties.VarNames{1,33} = 'S3';
    dd1.Properties.VarNames{1,34} = 'S4';
    dd1.Properties.VarNames{1,35} = 'S5';
    
    % Dataset for GDP moments' shock (Full Sample 1995 onwards)
    dd2 = dataset('File','dataForMatlabDaily_m.csv',...
                 'Delimiter',',',...
                 'ReadVarNames','on');
    dd2.Properties.VarNames{1,5} = 'S1';
    dd2.Properties.VarNames{1,6} = 'S2';
    dd2.Properties.VarNames{1,7} = 'S3';
    dd2.Properties.VarNames{1,8} = 'S4';
    dd2.Properties.VarNames{1,9} = 'S5';
    
    % Dataset for GDP from BlueChip
    ddGDP = dataset('File','dataForMatlabBlueChipGDPDaily.csv',...
                    'Delimiter',',',...
                    'ReadVarNames','on');
end

data = struct;
data.dd1 = dd1;
data.dd2 = dd2;
data.ddGDP = ddGDP;

cd ..

end
