function showSingleStationData(setting)

% get calib from Antelope
%[setting] = getCalibFromAntelope(setting);

[dataV,dataA,setting,error] = getTracesfromAntelope(setting);
%[dataV,dataA,setting] = getRandomData(setting);

if error==0
    % remove data if no data is available
    [dataV,dataA,setting] = removeNaNDataorFillgaps(dataV,dataA,setting);
    
    % apply calib (if not done by TRC import)
    [dataV,dataA,setting] = applyCalibandSubtractMean(dataV,dataA,setting);
    
    % add artificial velocity or accelerometer data by int or diff
    [dataV,dataA,dataDout,setting] = getRemainingAccOrVeldata(dataV,dataA,setting);
    
    
    if setting.exportDataASCII == 0
        % get ABS (Vector-sum) for the initial unit
        ABS = getABSfromDataTRC(dataV,dataA,setting);
        
        % get Arias Intensity
        Arias = getAriasIntesity(dataA,setting);
        
        % get RMS
        RMSv = getRMS(dataV,dataA,setting);
        
        % get Autokorrelation
        Auto = getAutokorrelation(dataV,dataA,setting);
        
        plotWaveforms(dataV,dataA,ABS,Arias,setting);   %waveforms *Z *N *E
        plotDatawithABS(dataV,dataA,ABS,Arias,RMSv,setting);  %abs, arias intensity, ampl-spect, RMS
        
        inp = '9999';
        while strcmp(inp,'q') == 0
            inp = input('>> Do you want to show auto-correlation and polarization? [y/n] [q..quit]\n','s');
            if ~isnumeric(str2num(inp)) && ~strcmp(inp,'q') && ~strcmp(inp,'n')
                errorpol = plotDataPolarizedAuto(dataV,dataA,Auto,setting);  %Polarization, Autokorr
            else
                inp = 'q';
            end
        end
        
    else
        exportSingleData2ASCII(dataV,dataA,setting);
        plotWaveforms(dataV,dataA,[],[],setting);   %waveforms *Z *N *E
    end
else
    strstation = sprintf('%s',setting.station); 
    fprintf('[error]: No data retrieved from station %s. \n',strstation);
end