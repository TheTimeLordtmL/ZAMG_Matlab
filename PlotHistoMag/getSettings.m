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
setting.time.start = '_1000-01-01 00:00_';  setting.time.end = '_2014-04-01 00:00_'; 
%setting.time.start = '_2012-01-01 00:00_';  setting.time.end = '_2013-01-01 00:00_';

%setting.time.start = '_2000-03-01 00:00_';  setting.time.end = '_2000-10-01 00:00_';
%setting.time.start = '_1590-01-01 00:00_';  setting.time.end ='_1592-08-01 00:00_';  %Riederberg 1590 (15.sep)
%setting.time.start = '_1200-10-01 00:00_';  setting.time.end = '_1500-08-01 00:00_';  %katschberg 1201 (4.mai)
%setting.time.start = '_1936-02-01 00:00_';  setting.time.end = '_1937-08-01 00:00_';  %obdach 1936 (3.okt)
%setting.time.start = '_1939-02-01 00:00_';  setting.time.end = '_1940-06-01 00:00_';  %puchberg 1939 (18.sep)
%setting.time.start = '_1927-06-01 00:00_';  setting.time.end = '_1928-06-01 00:00_';  %schwadorf 1927 (8.okt)
%setting.time.start = '_1972-01-01 00:00_';  setting.time.end = '_1973-01-01 00:00_';  %seebenstein 1972 (16.4-apr)
%setting.time.start = '_1938-09-01 00:00_';  setting.time.end = '_1939-07-01 00:00_';  %ebreichsdorf 1938 (8.11-nov)
%setting.time.start = '_1976-01-01 00:00_';  setting.time.end = '_1977-04-01 00:00_';  %Friaul 1976 (6.5.-mai)

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
% dbzagsun17AEC = '/net/zagsun17/export/home/seismo/bebenkatalog/AEC';

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

%// write EQ list & KML & AMAP
setting.eqlist.minmag = 0;      %minimal values for the magnitudes
setting.eqlist.format = 1;      % evid orid date time ml etc.
setting.eqlist.symbolrangeKML = 2;      % scale symbole of KML with Magnitude?
setting.eqlist.minintensity = 3;%minimal values for the intensities I0
setting.eqlist.useinensities = 0;%flag for the use of intensities
%                                         1..scale with magnitude, 0..no, scale 2..scale with depth
setting.eqlist.symbolsize = 0.5;
setting.eqlist.showHistplot = 1;        %shows magnitude/intensity histogram
setting.kml.symbolsizedepth.d = 0.3;
setting.kml.symbolsizedepth.k = 0.04;
%
% width/heigth: 4 or 24,  color 3..blau, 6..weiss, 1..rot, 5..schwarz
% text: 18 or 120
% AMAP first circle 
setting.eqlist.amap.plottwocircles = 1; setting.eqlist.amap.writeLabels = 1;  setting.eqlist.amap.coltxt = 5;
setting.eqlist.amap.sizetxt = 100;
setting.eqlist.amap.typ = 6;     setting.eqlist.amap.group = 1;   setting.eqlist.amap.width = 24; 
setting.eqlist.amap.height = 24; setting.eqlist.amap.dir = 100;   setting.eqlist.amap.DimmF = 100; 
setting.eqlist.amap.zoom = 1;    setting.eqlist.amap.size = 40;   setting.eqlist.amap.area = 2;
setting.eqlist.amap.col = 5;     setting.eqlist.amap.ZoomFc = 50; setting.eqlist.amap.RefOn = 0;
% AMAP second circle
setting.eqlist.amap.col2 = 6; setting.eqlist.amap.width2 = 18; setting.eqlist.amap.height2 = 18; 

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
setting.waveforms.timewindow = 15;          %time window (secs) e.g. 35, 15(cona,ebr) 25(arsa,ebr)  
setting.waveforms.tmin = 3;                 %time before picks (secs) (first arrival)  

% // Filter
setting.filter.on = 1;          %use the filter (41) or not (0)
setting.filter.type = 'BP';  % LP, HP, BP
switch setting.filter.type
    case 'LP'       %low pass
        setting.filter.lowpassoffdisplace = 5; %low cut off filter for f<0.1 Hz; e.g. 5Hz
        setting.filter.numpolesdisplace = 4;  %number of poles for the filter
        setting.filter.filterstring = sprintf('%g Hz',setting.filter.lowpassoffdisplace);
    case 'HP'       %high pass
        setting.filter.lowcutoffdisplace = 1.0; %low cut off filter for f<0.1 Hz; e.g. 0.25Hz
        setting.filter.numpolesdisplace = 4;  %number of poles for the filter   
        setting.filter.filterstring = sprintf('%g Hz',setting.filter.lowcutoffdisplace);
    case 'BP'       %band pass
        setting.filter.Lbound = 1.0; % Hz
        setting.filter.Hbound = 15.0; %HZ
        setting.filter.numpolesdisplace = 4;  %number of poles for the filter
        setting.filter.filterstring = sprintf('%g-%g Hz',setting.filter.Lbound,setting.filter.Hbound);
end



