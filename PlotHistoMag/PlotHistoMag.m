function PlotHistoMag()
% // start the code with PlotHistoMag()
%
% // reads a textfile from a db query and plots the
%EQ distribution per day file format:
%    date          lat       lon       depth    mag  etyp  orid
% 10/05/2012   47.8361   16.1614    0.0000    1.33 sm  1043284

setting = getSettings();

% DATABASE
inp = '9999';   u = 0;
while strcmp(inp,'q') == 0 && strcmp(inp,'0') ==  0
    if setting.DB.readfromDB == 1
        %clc;
        u = u + 1;  setting.statref.currRun = u;
        if u==1
            setting.computeRefstats = 1;
        else
            setting.computeRefstats = 0;
        end
        dbseismo07 = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2007';
        dbseismo06 = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2006';
        dbseismo05 = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2005';
        dbzagsun17 = '/net/zagsun17/export/home/seismo/antelope/db/zagsun17';
        dbzagsun17AEC = '/net/zagsun17/export/home/seismo/bebenkatalog/AEC';
        fprintf('run %g:  ..read the data from \n',u);
        fprintf('[1] %s \n',setting.DB.DBpath);
        fprintf('[2] %s \n',setting.DB.refDBpath);
        fprintf('[3] %s \n',dbzagsun17AEC);
        fprintf('[4] %s \n',dbzagsun17);
        fprintf('[5] %s \n',dbseismo07);
        fprintf('[6] %s \n',dbseismo06);
        fprintf('[7] %s \n',dbseismo05);
        fprintf('[0] write all %g runs to a file and show the stats \n\n',u-1);
        inp = input('>> Please select the database [q..quit]\n','s');
        if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            switch str2num(inp)
                case 1
                    setting.DB.DBpath = setting.DB.DBpath;
                case 2
                    setting.DB.DBpath = setting.DB.refDBpath;
                case 3
                    setting.DB.DBpath = dbzagsun17AEC;             
                case 4
                    setting.DB.DBpath = dbzagsun17;
                case 5
                    setting.DB.DBpath = dbseismo07;
                case 6
                    setting.DB.DBpath = dbseismo06;
                case 7
                    setting.DB.DBpath = dbseismo05;
                case 0
                    %do nothing
                    setting.exit = 0;
            end
        end
    else
        fprintf('..read the data from file %s \n',setting.filepath);
    end
    disp(' ');
    
    if strcmp(inp,'q') == 1 || strcmp(inp,'0') == 1
        setting.exit = 1;
    else
        setting = getSettingsFromMenu(setting);
    end
    
    if setting.exit == 0
        switch setting.flag
            case 1
                setting.saveDBmode = 0;
                NormalHistplotmitMag(setting);
            case 2
                setting.saveDBmode = 0;
                NormalHistplotEQmitandere(setting);
            case 3
                setting.saveDBmode = 0;
                NormalHistplotKlassisch(setting);
                %plotNormalHistogram(data,setting);
            case 4
                setting.saveDBmode = 1;
                [currStats,refStats] = StatisticsToReferencePeriod(setting);
                if setting.computeRefstats == 1
                    if u==1
                        statisticsRef{1} = refStats;
                        fprintf('[info]: The reference period has been fixed now. You may proceed with other regions and show/export them together after n+1 runs.\n');
                    else
                        statisticsRef{u} = statisticsRef{1};
                        fprintf('[info]: The first reference period was added for run %g',u);
                    end
                else
                    statisticsRef{u} = refStats;
                    fprintf('[info]: A new reference period was added for run %g',u);
                end
                statistics{u} = currStats;
                %Statistik (mit Vergleich zu Mittlerer Periode, Wiederkehrperiode (ab 1900)
            case 5
                setting.saveDBmode = 0;
                MaxMagnitudeperCalendarYear(setting);
            case 6
                setting.saveDBmode = 0;
                TemporalStatistics(setting);
            case 7
                setting.saveDBmode = 0;
                writeOnlyEQList(setting);
            case 8
                setting.saveDBmode = 1;
                analyzePhases(setting);
            case 9
                setting.saveDBmode = 1;
                plotWaveformsMenu(setting);                
        end
    end
end


%//export the statistics to a file
[syear,smonth,sday,shour,sminute,ssecond] = datevec(now());
minutesincemidnight = sminute+shour*60;
setting.filenamestatistic = sprintf('%s%s_M%04.0f-No%02.0f.txt',setting.filenamestatistic,datestr(now, 'dd.mm.yyyy'),minutesincemidnight,u);
if setting.exit == 1
    if strcmp(inp,'q') ~= 1
        % //display the statistics
        displayTheStatisticsWithRefPeriode(statisticsRef,statistics,setting);
        
        % //write the statistics to a file
        fprintf('write the statistics now to %s \n',setting.filenamestatistic);
    end
else
    fprintf('no need to write the statistics to %s \n',setting.filenamestatistic);
end



