function setting = getSettings(filename)
% // the main sub is 'PlotHistMag.m'
% //plotHistoMag: Histogramm with Magnitude Distribution
% FLAG
% 1..HistplotWithMagnitude (Farbe pro Magnitude-Klasse)
% 2..Histplot2Classes: 2-Klassen Earthquake und alle anderen Ereignisse
% 3..Histplot klassisch (einfärbig)
%
% other options are set by user input from getSettingsFrom Menu
setting.flag = 1;   setting.exit = 1;
setting.filenamestatistic = 'stat';

% //DB INPUT
setting.DB.readfromDB = 1;     %if eq's are read from a DB
%setting.time.start = '_2005-01-01 00:00_';  setting.time.end = '_2013-01-01 00:00_'; 

% time start/end - normal data
%setting.time.start = '_2013-01-01 00:00_';  setting.time.end = '_2014-01-01 00:00_'; %schwaz
%setting.time.start = '_1000-01-01 00:00_';  setting.time.end = '_2101-01-01 00:00_'; 
setting.time.start = '_2013-09-20 00:00_';  setting.time.end = '_2013-10-20 10:00_';
%setting.time.start = '_2011-11-30 15:00_';  setting.time.end = '_2011-12-03 10:00_'; %Hall
%setting.time.start = '_2010-01-01 00:00_';  setting.time.end = '_2011-01-01 00:00_'; 
%setting.time.start = '_2011-01-01 00:00_';  setting.time.end = '_2012-01-01 00:00_'; 
%setting.time.start = '_2009-01-01 00:00_';  setting.time.end = '_2010-01-01 00:00_'; 
%setting.time.start = '_2008-01-01 00:00_';  setting.time.end = '_2009-01-01 00:00_';
%setting.time.start = '_2007-01-01 00:00_';  setting.time.end = '_2008-01-01 00:00_';
%setting.time.start = '_2006-01-01 00:00_';  setting.time.end = '_2007-01-01 00:00_';
%setting.time.start = '_2005-01-01 00:00_';  setting.time.end = '_2006-01-01 00:00_';

% time start/end - reference periode data
setting.time.refstart = '_2013-05-07 00:00_';  setting.time.refend = '_2013-05-09 00:00_';

%setting.DB.DBpath = '/net/zagsun17/export/home/seismo/bebenkatalog/AEC'; 
%setting.DB.DBpath = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2007';
%setting.db.events = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2004';
setting.DB.DBpath = '/net/zagmac1/Volumes/Daten/seismo/antelope/db/zagmac1';
%setting.DB.DBpath = '/net/zagsun17/export/home/seismo/antelope/db/zagsun17';  
%setting.DB.refDBpath = '/net/zagsun17/export/home/seismo/bebenkatalog/AEC';
setting.DB.refDBpath = '/net/zagsun26/iscsi/homes/rt/antelope/bebenkatalog/AEC_css30';

% //FILE INPUT
setting.filepath = 'ereignisse20042011AT.xyz';     

setting.xticknumber = 9;   setting.fontsize = 17;  setting.fontsizeaxis = 16;  setting.fontsizetitle = 18;
setting.temporalresolution = 'm';    %d..day   h..hour   m..month  j..jahr
setting.plotInfoSubplot = 1;         % 0/1 outputs statistics on the figure bottom
setting.plotAutoscaleOn = 1;         % 0/1 outputs statistics on the figure bottom
setting.filter.UseTheFilter = 1;        %use the eType filter option? (km sm sr - etc.)
                                            
setting.plot2ndPlotOnHistogramm.yesno = 0;         % 0/1 (e.g. Seismic Moment, EQ reports, Number of Seismic Stations)
setting.plot2ndPlotOnHistogramm.type = 0;       % 1..#EQ reports   2..#seismic stations
setting.legend.setsmallMagZero = 1;         %set the smallest Magnitude to zero (e.g. M=-2)

setting.filter.network = 'ZAMG';
setting.filter.NumberEtypeExclude = 0;    %number of excluded data (intial=0)
setting.filter.excludedDataStr = 'none';

setting.magPerCalendarYear.file = 'MaxMagPerYear.txt';
setting.magPerCalendarYear.maglimitFileMax = 4.5;
setting.magPerCalendarYear.plothierachy = 3;    %1..historic, 2..hist+1900-2000, 3..hist+1900+last 20 years
setting.textfile.folder = 'output'; setting.textfile.prefix = '';
setting.magPerCalendarYear.strregion = ' ';

%// show All Events for a City
setting.showAllEventsforaCity.europe_small_cities = '/net/filer/export/arch2/gis/orte+grenzen/europe_small_cities';

%// KML-file
setting.kml.symbolsizereport.d = 0.44;
setting.kml.symbolsizereport.k = 0.0092;
setting.kml.symbolsizeepicentre.d = 0.3095;
setting.kml.symbolsizeepicentre.k = 0.1376;
setting.kml.symbolsizedamages.d = 0.3;
setting.kml.symbolsizedamages.k = 0.1;
setting.kml.symbol{1} = 'http://zagsun19/~rt/icons/hypocenter_0.png';
setting.kml.symbol{2} = 'http://zagsun19/~rt/icons/kreis_r.gif';
setting.kml.symbol{3} = 'http://zagsun19/~rt/icons/kreis_r.gif';
%http://zagsun19/~rt/icons/kreis_r.gif
setting.kml.linestyle{1} = 2;  setting.kml.linestyle{2} = 2; setting.kml.linestyle{3} = 2;

% // felt earthquakes
setting.felt.minintensity = 3.0;
setting.felt.macroseismikfelstnumberfile = 'feltEQs_Makroseismik.txt';
setting.felt.showFeltEQhisto = 0 ;%show felt eqarthquake histogramm and compare to data from macroseimsic lists

%// write EQ list & KML
setting.eqlist.minmag = 3;
setting.eqlist.format = 1;      % orid date time ml etc.
setting.eqlist.symbolrangeKML = 2;      % scale symbole of KML with Magnitude?
%                                         1..scale with magnitude, 0..no, scale 2..scale with depth
setting.eqlist.symbolsize = 0.5;
setting.kml.symbolsizedepth.d = 0.3;
setting.kml.symbolsizedepth.k = 0.04;

%// analyze phases
setting.phases.maximumdelta = 1.5;  % distance in degree
setting.phases.useonlyZAMGstation = 1;
setting.phases.ZAMG = 'ABSI|ABTA|BOSI|CONA|FETA|KOSI|MOSI|MYKA|RETA|RISI|ROSI|SOKA|UMWA|KMWA|SNWA|WIWA|ZAWA|BGWA|ZETA|NATA|FRTA|BITA|OBSA|SVKA|KEKA|ADSA|WOTA|RSNA|RWNA|LFVA|DFSA|DKSA|SVKA|SKTA|SPTA|OBKA|KBA|WTTA';
disp(' ');


%// plot waveforms
setting.waveforms.ploteventsperstation = 0;
setting.waveforms.plotempty1 = 0;
setting.waveforms.plotempty2 = 0;
setting.waveforms.timespanfromtnull = 0;    %window size specified from tnull + timewindow
setting.waveforms.timespanfrompicks = 1;    %window size specified from picks-tmin + timewindow
setting.waveforms.timewindow = 20;          %time window (secs) e.g. 35
setting.waveforms.tmin = 4;                 %time before picks (first arrival)  

% // Filter
setting.filter.on = 1;          %use the filter (41) or not (0)
setting.filter.type = 'BP';  % LP, HP, BP
switch setting.filter.type
    case 'LP'       %low pass
        setting.filter.lowpassoffdisplace = 5; %low cut off filter for f<0.1 Hz; e.g. 5Hz
        setting.filter.numpolesdisplace = 4;  %number of poles for the filter
    case 'HP'       %high pass
        setting.filter.lowcutoffdisplace = 1.0; %low cut off filter for f<0.1 Hz; e.g. 0.25Hz
        setting.filter.numpolesdisplace = 4;  %number of poles for the filter       
    case 'BP'       %band pass
        setting.filter.Lbound = 1.0; % Hz
        setting.filter.Hbound = 15.0; %HZ
        setting.filter.numpolesdisplace = 4;  %number of poles for the filter  
end



