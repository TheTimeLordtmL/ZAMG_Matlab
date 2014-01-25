function setting = getSettingsABS()
%// settings for showABSwaveforms.m

setting.db.calib = '/net/zagmac1/Volumes/Daten/seismo/antelope/db/zagmac1';
setting.evid = 52514440;   setting.pathDBinout = '/home/hausmann/PGA_dbwfmeas';
setting.plot.valmarker1 = 8; setting.plot.plotstatnames = 1; setting.showTools = 0;

setting.intitialunit = 'V';  %V..velocity  A..accelerometer
switch setting.intitialunit
    case 'V'
        setting.comp{1} = 'HHZ'; setting.comp{2} = 'HHN'; setting.comp{3} = 'HHE';
        %setting.comp{1} = 'BHZ'; setting.comp{2} = 'BHN'; setting.comp{3} = 'BHE';
        %setting.station = 'RISI';
        %setting.station = 'MOA';  %HH*
        setting.station = 'CONA';  %HH*
        %setting.station = 'KBA';  %HH*
        %setting.station = 'MYKA';  %HH*
        %setting.station = 'RETA';  %HH*
        %setting.station = 'BUD';  %BH*
    case 'A'
        setting.comp{1} = 'HNZ'; setting.comp{2} = 'HNN'; setting.comp{3} = 'HNE';
        %setting.station = 'CONA'; %HN*
         %setting.station = 'CSNA'; %HN*
         %setting.station = 'SOKA'; %HN*
         %setting.station = 'ABTA'; %HN*
         %setting.station = 'MYKA'; %HN*
         
         %setting.station = 'ABSI'; %HN* 
        % setting.station = 'WIWA'; %HN* 
         %setting.station = 'SNWA'; %HN* 
        % setting.station = 'KMWA'; %HN* 
        setting.station = 'SNWA'; %HN* 
        % setting.station = 'BGWA'; %HN* 
        %setting.station = 'KRUC'; %HN* 
        
        %setting.comp{1} = 'HLZ'; setting.comp{2} = 'HLN'; setting.comp{3} = 'HLE';
        %setting.station = 'DKSA';  %HL*
        %setting.station = 'OBKA';  %HL*
        %setting.station = 'RKSA'; %HL*
        %setting.station = 'ADSA'; %HL*
        %setting.station = 'RWNA'; %HL*
        %setting.station = 'RSNA'; %HL*
        %setting.station = 'KBA'; %HL*
        %setting.station = 'WTTA'; %HL*
        %setting.station = 'MORC'; %HL*
        %a=~/BITA|OBSA|SVKA|KEKA|ADSA|WOTA|RSNA|RWNA|LFVA|DFSA|DKSA|SVKA|SK
        %TA|SPTA|OBKA|KBA|WTTA/" HL
end
 
setting.calib{1} = 1.00; setting.calib{2} = 1.00; setting.calib{3} = 1.00;
setting.setting.sps{1} = 0; setting.setting.sps{2} = 0; setting.setting.sps{3} = 0;
setting.dbqueryStr1 = sprintf('%s:%s,%s:%s,%s:%s',setting.station,setting.comp{1},setting.station,setting.comp{2},setting.station,setting.comp{3});
%setting.time.start = '_2012-05-29 07:01:25_';setting.time.end='_2012-05-29 07:05:05_'; setting.nameevent='Emilia 2 2012';
%setting.time.start = '_2012-05-20 02:04:30_';  setting.time.end='_2012-05-20 02:08:20_'; setting.nameevent=' Emilia 1 2012';
%setting.time.start = '_2012-05-01 18:26:30_';  setting.time.end ='_2012-05-01 28:45:00_'; setting.nameevent='Ginzling Felssturz 2012';
%setting.time.start = '_2013-03-12 05:28:36_';  setting.time.end ='_2013-03-12 05:29:50_'; setting.nameevent='Bad Goisern sr M2.6 2013';
%setting.time.start = '_2013-03-13 11:20:55_';  setting.time.end ='_2013-03-13 11:22:00_'; setting.nameevent='Molln sm sr? M2.1 2013';
%setting.time.start = '_2013-03-14 11:16:30_';  setting.time.end ='_2013-03-14 11:18:00_'; setting.nameevent='Molln sm sr? M2.1 2013';
%setting.time.start = '_2012-03-22 22:53:15_';  setting.time.end ='_2012-03-22 22:54:45_'; setting.nameevent='Felssturz Alpltal';

setting.time.start = '_2013-10-20 14:33:07_';  setting.time.end ='_2013-10-20 14:34:02_'; setting.nameevent='Seebenstein';
%setting.time.start = '_2013-12-11 17:14:17_';  setting.time.end ='_2013-12-11 17:15:10_'; setting.nameevent='Wr. Neustadt';
%setting.time.start = '_2013-02-02 13:36:06_';  setting.time.end ='_2013-02-02 13:37:30_'; setting.nameevent='Bad Eisenkappel M4.4 2013_strong';
%setting.time.start = '_2013-02-02 13:35:25_';  setting.time.end ='_2013-02-02 13:37:25_'; setting.nameevent='Bad Eisenkappel M4.4 2013';
%setting.time.start = '_2013-06-05 18:45:40_';  setting.time.end ='_2013-06-05 18:49:00_'; setting.nameevent='HungARY 3.6';
%  setting.time.start = '_2013-10-02 17:17:39_';  setting.time.end ='_2013-10-02 17:18:30_'; setting.nameevent='Ebreichsdorf M4.2 20131002';
%setting.time.start = '_2013-09-20 02:06:35_';  setting.time.end ='_2013-09-20 02:07:40_'; setting.nameevent='Ebreichsdorf M4.3 20130920';
%setting.time.start = '_2013-01-25 07:14:41_';  setting.time.end ='_2013-01-25 07:15:15_'; setting.nameevent='Ebreichsdorf M4.3 20130920';
%setting.time.start = '_2012-08-25 12:47:00_';  setting.time.end ='_2012-08-25 12:47:53_'; setting.nameevent='Fliegerbombe 2012';

%setting.time.start = '_2012-12-06 19:22:02_';  setting.time.end =  '_2012-12-06 19:22:34_'; setting.nameevent='Testbeben Tirol';
%setting.time.start = '_2012-11-15 03:17:35_';  setting.time.end =  '_2012-11-15 03:18:10_'; setting.nameevent=' Pitten 2012';

if setting.intitialunit=='V'
    setting.intitialunitvalue = 'nm/s';
    setting.unit.factor = 10^7;
    setting.unit.value = 'cm/s';
end
if setting.intitialunit=='A'
    setting.intitialunitvalue = 'nm/s²'; 
    setting.unit.factor = 10^7;
    setting.unit.value = 'cm/s²';    
end

%// TWO STATION analysis
setting.showTwoStationData = 0;
setting.time.start1 = '_2013-09-20 02:06:32_';  setting.time.end1 ='_2013-09-20 02:07:32_'; setting.nameevent='Ebreichsdorf M4.3 20130920';
setting.intitialunit1 = setting.intitialunit;  
setting.unit.value1 = setting.unit.value;
setting.twostation.showdisplacement = 0;  %show waveforms in displacement
setting.comp1{1} = 'HHZ'; setting.comp1{2} = 'HHN'; setting.comp1{3} = 'HHE';
%setting.comp1{1} = 'HNZ'; setting.comp1{2} = 'HNN'; setting.comp1{3} = 'HNE';
%setting.comp1{1} = 'HLZ'; setting.comp1{2} = 'HLN'; setting.comp1{3} = 'HLE';
setting.station1 = 'CONA';  %HH*
%setting.station1 = 'WIWA'; %HN* 
%setting.comp1{1} = 'HNZ';

setting.time.start2 = '_2013-10-02 17:17:35_';  setting.time.end2 ='_2013-10-02 17:18:35_'; setting.nameevent='Ebreichsdorf M4.2 20131002';
setting.intitialunit2 = setting.intitialunit;  
setting.unit.value2 = setting.unit.value;
setting.comp2{1} = setting.comp1{1}; setting.comp2{2} = setting.comp1{2} ; setting.comp2{3} = setting.comp1{3};
%setting.comp2{1} = 'HNZ'; setting.comp2{2} = 'HNN'; setting.comp2{3} = 'HNE';
%setting.station2 = setting.station1;  %HH*
setting.station2 = 'CSNA'; %HN* 
%setting.comp2{1} = 'HNZ';

% plot waveforms (twoStationAnalyses)
setting.waveforms.evid1 = 52587546;  %ebr20130920= 52587546 (1215203); ebr20131002= 52588537 (1217191);
setting.waveforms.evid2 = 52588537;  %;
setting.DB.DBpath = '/net/zagmac1/Volumes/Daten/seismo/antelope/db/zagmac1'; %db to get evid, orid, etc.
setting.waveforms.P1 = 0; setting.waveforms.P2 = 0; % P-wave arrival time
setting.waveforms.S1 = 0; setting.waveforms.S2 = 0; % S-wave arrival time
setting.waveforms.t01 = 0; setting.waveforms.t02 = 0; % origin time
setting.waveforms.timespanfromtnull = 0;    %window size specified from tnull + timewindow
setting.waveforms.timespanfrompicks = 1;    %window size specified from picks-tmin + timewindow: only 1 works now!!!
setting.waveforms.timewindow = 15;          %time window (secs) e.g. 35, 15(cona,ebr) 25(arsa,ebr)  
setting.waveforms.tmin = 3;                 %time before picks (secs) (first arrival) - used to get data from db (this is  maximal time for noise, tnoisesubtract is subtracted) e.g. 3secs 
setting.waveforms.tnoisesubtract = 0.4;       %time (s) that is subtracted from p.onset to get the noise length.
setting.waveforms.tpwindowmax = 3;          %time (s) that is maximal used to get p-wave spectra
setting.waveforms.tswindowmax = 4;          %time (s) that is maximal used to get s-wave spectra
setting.waveforms.fixPSamplSpectra = 1;     %define if Ylimit is fixed for P- and S-spectra plot
setting.waveforms.useManualYlimit = 0;      %use manual vals for Y-axis (req. fixPSamplSpectra)
setting.waveforms.useManualXlimit = 0;      %use manual vals for X-axis (req. fixPSamplSpectra)
setting.waveforms.manualYlimit = [0.00001 1];   %[0.00001 1];(req. fixPSamplSpectra)
setting.waveforms.manualXlimit = [0.1 50];      %[0.1 50];(req. fixPSamplSpectra)
setting.waveforms.plotNoiseSpectra = 1;     %plot noise spectra?
setting.waveforms.plotSignalSpectraReducedByNoise = 0;     %reduce the noise from the signal spectra?
setting.waveforms.plotSizeLineSpectraSignal = 2.5;
setting.waveforms.plotSizeLineSpectraNoise = 0.5;
setting.waveforms.plotwaveforms = 1;        %plot the waveforms? (test extraction of psig,ssig,noise)
setting.waveforms.useDisplacement = 0;        %use Displacement instead of acc/velocity

%//ASCII import
setting.ASCII.intitialunit = 'g';  %g..9.81m/s²  V..velocity  A..accelerometer
setting.ASCII.filename = '20130202_133000_utc_short.txt';
%setting.ASCII.filename = '20130202_133000_utc.txt';

% // Filter
setting.filter.type = 'HP';  % LP, HP, BP
switch setting.filter.type
    case 'LP'       %low pass
        setting.filter.lowpassoffdisplace = 5; %low cut off filter for f<0.1 Hz; e.g. 5Hz
        setting.filter.numpolesdisplace = 4;  %number of poles for the filter
    case 'HP'       %high pass
        setting.filter.lowcutoffdisplace = 0.1; %low cut off filter for f<0.1 Hz; e.g. 0.25Hz
        setting.filter.numpolesdisplace = 4;  %number of poles for the filter       
    case 'BP'       %band pass
        
end

% // Export to ASCII
setting.exportASCII.filter = 0;   %1..use filter
setting.exportASCII.settingBatchfile = '/home/hausmann/Matlab/ABS_waveform/batchstation.pf';
setting.exportDataASCII = 0;  %either view the data or export as batch process - is set in getSettingsmenu.m automatically
setting.exportASCII.batchprocess = 0;

% // Plot options
setting.xticknumber = 9;   setting.fontsize = 17;  setting.fontsizeaxis = 16;  setting.fontsizetitle = 18;
setting.src.left = 5; setting.src.bottom = 5; setting.src.width = 1100; setting.src.height = 800;
setting.plot.waveforms = 1;
setting.plot.specialplots1 = 1;     %abs, arias intensity, ampl-spect
setting.plot.specialplots2 = 1;     %polarization, auto-correlation
setting.Spectra.plot.ycaption = 'Amplitude';
setting.Spectra.plot.xcaption = 'Frequency (Hz)';
setting.ABS.plot.ycaption = sprintf('Vector Sum (%s)',setting.unit.value);    %vector sum
setting.plot.title = sprintf('Station: %s   Start at %s   Event: %s',setting.station,setting.time.start,setting.nameevent);
setting.plot.xlabel1 = 'samples';
setting.plot.xlabel2 = 'seconds';

% // Arias Intensity
setting.Arias.gravity = 9.81; %m/s^2
setting.Arias.signalduration = 90; %90% the duration of signal above a certain threshold, usually 90 % of the signal’s energy
setting.Arias.plot.ycaption = 'Arias Intensity (m/s)';

% // Menu Settings
setting.showSingleStationData = 0;
setting.showEventAcceleration = 0;
setting.addFixStationsManually = 1;  %changes in 'getAmplitudeStationsManually.m'
setting.manuallStationsRecords = 0;
