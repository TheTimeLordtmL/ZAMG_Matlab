function setting = getSettingsFromMenu(setting)
% use the default settings and apply user spedified settings from
% the user input.
% detailed plot options etc. are found in getSettings.m

fprintf('[started] PlotHistoMag - Bar plots and statistics of EQ data (monthly,daily, hourly) constrained by event type and geographic regions.\n');

% // BEGIN OF USER INPUT
streventtype = '';  strregion = '';   strgeographregion = '';   setting.filter.Felt = 0;   strfelt = '';
setting.useshape.useLandgrenzen = 0;  setting.exit = 0;

% FILTER EVENTS
fprintf('[1] Filter EQ (use all EQ''s) \n');
fprintf('[2] Filter EQ (use all felt EQ''s)  \n');
fprintf('[3] Filter no EQ (use all events but no EQ''s) \n');
fprintf('[4] Filter Induced (use km) \n');
fprintf('[5] Filter Induced (use km & sm & kx) \n');
fprintf('[6] Filter Induced (use sr) \n');
fprintf('[7] Filter Landslide (use kl) \n');
fprintf('[8] No Filter \n');
inp = input('>> Please define a Filter for the events [q..quit]\n','s');
if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
    switch str2num(inp)
        case 1
            setting.filter.UseTheFilter = 1;        %use the eType filter option? (km sm sr - etc.)
            setting.filter.Felt = 0; 
            streventtype = 'Erdbeben';
            setting.filter.WhichData = {'km' 'sm' 'kh' 'sh' 'sr' 'kl' 'uk' 'kx'};  %alle Beben
        case 2
            setting.filter.UseTheFilter = 1;   setting.filter.Felt = 1;
            streventtype = 'Erdbeben';
            setting.filter.WhichData = {'km' 'sm' 'kh' 'sh' 'sr' 'kl' 'uk' '-'};   %nur gefühlte Beben
        case 3
            setting.filter.UseTheFilter = 1;   setting.filter.Felt = 0;
            setting.filter.WhichData = {'-' 'fe' 'de' 'ke' ' '};
            streventtype = 'Ereignisse';
        case 4
            setting.filter.UseTheFilter = 1;   setting.filter.Felt = 0;
            streventtype = 'Sprengungen';
            setting.filter.WhichData = {'sm' 'kh' 'sr' 'sh' 'kl' 'uk' 'kx' '-' 'fe' 'de' 'ke' ' '};
        case 5
            setting.filter.UseTheFilter = 1;   setting.filter.Felt = 0; 
            streventtype = 'Sprengungen';
            setting.filter.WhichData = {'kh' 'sr' 'sh' 'kl' 'uk' '-' 'fe' 'de' 'ke' ' '};
        case 6
            setting.filter.UseTheFilter = 1;   setting.filter.Felt = 0;
            streventtype = 'Suspected Rockbursts';
            setting.filter.WhichData = {'sm' 'km' 'kh' 'sh' 'kl' 'uk' '-' 'fe' 'de' 'ke' ' '};
        case 7
            setting.filter.UseTheFilter = 1;   setting.filter.Felt = 0;
            streventtype = 'Massenbewegung';
            setting.filter.WhichData = {'sm' 'km' 'kh' 'sh' 'sr' 'uk' '-' 'fe' 'de' 'ke' ' '};
        case 8
            setting.filter.UseTheFilter = 0;
    end
end
disp(' ');


fprintf('[1] Rectangle (near to Austria) \n');
fprintf('[2] Rectangle (user specified) \n');
fprintf('[3] Polygon (AT, NÖ, TI, ..)\n');
fprintf('[4] No constraints \n');
inp = input('>> Please define the geographic region [q..quit]\n','s');
if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
    setting.useshape.selectedLandgrenzen = 0;
    switch str2num(inp)
        case 1
            setting.DB.userectangle = 1; %1..near Austria, 2..user specified, 3..no geographic filter
            setting.useshape.useLandgrenzen = 0; %plot data within polygon (bundesländer), 0/1
            [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(9,setting);
            setting.DB.rectangle.Bmin = Bmin;    setting.DB.rectangle.Bmax = Bmax;
            setting.DB.rectangle.Lmin = Lmin;    setting.DB.rectangle.Lmax = Lmax; 
            strregion = 'der Region Österreich';
            strgeographregion = sprintf('Rectangle Österreich - Lat(%7.4f/%7.4f) Lon(%7.4f/%7.4f)',Bmin,Bmax,Lmin,Lmax);
        case 2
            setting.DB.userectangle = 1;  setting.useshape.useLandgrenzen = 0;
            fprintf('[1] Emilia Romagna   [2] Vogtland    [3] Schwaz    [4] Molln   \n');
            fprintf('[5] Hall            [6] Ebreichsdorf       [7] Seebenstein    [8] empty   [9] reserved \n');
            fprintf('[10] empty            [11] Friaul       [12] empty    [13] empty   \n');
            fprintf('[0] User Input \n');
            inp2 = input('>> Please define the geographic region [q..quit]\n','s');
            if isnumeric(str2num(inp2)) && ~strcmp(inp2,'q')
                switch str2num(inp2)
                    case 1
                        strregion = 'Emilia Romagna';
                        [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(1,setting);
                    case 2
                        [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(2,setting);
                        strregion = 'Vogtland';
                    case 3
                          [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(3,setting);
                        strregion = 'Schwaz'; 
                    case 4
                        [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(4,setting);
                        strregion = 'Molln';                        
                    case 5
                        [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(5,setting);
                        strregion = 'Hall';                          
                    case 6
                        [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(6,setting);
                        strregion = 'Ebreichsdorf';    
                    case 7
                        [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(7,setting);
                        strregion = 'Seebenstein';    
                    case 8
                        %neue Region  
                    case 9
                        %reserved! see   getUserDefinedRectangleVals.m                     
                    case 11
                        [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(11,setting);
                        strregion = 'Friaul';    
                    case 0
                        [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(0,setting);
                        strregion = 'B-L';
                    otherwise
                        [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(9,setting); 
                end
                setting.DB.rectangle.Bmin = Bmin;    setting.DB.rectangle.Bmax = Bmax;
                setting.DB.rectangle.Lmin = Lmin;    setting.DB.rectangle.Lmax = Lmax;
                strgeographregion = sprintf('Rectangle %s - Lat(%7.4f/%7.4f) Lon(%7.4f/%7.4f)',strregion,Bmin,Bmax,Lmin,Lmax);
            end
        case 3
            setting.DB.userectangle = 1;  setting.useshape.useLandgrenzen = 1;
            fprintf(' [1] Tirol(+O)     [2] Stmk       [3] Ktn             [4] NÖ \n');
            fprintf(' [5] Vorbg         [6] Sbg        [7] OTirol          [8] Bgld \n');
            fprintf(' [9] Wien         [10] Test      [11] Tirol(nur)     [12] Südtirol \n');
            fprintf(' [0] Österreich   [13] Slowenien [14] Italien        [15] Schweiz \n');
            fprintf(' [16] Slovakia    [17] Hungary   [18] Germany        [19] OberÖ  \n');
            inp = input('>> Please define the polygon region [q..quit]\n','s');
            if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            %1..Tirol 2..Stmk 3..Ktn 4..NÖ 5..Vorbg 6..Sbg 
            %7..OTirol 8..Bgld 9..Wien  10..test 0..Österreich
                switch str2num(inp)
                    case 1
                        setting.useshape.selectedLandgrenzen = 1;  strregion = 'Tirol_gesamt';
                    case 2
                        setting.useshape.selectedLandgrenzen = 2;  strregion = 'Steiermark';
                    case 3
                        setting.useshape.selectedLandgrenzen = 3;  strregion = 'Kärnten';
                     case 4
                        setting.useshape.selectedLandgrenzen = 4;  strregion = 'Niederöstereich';
                     case 5
                        setting.useshape.selectedLandgrenzen = 5;  strregion = 'Vorarlberg';
                     case 6
                        setting.useshape.selectedLandgrenzen = 6;  strregion = 'Salzburg';
                     case 7
                        setting.useshape.selectedLandgrenzen = 7;  strregion = 'Osttirol'; 
                     case 8
                        setting.useshape.selectedLandgrenzen = 8;  strregion = 'Burgenland';
                     case 9
                        setting.useshape.selectedLandgrenzen = 9;  strregion = 'Wien';
                     case 10
                        setting.useshape.selectedLandgrenzen = 10;  strregion = 'Test';
                     case 11
                        setting.useshape.selectedLandgrenzen = 11;  strregion = 'Tirol_allein';  
                     case 12
                        setting.useshape.selectedLandgrenzen = 12;  strregion = 'Südtirol';   
                     case 13
                        setting.useshape.selectedLandgrenzen = 13;  strregion = 'Slowenien'; 
                     case 14
                        setting.useshape.selectedLandgrenzen = 14;  strregion = 'Italien'; 
                     case 15
                        setting.useshape.selectedLandgrenzen = 15;  strregion = 'Schweiz';   
                    case 16
                        setting.useshape.selectedLandgrenzen = 16;  strregion = 'Slovakia';
                    case 17
                        setting.useshape.selectedLandgrenzen = 17;  strregion = 'Hungary';
                    case 18
                        setting.useshape.selectedLandgrenzen = 18;  strregion = 'Germany';
                    case 19
                        setting.useshape.selectedLandgrenzen = 19;  strregion = 'Oberösterreich';                        
                    case 0
                        setting.useshape.selectedLandgrenzen = 0;   strregion = 'Österreich';       
                end
                [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(9,setting);
                setting.DB.rectangle.Bmin = Bmin;    setting.DB.rectangle.Bmax = Bmax;
                setting.DB.rectangle.Lmin = Lmin;    setting.DB.rectangle.Lmax = Lmax;
                strgeographregion = sprintf('Polygon - %s',strregion);
            else
                setting.useshape.useLandgrenzen = 1;
                setting.useshape.selectedLandgrenzen = 1;
                fprintf('prepare QUIT\n');
            end
        case 4
            setting.useshape.useLandgrenzen = 0;
            setting.DB.userectangle = 3; %no rectangle filter to reduce the data amount
            strregion = 'der Welt';
            strgeographregion = sprintf('No Constraints');
    end
end

[setting.title,jahrvonStr,jahrnachStr] = getStringTitle(setting,streventtype,strregion);
setting.magPerCalendarYear.strregion = strregion;
disp(' ');

% PLOT TYPE
fprintf('[1] HistplotWithMagnitude (Farbe pro Magnitude or Intensity-Klasse) \n');
fprintf('[2] Histplot2Classes: 2-Klassen Earthquake und alle anderen Ereignisse  \n');
fprintf('[3] Histplot klassisch (einfärbig, Magnitude or Intensity)  \n');
fprintf('[4] Statistik (mit Vergleich zu Mittlerer Periode, Wiederkehrperiode (ab 1900)) \n');
fprintf('[5] Maximum Magnitude per Calendar Year (hist./1900-2000/<20years) \n');
fprintf('[6] Temporal Statistics - Tagesgang etc. (hist./1900-2000/<20years) \n');
fprintf('[7] write only List of Earthquakes (+KML, Histogram) \n');
fprintf('[8] Analyze Phases \n');
fprintf('[9] Plot waveforms \n');
inp = input('>> Please select the option [q..quit]\n','s');
if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
    switch str2num(inp)
        case 1
            setting.flag = 1;
        case 2
            setting.flag = 2;
        case 3
            setting.flag = 3;
        case 4
            setting.flag = 4;
        case 5
            setting.flag = 5;
        case 6
            setting.flag = 6;  
        case 7
            setting.flag = 7;
        case 8
            setting.flag = 8;  
        case 9
            setting.flag = 9;             
    end
end
disp(' ');


% TIME SPAN
if setting.flag ~= 5 && setting.flag ~= 6 && setting.flag ~= 7
    [thisyear,smonth,sday,shour,sminute,ssecond] = datevec(now());
    lastyear = thisyear - 1;  twoyears = thisyear - 2;
    fprintf('[1] Use the default time span %s %s (%s)\n',jahrvonStr,jahrnachStr,setting.time.start);
    fprintf('[2] Enter a specific time span \n');
    fprintf('[3] The last year (%4g-%4g)\n',lastyear,thisyear);
    fprintf('[4] Two years ago (%4g-%4g)\n',twoyears,lastyear);
    inp = input('>> Please select an option [q..quit]\n','s');
    if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
        switch str2num(inp)
            case 1
                % do nothing
            case 2
                [timestart,timeend] = getTimeSpanfromUserinput(setting);
                setting.time.start = timestart;  setting.time.end = timeend;
            case 3
                setting.time.start = sprintf('_%4g-01-01 00:00_',lastyear);
                setting.time.end = sprintf('_%4g-01-01 00:00_',thisyear);
            case 4
                setting.time.start = sprintf('_%4g-01-01 00:00_',twoyears);
                setting.time.end = sprintf('_%4g-01-01 00:00_',lastyear);
        end
    end
    disp(' ');
end

setting.statref.title{setting.statref.currRun} = setting.title;
setting.statref.strregion{setting.statref.currRun} = strregion;
setting.statref.strfelt{setting.statref.currRun} = strfelt;
setting.statref.streventtype{setting.statref.currRun} = streventtype;
setting.statref.strgeogrregion{setting.statref.currRun} = strgeographregion;
setting.statref.timespan{setting.statref.currRun} = sprintf('%s - %s',setting.time.start,setting.time.end);


% flag==3 // differentiate between Magnitude and Intensity
if setting.flag == 1 || setting.flag == 3 
    fprintf('[1] Use Magnitudes \n');
    fprintf('[2] Use Intensities \n');
    inp = input('>> Please select the option [q..quit]\n','s');
    if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
        switch str2num(inp)
            case 1
                fprintf('Specify the minimal magnitude Ml\n');
                inp = input('>> Please select the option [q..quit]\n','s');
                if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
                    setting.eqlist.minmag = str2num(inp);
                    setting.eqlist.useinensities = 0;
                end
            case 2
                fprintf('Specify the minimal intensity I0 \n');
                inp = input('>> Please select the option [q..quit]\n','s');
                if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
                    setting.eqlist.minintensity = str2num(inp);
                    setting.eqlist.useinensities = 1;
                end
        end
    end
end

% flag==7
if setting.flag == 7 || setting.flag == 9 || setting.flag == 2
    % ask for minimum magnitude (but not when felt EQ's are searched) 
    if setting.filter.Felt == 0
        fprintf('Specify the minimal magnitude \n');
        inp = input('>> Please select the option [q..quit]\n','s');
        if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            setting.eqlist.minmag = str2num(inp);
            setting.eqlist.useinensities = 0;
        end
    end
    if setting.flag == 7
        fprintf('Specify the file format: \n');
        fprintf('[1] evid orid date evname mag lat lon             \n');
        fprintf('[2] evid orid date evname mag lat lon depth etype \n');
        fprintf('[3] evid orid date evname inull lat lon depth etype \n');
        fprintf('[4] evid orid date inull lat lon depth etype \n');
        inp = input('>> Please select the option [q..quit]\n','s');
        if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            setting.eqlist.format = str2num(inp);
        end
        % mark to plot intensity if needed
        switch setting.eqlist.format
            case 3
                setting.eqlist.useinensities = 1;
            case 4
                setting.eqlist.useinensities = 1;
        end
        fprintf('Specify the KML format: \n');
        fprintf('[0] no scale with symbol size             \n');
        fprintf('[1] scale symbol with magnitude \n');
        fprintf('[2] scale symbol with depth   \n');
        fprintf('[99] do not generate a kml file  \n');
        inp = input('>> Please select the option [q..quit]\n','s');
        if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            setting.eqlist.symbolrangeKML = str2num(inp);
        end
    end
end

% flag==7
if setting.flag == 9
    fprintf('How do i plot the waveforms? \n');
    fprintf('[1] Plot several events per station \n');
    fprintf('[2] empty \n');
    fprintf('[3] empty \n');
    fprintf('[4] empty \n');    
    inp = input('>> Please select the option [q..quit]\n','s');
    if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
        switch str2num(inp)
            case 1
                setting.waveforms.ploteventsperstation = 1;
            case 2
                %setting.waveforms.tmp1 = 1;
            case 3
                %setting.waveforms.tmp2 = 1;
        end
    end
end

if strcmp(inp,'q')
    setting.exit = 1;
end

% // END OF USER INPUT

% // Wenn Landesgrenzen verwendet werden
if setting.useshape.useLandgrenzen==1
   switch setting.useshape.selectedLandgrenzen
       case 0
           setting.useshape.LangrenzenPath = 'Österreich.shp';
       case 1
           setting.useshape.LangrenzenPath = 'TirolplusOst.shp';
       case 2
           setting.useshape.LangrenzenPath = 'Steiermark.shp';
       case 3
           setting.useshape.LangrenzenPath = 'Kärnten.shp';
       case 4
           setting.useshape.LangrenzenPath = 'Niederösterreich.shp';
       case 5
           setting.useshape.LangrenzenPath = 'Vorarlberg.shp';
       case 6
           setting.useshape.LangrenzenPath = 'Salzburg.shp';
       case 7
           setting.useshape.LangrenzenPath = 'Osttirol.shp';
       case 8
           setting.useshape.LangrenzenPath = 'Burgenland.shp';
       case 9
           setting.useshape.LangrenzenPath = 'Wien.shp';
       case 10
           setting.useshape.LangrenzenPath = 'tmp_ln.shp';
       case 11
           setting.useshape.LangrenzenPath = 'Tirol.shp'; 
       case 12
           setting.useshape.LangrenzenPath = 'Südtirol.shp'; 
       case 13
           setting.useshape.LangrenzenPath = 'slovenia.shp'; 
       case 14
           setting.useshape.LangrenzenPath = 'italy.shp'; 
       case 15
           setting.useshape.LangrenzenPath = 'swiss.shp';   
       case 16
           setting.useshape.LangrenzenPath = 'slovakia.shp';
       case 17
           setting.useshape.LangrenzenPath = 'hungary.shp'; 
       case 18
           setting.useshape.LangrenzenPath = 'germany.shp'; 
       case 19
           setting.useshape.LangrenzenPath = 'Oberösterreich.shp';            
   end
  setting.useshape.LangrenzenPath = fullfile(pwd,'shp',setting.useshape.LangrenzenPath); 
end



% // If a second Plot (a line) is displayed over the
%    bars the user can choose the parameter which is
%    inputed from a csv-file.
if setting.plot2ndPlotOnHistogramm.yesno == 1   
    switch setting.plot2ndPlotOnHistogramm.type
        case 1 % number earthquake reports
            stationskont1 = csvread('EQ_reports.csv');
            setting.secondPlot.ylabel = 'Anzahl der Bebenmeldungen';
            setting.secondPlot.ylim = [0 2000];
        case 2
            stationskont1 = csvread('Stations_online.csv');
            setting.secondPlot.ylabel = 'Anzahl der Station (BB/SP)';
            setting.secondPlot.ylim = [0 25];
    end
    setting.secondPlot.x = stationskont1(:,1);
    setting.secondPlot.y = stationskont1(:,2);       
end


% // check if AEC is used when setting.filter.Felt = 1 is used
if isempty(strfind(setting.DB.DBpath,'AEC')) & setting.filter.Felt == 1 
  setting.filter.Felt = 0;
  fprintf('..\n');
  fprintf('..Felt EQ''s can only be discriminated by this parameter when using the AEC catalog. (parameter setting.filter.Felt has been set to 0.)\n');
  fprintf('..\n');
end



% Settings for the plot types

switch setting.flag
    case 1  %   NormalHistplotmitMag(setting);
        %setting.title = 'Die Erdbebenserie in Schwaz am 12/10 und 19/10/2010';
        %setting.title = 'Die Emilia Erdbeben am 20/5 und 29/5/2012';
        %setting.title = 'Anzahl der registrierten Ereignisse pro Tag (Mai-Juni 2012)';
        %setting.title = 'Der Erdbebenschwarm in Vogtland am 24/8 und 26/8/2011';
        %// empty title .. title is set autonatically!!
        %setting.title = sprintf('Erdbeben bei Ebreichsdorf - %s',jahrvonStr);
        %setting.title = sprintf('Erdbeben in Österreich %s-%s',jahrvonStr,jahrnachStr);
        %setting.title = 'Gesamte Auswertung mit dem Erdbebenschwarm Vogtland am 24/8 und 26/8/2011';
        setting.ylim = [0 20];  %at 850, emilia 140
        %setting.stacks = {-2 0 1 2 3 4};       %Magnitude/intensity classes - Austria
        setting.stacks = {0 1 2 3 4 5};       %Magnitude/intensity classes - Italy
        %setting.stacks = {0 1 2 3 4};       %gefühlte Magnitude/intensity classes - Austria
        %setting.stacks = {4 5 6 7 8};       %Magnitude/intensity classes - Makroseismik
        %setting.stacks = {-1 0 0.5 1 1.5 2};       %Magnitude/intensity classes - Schwaz
        setting.format.date = 'yyyy/mm/dd';
        setting.format.date1 = 'yyyy/mm/dd HH';
        setting.format.date2 = 'yyyy/mm/dd HH:MM:SS';
        %setting.format.date = 'dd/mm/yyyy';
        %setting.format.date1 = 'dd/mm/yyyy HH';
        %setting.format.date2 = 'dd/mm/yyyy HH:MM:SS';
        setting.src.left = 5; setting.src.bottom = 5; setting.src.width = 1100; setting.src.height = 800;
        setting.InfoPlot.subM = 6;
        setting.InfoPlot.subN = 1;
        setting.InfoPlot.subP = 6;
        setting.labely = 'Anzahl der Erdbeben';
        setting.labelx = 'Tage';
        setting.filter.db = 'AEC.origin';
        setting.lokalsetting = 1; 
    case 2	%   NormalHistplotEQmitandere(setting);
        %// empty title .. title is set autonatically!!
        %setting.title = sprintf('Anzahl der Ereignisse pro Jahr (%s-%s)',jahrvonStr,jahrnachStr);
        setting.ylim = [0 1];
        setting.format.date = 'dd/mm/yyyy';
        setting.format.date1 = 'dd/mm/yyyy HH';
        setting.format.date2 = 'dd/mm/yyyy HH:MM:SS';
        setting.filter.Felt = 0;        %use additionally DB 'felt' (for older data) 0..no 1..yes
        setting.filter1.WhichData = {'km' 'sm' 'kh' 'sh' 'sr' 'sh' 'kl' 'uk' 'kx'};
        setting.filter2.WhichData = {'-' 'fe' 'de' 'ke'};
        setting.filter.db = 'zagsun17.origin';
        setting.src.left = 5; setting.src.bottom = 5; setting.src.width = 1100; setting.src.height = 800;
        setting.legend2classes = {'Erdbeben' 'andere Erschütterungen'};
        setting.labely = 'Anzahl der Ereignisse';
        setting.labelx = 'Tage';
        setting.InfoPlot.subM = 6;
        setting.InfoPlot.subN = 1;
        setting.InfoPlot.subP = 6;
        setting.lokalsetting = 2;
    case 3	%   PlotNormalHistogramm(setting); 
        %// empty title .. title is set autonatically!!
        %setting.title = 'Test';
        setting.ylim = [0 800];
        setting.stacks = {0 1 2 3 4 5};       %Magnitude classes - Italy
        setting.format.date = 'yyyy/mm/dd';
        setting.format.date1 = 'yyyy/mm/dd HH';
        setting.format.date2 = 'yyyy/mm/dd HH:MM:SS';
        setting.filter.Felt = 0;        %use additionally DB 'felt' (for older data) 0..no 1..yes
        setting.src.left = 5; setting.src.bottom = 5; setting.src.width = 1100; setting.src.height = 800;
        setting.labely = 'Anzahl der Ereignisse';
        setting.labelx = 'Tage';
        setting.filter.db = 'AEC.origin';
        setting.InfoPlot.subM = 6;
        setting.InfoPlot.subN = 1;
        setting.InfoPlot.subP = 6;  
        setting.lokalsetting = 3; 
    case 4
        
    case 5
        setting.title1 = 'Max. Magnitude per Calendar Year (historic Data)';
        setting.title2 = 'Max. Magnitude per Calendar Year (1900-2000)';
        setting.title3 = 'Max. Magnitude per Calendar Year (<20years)';
        %setting.title = 'Der Erdbebenschwarm in Vogtland am 24/8 und 26/8/2011';
        
        %setting.title = sprintf('Gefühlte Erdbeben in Österreich - %s',jahrvonStr);
        %setting.title = sprintf('Erdbeben in Österreich %s-%s',jahrvonStr,jahrnachStr);
        %setting.title = 'Gesamte Auswertung mit dem Erdbebenschwarm Vogtland am 24/8 und 26/8/2011';
        setting.ylim = [0 6];  %Magnitude
        %setting.stacks = {-2 0 1 2 3 4};       %Magnitude classes - Austria
        %setting.stacks = {0 1 2 3 4 5};       %Magnitude classes - Italy
        setting.stacks = {0 1 2 3 4};       %gefühlte Magnitude classes - Austria
        %setting.stacks = {-1 0 0.5 1 1.5 2};       %Magnitude classes - Schwaz
        setting.format.date = 'yyyy/mm/dd';
        setting.format.date1 = 'yyyy/mm/dd HH';
        setting.format.date2 = 'yyyy/mm/dd HH:MM:SS';
        %setting.format.date = 'dd/mm/yyyy';
        %setting.format.date1 = 'dd/mm/yyyy HH';
        %setting.format.date2 = 'dd/mm/yyyy HH:MM:SS';
        setting.src.left = 5; setting.src.bottom = 5; setting.src.width = 1100; setting.src.height = 800;
        setting.labely = 'Magnitude (Ml)';
        setting.labelx = 'Year';
        setting.filter.db = 'AEC.origin';
        setting.lokalsetting = 1;      
    case 6
        %setting.title = 'Die Erdbebenserie in Schwaz am 12/10 und 19/10/2010';
        %setting.title = 'Die Emilia Erdbeben am 20/5 und 29/5/2012';
        %setting.title = 'Anzahl der registrierten Ereignisse pro Tag (Mai-Juni 2012)';
        %setting.title = 'Der Erdbebenschwarm in Vogtland am 24/8 und 26/8/2011';
        
        %setting.title = sprintf('Gefühlte Erdbeben in Österreich - %s',jahrvonStr);
        %setting.title = sprintf('Erdbeben in Österreich %s-%s',jahrvonStr,jahrnachStr);
        %setting.title = 'Gesamte Auswertung mit dem Erdbebenschwarm Vogtland am 24/8 und 26/8/2011';
        setting.ylim = [0 100];  %at 850, emilia 140
        %setting.stacks = {-2 0 1 2 3 4};       %Magnitude classes - Austria
        %setting.stacks = {0 1 2 3 4 5};       %Magnitude classes - Italy
        setting.stacks = {0 1 2 3 4};       %gefühlte Magnitude classes - Austria
        %setting.stacks = {-1 0 0.5 1 1.5 2};       %Magnitude classes - Schwaz
        setting.format.date = 'yyyy/mm/dd';
        setting.format.date1 = 'yyyy/mm/dd HH';
        setting.format.date2 = 'yyyy/mm/dd HH:MM:SS';
        %setting.format.date = 'dd/mm/yyyy';
        %setting.format.date1 = 'dd/mm/yyyy HH';
        %setting.format.date2 = 'dd/mm/yyyy HH:MM:SS';
        setting.src.left = 5; setting.src.bottom = 5; setting.src.width = 1100; setting.src.height = 800;
        setting.InfoPlot.subM = 6;
        setting.InfoPlot.subN = 1;
        setting.InfoPlot.subP = 6;
        setting.labely1 = 'Number';  setting.labely2 = 'Moment M0';
        setting.labelx = 'leer';
        setting.filter.db = 'AEC.origin';  
        switch setting.temporalresolution
            case 'h'
                setting.labelx = 'Hour';
            case 'd'
                setting.labelx = 'Day';
            case 'm'
                setting.labelx = 'Month';
            case 'j'
                setting.labelx = 'Year';
            
        end
    otherwise
        setting.src.left = 5; setting.src.bottom = 5; setting.src.width = 1100; setting.src.height = 800;
        
end

