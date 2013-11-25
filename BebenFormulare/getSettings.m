function setting = getSettings()
% // the main sub is 'getBebenFormulareATBeben.m'
setting.useshape.useLandgrenzen = 0;
setting.useshape.selectedLandgrenzen = 0;   %1..Tirol 2..Stmk 3..Ktn 4..NÖ 5..Vorbg 6..Sbg 
                                            %7..OTirol 8..Bgld 9..Wien
                                            %10..test 0..Österreich
%setting.db.events = '/net/zagsun17/export/home/seismo/bebenkatalog/AEC';
%setting.db.events = '/net/zagsun17/export/home/seismo/antelope/db/zagsun17';
setting.db.events = '/net/zagmac1/Volumes/Daten/seismo/antelope/db/zagmac1';
%setting.db.aec = '/net/zagmac1/Volumes/Daten/antelope/db/zagmac1';
setting.db.aec = '/net/zagsun26/iscsi/homes/rt/antelope/bebenkatalog/AEC_css30';
%setting.db.aec = '/net/zagsun17/export/home/seismo/bebenkatalog/AEC';
%setting.db.events = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2004';
%setting.db.formular = '/net/zagsun26/export/home/mak_form/formulare';
setting.db.formular = '/net/zagsun26/export/home/mak_form/formulare_css30';
setting.db.formulartable = 'webform_extract';   setting.db.formulartable2 = 'webform';
setting.time.start = '_2013-09-19 00:00_';  setting.time.end =  '_2013-09-23 00:00_';
setting.time.span = 1;  %time span in hours before and after an event.
setting.ComputerAidedIntensity.write = 1;    %generates per PLZ EMS98-intensities for Human and Object matrix
setting.ComputerAidedIntensity.showemptyvals = 1;   %show Matrix values K,L,X,.. in txt.file stacked per PLZ
setting.save.individualforms = 1; %save the individual forms from db : lat long plz, location
setting.corr.timespan = 'fixtimeSpansEvents.csv';   %file with time span corrections, event-based, minute
setting.plot.showPlot = 0;          %show the plots 
setting.plot.individual.xlim = [0 40];      %xlimit für plot der report parameter H,I,...XYZ und dist/numbers plot
setting.plot.azimuth.xlim = [0 75];      %xlimit für azimuth
setting.fontsize = 16;  setting.fontsizeaxis = 15;  setting.fontsizetitle = 16;
setting.src.left = 5;  setting.src.bottom = 5;  setting.src.width = 1100;  setting.src.height = 800;
setting.plotSingleEvent.IsApplied = 0;

% // Wenn Landesgrenzen verwendet werden
if setting.useshape.useLandgrenzen==1
   [shapefile,shapename] = getShapeFileInfos(setting.useshape.selectedLandgrenzen);
    setting.useshape.LangrenzenPath = shapefile;
    setting.useshape.name = shapename;
    setting.useshape.LangrenzenPath = fullfile(pwd,'shp',setting.useshape.LangrenzenPath);
end          

setting.textfile.folder = 'output'; setting.textfile.prefix = '';
setting.reportsPerPLZ.filenameout = 'makro_reports_PLZ.txt';
setting.reportsPerPLZRita.filenameout = 'makro_reports_PLZRita.txt';
setting.reportsEQfound.filenameout = 'makro_EQreports.txt';
setting.reportsDamageText.filenameout = 'makro_EQreports_DamageText.txt';
setting.reportsPerPLZEObjHumPerception.filenameout = 'makro_reports_PLZ_ObjHumPer.txt';
setting.sigEQsEvent.filenameout = 'significantEQs_event.txt';
setting.sigEQsManuell.filenameout = 'significantEQs_manuell.txt';
setting.sigEQsManuellTimespan.filenameout = 'significantEQs_manuell_timespan.txt';

setting.ems98.filenameout = 'makro_ems98_ObjHumPer.txt';
setting.ems98.code{1} = 'H';
setting.ems98.descript{1} = 'Obj: Hanging objects swing slightly';
setting.ems98.code{2} = 'I';
setting.ems98.descript{2} = 'Obj: Hanging objects swing, glasses, windows & doors rattle, light furniture shakes visibly';
setting.ems98.code{3} = 'J';
setting.ems98.descript{3} = 'Obj: Light furniture shakes visibly, woodwork creaks, liquids vibrate';

setting.ems98.code{4} = 'K';
setting.ems98.descript{4} = 'Obj: Lamps swing considerably, glasses clatter, windows & doors open and shut, light top heavy objects shift or fall, animals indoors may become uneasy, liquids oscillate annd may spill';
setting.ems98.code{5} = 'L';
setting.ems98.descript{5} = 'Obj: Window panes break';
setting.ems98.code{6} = 'M';
setting.ems98.descript{6} = 'Obj: Small objects may fall and furniture may be shifted (books, goods), animals may be frightened';

setting.ems98.code{7} = 'N';
setting.ems98.descript{7} = 'Obj: Dishes and glassware break';
setting.ems98.code{8} = 'O';
setting.ems98.descript{8} = 'Obj: Furniture is shifted, top heavy furniture may be overturned, objects fall from shelves, water splashes from containers, tanks and pools';
setting.ems98.code{9} = 'P';
setting.ems98.descript{9} = 'Obj: Heavy objects (furniture, TV) fall down, topple';

setting.ems98.code{10} = 'Q';
setting.ems98.descript{10} = 'Human percept: felt at rest, upper floors';
setting.ems98.code{11} = 'R';
setting.ems98.descript{11} = 'Human percept: felt at rest';
setting.ems98.code{12} = 'S';
setting.ems98.descript{12} = 'Human percept: indoors';

setting.ems98.code{13} = 'T';
setting.ems98.descript{13} = 'Human percept: slight trembling';
setting.ems98.code{14} = 'U';
setting.ems98.descript{14} = 'Human percept: awake';
setting.ems98.code{15} = 'V';
setting.ems98.descript{15} = 'Human percept: strong trembling';

setting.ems98.code{16} = 'W';
setting.ems98.descript{16} = 'Human percept: outdoors';
setting.ems98.code{17} = 'X';
setting.ems98.descript{17} = 'Human percept: frightened';
setting.ems98.code{18} = 'Y';
setting.ems98.descript{18} = 'Human percept: balance, upper floors';

setting.ems98.code{19} = 'Z';
setting.ems98.descript{19} = 'Human percept: balance';
setting.ems98.code{20} = 'dm';
setting.ems98.descript{20} = 'damages reported';
setting.ems98.code{21} = 'dg';
setting.ems98.descript{21} = 'damage grade (1-5)';

setting.ems98.code{22} = '00';
setting.ems98.descript{22} = 'Stockwerke:  bis 2';
setting.ems98.code{23} = '03';
setting.ems98.descript{23} = 'Stockwerke:  3 - 5';
setting.ems98.code{24} = '06';
setting.ems98.descript{24} = 'Stockwerke:  6 - 10';
setting.ems98.code{25} = '11';
setting.ems98.descript{25} = 'Stockwerke: 11 - 19';
setting.ems98.code{26} = '20';
setting.ems98.descript{26} = 'Stockwerke:   ab 20';

setting.ems98.code{27} = 'k';
setting.ems98.descript{27} = 'Geräusch: Knall';
setting.ems98.code{28} = 'g';
setting.ems98.descript{28} = 'Geräusch: Grollen';
setting.ems98.code{29} = 'r';
setting.ems98.descript{29} = 'Erschütterung: Ruck';
setting.ems98.code{30} = 's';
setting.ems98.descript{30} = 'Erschütterung: Schwanken';
setting.ems98.code{31} = 'z';
setting.ems98.descript{31} = 'Erschütterung: Zittern';



%// showSignificantEQsThisEvent
setting.showSignificantEQs.deltaB = 0.5376*2.2;    %60km = 0.5376° R>150 km no relationship with acceleration McGuire 1974
setting.showSignificantEQs.deltaL = 0.7973*2.2;    %60km = 0.7973°
setting.showSignificantEQs.minMag = 1.5;       %Magnitude Ml
setting.showSignificantEQs.showNevents = 40;   %displays after sort(intensity) N - Anzahl der stärksten Beben die geplottet werden
setting.showSignificantEQs.sortNevents = 'acc_Yan';  %sorts after 
%  'localintensity' 
%  'intensity'
%  'magnitude'
%  'acc_McGuire'
%  'acc_Yan'
setting.showSignificantEQs.bekanntecities = '/net/filer/export/arch2/gis/orte+grenzen/BekannteOrte';
setting.showSignificantEQs.alpha = 0.001;    %dämpfung - coefficient of absorbtion

%// show All Events for a City
setting.showAllEventsforaCity.europe_small_cities = '/net/filer/export/arch2/gis/orte+grenzen/europe_small_cities';

%// log(N/Jahr) statistics
setting.logNJahr.timestart = '_1900-01-01 00:00_';
setting.logNJahr.distmax = 50;
setting.logNJahr.Tiefemax = 25;
setting.logNJahr.Tiefemittel = 6;
setting.logNJahr.showlastnumbersofEQs = 3;
setting.logNJahr.minIntensityplot = 1;
setting.logNJahr.maxIntensityplot = 10;
setting.logNJahr.filenameout = 'significantEQs_frequency.txt';

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
setting.kml.reportsPerPLZ = 'makro_reports_PLZ.kml';
setting.kml.reportsPerPLZ_ObjHumPer = 'makro_reports_PLZ_ObjHumPer.kml';
setting.kml.reportsDamages = 'makro_reports_damages.kml';

