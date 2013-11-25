function setting = getSettingsMenuABS(setting)

fprintf('[1] Show single station analyses \n');
fprintf('[2] Show single station and export to ASCII \n');
fprintf('[3] Show two station analysis \n');
fprintf('[4] Batch process and export to ASCII \n');
fprintf('[5] Plot acceleration for one event (read from %s DB)\n','DBleeer');
fprintf('[q] Quit \n');
inp = input('>> Please choose your selection [q..quit]\n','s');
if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
    switch str2num(inp)
        case 1
            setting.showSingleStationData = 1;
            setting.showTwoStationData = 0; 
            setting.exportDataASCII = 0;
            setting.addFixStationsManually = 0;
        case 2
            setting.showSingleStationData = 1;
            setting.showTwoStationData = 0; 
            setting.exportDataASCII = 1;
            setting.exportASCII.batchprocess = 0;
        case 3
            setting.showSingleStationData = 0; 
            setting.showTwoStationData = 1; 
            setting.exportDataASCII = 0;
            setting.exportASCII.batchprocess = 0;            
        case 4
            setting.showSingleStationData = 1; 
            setting.showTwoStationData = 0; 
            setting.exportDataASCII = 1;
            setting.exportASCII.batchprocess = 1;      
        case 5
            setting.showEventAcceleration = 1;
            setting.showTwoStationData = 0; 
    end
end
disp(' ');


