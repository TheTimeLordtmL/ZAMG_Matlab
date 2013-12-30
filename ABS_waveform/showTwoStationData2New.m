function showTwoStationData2New(setting)
% // [4] Show two station analysis (use picks from DB)
%    compare two events, show P- und S-wave spectra with noise spectra

% get calib from Antelope
%[setting] = getCalibFromAntelope(setting);

%// get the origin time t0
% get begin/end for the timestring: eg. '_2013-09-20 02:06:35_';
% setting.saveDBmode = 1; aus PlotHistMag.m
setting.waveforms.orid1 = getOridFromEvid(setting,setting.waveforms.evid1);
setting.waveforms.orid2 = getOridFromEvid(setting,setting.waveforms.evid2);  

%// get the start/end time for the data
%//DATA 1 & event 1
[timestart,timeend,picktime] = getStartEndTimeFromPhases(setting,setting.waveforms.orid1,setting.station1,'P');
setting.waveforms.P1 = picktime; 
setting.time.start1 = timestart;   setting.time.end1 = timeend;
[timestart,timeend,picktime] = getStartEndTimeFromPhases(setting,setting.waveforms.orid1,setting.station1,'S');
setting.waveforms.S1 = picktime; 
setting = applyTempsettingsTwoStation(setting,1);
[dataV1,dataA1,setting,error1] = getTracesfromAntelope(setting);

%//DATA 2 & event 2
[timestart,timeend,picktime] = getStartEndTimeFromPhases(setting,setting.waveforms.orid2,setting.station2,'P');
setting.waveforms.P2 = picktime; 
setting.time.start2 = timestart;   setting.time.end2 = timeend;
[timestart,timeend,picktime] = getStartEndTimeFromPhases(setting,setting.waveforms.orid2,setting.station2,'S');
setting.waveforms.S2 = picktime;
setting = applyTempsettingsTwoStation(setting,2);
[dataV2,dataA2,setting,error2] = getTracesfromAntelope(setting);

[setting] = getPhaseUnixsecsAndSamplesFromPicks(setting);

if error1==0 && error2==0
    %//DATA 1
    setting = applyTempsettingsTwoStation(setting,1);
    % remove data if no data is available
    [dataV1,dataA1,setting] = removeNaNDataorFillgaps(dataV1,dataA1,setting);
    
    % apply calib (if not done by TRC import)
    [dataV1,dataA1,setting] = applyCalibandSubtractMean(dataV1,dataA1,setting);
    
    % add artificial velocity or accelerometer data by int or diff
    [dataV1,dataA1,dataDout1,setting] = getRemainingAccOrVeldata(dataV1,dataA1,setting);
    
    %//DATA 2
    setting = applyTempsettingsTwoStation(setting,2);
     % remove data if no data is available
    [dataV2,dataA2,setting] = removeNaNDataorFillgaps(dataV2,dataA2,setting);
    
    % apply calib (if not done by TRC import)
    [dataV2,dataA2,setting] = applyCalibandSubtractMean(dataV2,dataA2,setting);
    
    % add artificial velocity or accelerometer data by int or diff
    [dataV2,dataA2,dataDout2,setting] = getRemainingAccOrVeldata(dataV2,dataA2,setting);
    
    if setting.intitialunit1=='A' && setting.intitialunit2=='A'
        if setting.intitialunit~='A'
            fprintf('[warning] initial unit set to ''A''.]\n');
            setting.intitialunit = 'A';
        end
    else
        if setting.intitialunit1=='V' && setting.intitialunit2=='V'
            if setting.intitialunit~='V'
                fprintf('[warning] initial unit set to ''V''.]\n');
                setting.intitialunit = 'V';
            else
                fprintf('[warning] initial unit not clear (the same) for 1st and 2nd station (1=%s, 2=%s).]\n',setting.intitialunit1,setting.intitialunit2);
                fprintf('[warning] initial unit set to ''V''.]\n');
                setting.intitialunit = 'V';
            end
        end
    end
    if numel(setting.comp1) ~= numel(setting.comp2)
       fprintf('[warning] number of compontents vary (setting.comp1 vs. setting.comp2)\n'); 
    end
    
    % // get displacement,velocity, acceleration data
    % FOR each component
    for p=1:numel(setting.comp1)
        % get V oder A as is from original data
        if setting.intitialunit == 'A'
            ppicksamp = setting.waveforms.timecuts.psamples1; spicksamp = setting.waveforms.timecuts.ssamples1;
            curTrace = dataA1{p}; [psig1{p},ssig1{p},noise1{p}] = getPSnoiseDataFromTimeFrame(curTrace,setting,setting.samplerate{p},ppicksamp,spicksamp);
            [pSigSpec1{p},maxampl1{p}] = getSpectrumfromCurData(psig1{p},setting.samplerate{p});
            [sSigSpec1{p},maxampl1{p}] = getSpectrumfromCurData(ssig1{p},setting.samplerate{p});
            [noiseSigSpec1{p},maxampl1{p}] = getSpectrumfromCurData(noise1{p},setting.samplerate{p});
            
            ppicksamp = setting.waveforms.timecuts.psamples2; spicksamp = setting.waveforms.timecuts.ssamples2;
            curTrace = dataA2{p}; [psig2{p},ssig2{p},noise2{p}] = getPSnoiseDataFromTimeFrame(curTrace,setting,setting.samplerate{p},ppicksamp,spicksamp);
            [pSigSpec2{p},maxampl2{p}] = getSpectrumfromCurData(psig2{p},setting.samplerate{p});
            [sSigSpec2{p},maxampl2{p}] = getSpectrumfromCurData(ssig2{p},setting.samplerate{p});
            [noiseSigSpec2{p},maxampl2{p}] = getSpectrumfromCurData(noise2{p},setting.samplerate{p});
        end
        if setting.intitialunit == 'V'
            ppicksamp = setting.waveforms.timecuts.psamples1; spicksamp = setting.waveforms.timecuts.ssamples1;
            curTrace = dataV1{p}; [psig,ssig,noise] = getPSnoiseDataFromTimeFrame(curTrace,setting,setting.samplerate{p},ppicksamp,spicksamp);
            [pSigSpec1{p},maxampl1{p}] = getSpectrumfromCurData(psig,setting.samplerate{p});
            [sSigSpec1{p},maxampl1{p}] = getSpectrumfromCurData(ssig,setting.samplerate{p});
            [noiseSigSpec1{p},maxampl1{p}] = getSpectrumfromCurData(noise,setting.samplerate{p});
            
            ppicksamp = setting.waveforms.timecuts.psamples2; spicksamp = setting.waveforms.timecuts.ssamples2;
            curTrace = dataV2{p};  [psig,ssig,noise] = getPSnoiseDataFromTimeFrame(curTrace,setting,setting.samplerate{p},ppicksamp,spicksamp);
            [pSigSpec2{p},maxampl2{p}] = getSpectrumfromCurData(psig,setting.samplerate{p});
            [sSigSpec2{p},maxampl2{p}] = getSpectrumfromCurData(ssig,setting.samplerate{p});
            [noiseSigSpec2{p},maxampl2{p}] = getSpectrumfromCurData(noise,setting.samplerate{p});
        end
    
        %get displacement spectra from integration
        if setting.waveforms.useDisplacement == 1
            ppicksamp = setting.waveforms.timecuts.psamples1; spicksamp = setting.waveforms.timecuts.ssamples1;
            curTrace = dataDout1{p};  [psig1disp{p},ssig1disp{p},noise1disp{p}] = getPSnoiseDataFromTimeFrame(curTrace,setting,setting.samplerate{p},ppicksamp,spicksamp);
            [dspSigSpec1{p},maxampld1{p}] = getSpectrumfromCurData(psig1disp{p},setting.samplerate{p});
            [dssSigSpec1{p},maxampld1{p}] = getSpectrumfromCurData(ssig1disp{p},setting.samplerate{p});
            [dsnoiseSigSpec1{p},maxampld1{p}] = getSpectrumfromCurData(noise1disp{p},setting.samplerate{p});
            
            ppicksamp = setting.waveforms.timecuts.psamples2; spicksamp = setting.waveforms.timecuts.ssamples2;
            curTrace = dataDout2{p}; [psig2disp{p},ssig2disp{p},noise2disp{p}] = getPSnoiseDataFromTimeFrame(curTrace,setting,setting.samplerate{p},ppicksamp,spicksamp);
            [dspSigSpec2{p},maxampld2{p}] = getSpectrumfromCurData(psig2disp{p},setting.samplerate{p});
            [dssSigSpec2{p},maxampld2{p}] = getSpectrumfromCurData(ssig2disp{p},setting.samplerate{p});
            [dsnoiseSigSpec2{p},maxampld2{p}] = getSpectrumfromCurData(noise2disp{p},setting.samplerate{p});
        end
     end
    % FOR each component (ende)
    
    % PLOT waveforms (if specified)
    if setting.waveforms.plotwaveforms == 1
        if setting.waveforms.useDisplacement == 0
            if setting.intitialunit == 'V'
                plotTwoStationWaveformsPsigSsigNoise(psig1,ssig1,noise1,psig2,ssig2,noise2,dataV1,dataV2,setting);                
            end
            if setting.intitialunit == 'A'
                plotTwoStationWaveformsPsigSsigNoise(psig1,ssig1,noise1,psig2,ssig2,noise2,dataA1,dataA2,setting);
            end
        end
        if setting.waveforms.useDisplacement == 1
            plotTwoStationWaveformsPsigSsigNoise(psig1disp,ssig1disp,noise1disp,psig2disp,ssig2disp,noise2disp,dataDout1,dataDout2,setting);
        end
    end
    
    % prepare spectren for Z- and NE-Components
    if setting.waveforms.useDisplacement == 0
        %pSigSpec1,sSigSpec1,noiseSigSpec1,pSigSpec2,sSigSpec2,noiseSigSpec2
        [specvec1,specvec2,pspectra1,pspectra2,sspectra1,sspectra2,znoisespectra1,znoisespectra2,horznoisespectra1,horznoisespectra2] = prepareSpectraTwoStationsNew(pSigSpec1,sSigSpec1,noiseSigSpec1,pSigSpec2,sSigSpec2,noiseSigSpec2,setting);
    end
    if setting.waveforms.useDisplacement == 1
        %dspSigSpec1,dssSigSpec1,dsnoiseSigSpec1,
        [specvec1,specvec2,pspectra1,pspectra2,sspectra1,sspectra2,znoisespectra1,znoisespectra2,horznoisespectra1,horznoisespectra2] = prepareSpectraTwoStationsNew(dspSigSpec1,dssSigSpec1,dsnoiseSigSpec1,dspSigSpec2,dssSigSpec2,dsnoiseSigSpec2,setting);
    end
    
    % PLOT the spectren
    plotTwoStationSpectraNew(specvec1,specvec2,pspectra1,pspectra2,sspectra1,sspectra2,znoisespectra1,znoisespectra2,horznoisespectra1,horznoisespectra2,setting);
    
    
    if setting.exportDataASCII == 0
        %plotWaveforms(dataV,dataA,ABS,Arias,setting);   %waveforms *Z *N *E
        %plotDatawithABS(dataV,dataA,ABS,Arias,RMSv,setting);  %abs, arias intensity, ampl-spect, RMS
    else
        %exportSingleData2ASCII(dataV,dataA,setting);
        %plotWaveforms(dataV,dataA,[],[],setting);   %waveforms *Z *N *E
    end
else
    strstation = sprintf('%s',setting.station); 
    fprintf('[error]: No data retrieved from station %s. \n',strstation);
end



function setting = applyTempsettingsTwoStation(setting,flag)
% write one of the two stations to the global setting variable

setting.comp = [];
switch flag
    case 1
        for k=1:numel(setting.comp1)
            setting.comp{k} =  setting.comp1{k};
        end
        setting.intitialunit = setting.intitialunit1;
        setting.station = setting.station1;
        setting.time.start = setting.time.start1;
        setting.time.end = setting.time.end1;
    case 2
        for k=1:numel(setting.comp2)
            setting.comp{k} =  setting.comp2{k};
        end
        setting.intitialunit = setting.intitialunit2;
        setting.station = setting.station2;
        setting.time.start = setting.time.start2;
        setting.time.end = setting.time.end2;
end


function [timestart,timeend,evtime] = getStartEndTimeFromPhases(setting,orid,station,phase)
% use the orid to find the phases. based on the arrivals select the data

setting.waveforms.station = station;

data(1,1) = 9999999;   %date-time
data(1,2) = 9.9; %lat
data(1,3) = 99.9; %lon
data(1,4) = 0;  %ml
data(1,5) = orid;   %orid
data(1,6) = 0; %depth
data(1,7) = 1; %inull

% if setting.waveforms.timespanfromtnull == 1
%     fprintf('get the origin time(s) t0  \n');
%     [evtime,evtimestr,evid] = getEventOriginTime(data,setting);
%     [cellstrEnd,cellstrBegin] = getBeginEndTimeFromTzero(evtime,evtimestr,setting);
% end
if setting.waveforms.timespanfrompicks == 1
    fprintf('get the phase onset times for the first arrival(s) \n');
    switch phase
        case 'P'
            [evtime,evtimestr,evid] = getFirstArrival(data,setting);
        case 'S'
            [evtime,evtimestr,evid] = getShearwaveArrival(data,setting);  
    end
    [cellstrEnd,cellstrBegin] = getBeginEndTimeFromPicks(evtime,evtimestr,setting);
end
timestart = cellstrBegin{1};
timeend = cellstrEnd{1};
fprintf('[Time] Begin/End time is defined by from p-wave onset, noise length (tmin) and p-wave onset-tmin+timewindow \n');
fprintf('       Begin: %s  End: %s \n',timestart,timeend);


