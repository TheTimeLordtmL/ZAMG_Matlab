function setting = getSettingsMenuABS(setting)
%// settingsMenu for showABSwaveforms.m

% // define some databases
dbAEC = '/net/zagsun17/export/home/seismo/bebenkatalog/AEC';
dbzagsun17 = '/net/zagsun17/export/home/seismo/antelope/db/zagsun17';
dbbasalt = '/net/zagmac1/Volumes/Daten/seismo/antelope/basalt_db/basalt';
%setting.db.events = '/net/zagmac1/Volumes/Daten/seismo/antelope/db/zagmac1';
dbzagmac1 = '/net/zagmac1/Volumes/Daten/seismo/antelope/db/zagmac1';
dbseismo07 = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2007';
dbseismo06 = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2006';
dbseismo05 = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2005';

% // read and select the database
fprintf('[1] %s \n',dbbasalt);
fprintf('[2] %s \n',dbzagmac1);
fprintf('[3] %s \n',dbzagsun17);
fprintf('[4] %s \n',dbseismo07);
fprintf('[5] %s \n',dbseismo06);
fprintf('[6] %s \n',dbseismo05);
inp = input('>> Please select the database [q..quit]\n','s');
if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
    switch str2num(inp)
        case 1
            setting.db.events = dbbasalt;
        case 2
            setting.db.events = dbzagmac1;
        case 3
            setting.db.events = dbzagsun17;
        case 4
            setting.db.events = dbseismo07;
        case 5
            setting.db.events = dbseismo06;
        case 6
            setting.db.events = dbseismo05;
        case 0
            %do nothing
            setting.exit = 0;
    end
end

% // select which task has to perform
fprintf('[1] Show single station analyses \n');
fprintf('[2] Show single station and export to ASCII \n');
fprintf('[3] Show two station analysis (use specific time frames) \n');
fprintf('[4] Show two station analysis (use picks from DB) \n');
fprintf('[5] Batch process and export to ASCII \n');
fprintf('[6] Plot acceleration for one event (read from %s DB)\n','DBleeer');
fprintf('[9] Tools (e.g. getOridFromEvid)\n');
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
            setting.showSingleStationData = 0; 
            setting.showTwoStationData = 2; 
            setting.exportDataASCII = 0;
            setting.exportASCII.batchprocess = 0;             
        case 5
            setting.showSingleStationData = 1; 
            setting.showTwoStationData = 0; 
            setting.exportDataASCII = 1;
            setting.exportASCII.batchprocess = 1;      
        case 6
            setting.showEventAcceleration = 1;
            setting.showTwoStationData = 0; 
        case 9
            setting.showEventAcceleration = 0;
            setting.showTwoStationData = 0;  
            setting.showTools = 1;  
    end
end
disp(' ');





