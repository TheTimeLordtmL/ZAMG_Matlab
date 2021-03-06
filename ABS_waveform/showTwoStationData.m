function showTwoStationData(setting)
% // [3] Show two station analysis (use specific time frames)
%    compare two events

% get calib from Antelope
%[setting] = getCalibFromAntelope(setting);

%//DATA 1
setting = applyTempsettingsTwoStation(setting,1);
[dataV1,dataA1,setting,error] = getTracesfromAntelope(setting);

%//DATA 2
setting = applyTempsettingsTwoStation(setting,2);
[dataV2,dataA2,setting,error] = getTracesfromAntelope(setting);

if error==0
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
    
    % FOR each component
    for p=1:numel(setting.comp1)
        
        %//PLOT the amplitude spectra
        % plot V oder A as is from original data
        if setting.intitialunit == 'A'
            ylabeltmp = sprintf('%s',setting.unitstr);
            curTrace = dataA1{p};
            [sSigSpec1,maxampl1] = getSpectrumfromCurData(curTrace,setting.samplerate{p});
            curTrace = dataA2{p};
            [sSigSpec2,maxampl2] = getSpectrumfromCurData(curTrace,setting.samplerate{p});
        end
        if setting.intitialunit == 'V'
            ylabeltmp = sprintf('%s',setting.unitstr);
            curTrace = dataV1{p};
            [sSigSpec1,maxampl1] = getSpectrumfromCurData(curTrace,setting.samplerate{p});
            curTrace = dataV2{p};
            [sSigSpec2,maxampl2] = getSpectrumfromCurData(curTrace,setting.samplerate{p});
        end
        figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height],'Name','amplitude spectra');
        subplot(4,4,[1 2 5 6]);
        loglog(sSigSpec1.frequ(:),sSigSpec1.fft(:),'Color','blue','LineWidth',1);
        hold on;
        loglog(sSigSpec2.frequ(:),sSigSpec2.fft(:),'Color','red','LineWidth',1);
        grid on;
        xlim([1 50]);
        ylabel(ylabeltmp);    xlabel('frequency (Hz)');
        tmplabel{1} = sprintf('%s(%s) %s',setting.station1,setting.comp1{p},setting.time.start1);
        tmplabel{2} = sprintf('%s(%s) %s',setting.station2,setting.comp2{p},setting.time.start2);
        legend(tmplabel,numel(tmplabel));
        
        %plot displacement from integration
        ylabeltmp = sprintf('computed displacement from %s',setting.unitstr);
        curTrace = dataDout1{p};
        [dsSigSpec1,maxampl1] = getSpectrumfromCurData(curTrace,setting.samplerate{p});
        curTrace = dataDout2{p};
        [dsSigSpec2,maxampl2] = getSpectrumfromCurData(curTrace,setting.samplerate{p});
        subplot(4,4,[3 4 7 8]);
        loglog(dsSigSpec1.frequ(:),dsSigSpec1.fft(:),'Color','blue','LineWidth',1);
        hold on;
        loglog(dsSigSpec2.frequ(:),dsSigSpec2.fft(:),'Color','red','LineWidth',1);
        grid on;
        xlim([1 50]);
        ylabel(ylabeltmp);    xlabel('frequency (Hz)');
        legend(tmplabel,numel(tmplabel));
        
        
        %//plot the waveforms
        %figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height],'Name','waveforms');
        subplot(4,4,[9:12]);
        if setting.twostation.showdisplacement == 1
            atmp = [dataDout1{p};dataDout2{p}];
            tmpunitwf = 'cm';
            tmpunitwfval = 'D';
            curTrace = dataDout1{p};      xvec = 1:numel(curTrace);
            switch setting.filter.type
                case 'LP'       %low pass
                    curTraceFilt1 = filterLowPass(curTrace,setting.samplerate{p},setting);
                case 'HP'       %high pass
                    curTraceFilt1 = filterLowCutOff(curTrace,setting.samplerate{p},setting);
                case 'BP'       %band pass
                    %emtyp
            end
            plot(1:numel(curTraceFilt1),curTraceFilt1,'Color','blue','LineWidth',1); hold on;
        else
            if setting.intitialunit == 'A'
                atmp = [dataA1{p};dataA2{p}];
                curTrace = dataA1{p};      xvec = 1:numel(curTrace);
                switch setting.filter.type
                    case 'LP'       %low pass
                        curTraceFilt1 = filterLowPass(curTrace,setting.samplerate{p},setting);
                    case 'HP'       %high pass
                        curTraceFilt1 = filterLowCutOff(curTrace,setting.samplerate{p},setting);
                    case 'BP'       %band pass
                        %emtyp
                end
                plot(1:numel(curTraceFilt1),curTraceFilt1,'Color','blue','LineWidth',1);
            end
            if setting.intitialunit == 'V'
                atmp = [dataV1{p};dataV2{p}];
                curTrace = dataV1{p};      xvec = 1:numel(curTrace);
                switch setting.filter.type
                    case 'LP'       %low pass
                        curTraceFilt1 = filterLowPass(curTrace,setting.samplerate{p},setting);
                    case 'HP'       %high pass
                        curTraceFilt1 = filterLowCutOff(curTrace,setting.samplerate{p},setting);
                    case 'BP'       %band pass
                        %emtyp
                end                
                plot(1:numel(curTraceFilt1),curTraceFilt1,'Color','blue','LineWidth',1);
            end
            tmpunitwf = setting.intitialunit1;
            tmpunitwfval = setting.unit.value1;
        end
        ylim([min(atmp) max(atmp)]);
        legend(tmplabel{1},1);     ylabel(sprintf('%s (%s)',tmpunitwf,tmpunitwfval));
        
        subplot(4,4,[13:16]);
        if setting.twostation.showdisplacement == 1
            curTrace = dataDout2{p};      xvec = 1:numel(curTrace);
            switch setting.filter.type
                case 'LP'       %low pass
                    curTraceFilt2 = filterLowPass(curTrace,setting.samplerate{p},setting);
                case 'HP'       %high pass
                    curTraceFilt2 = filterLowCutOff(curTrace,setting.samplerate{p},setting);
                case 'BP'       %band pass
                    %emtyp
            end
            plot(1:numel(curTraceFilt2),curTraceFilt2,'Color','red','LineWidth',1);
        else
            if setting.intitialunit == 'A'
                curTrace = dataA2{p};      xvec = 1:numel(curTrace);
                switch setting.filter.type
                    case 'LP'       %low pass
                        curTraceFilt2 = filterLowPass(curTrace,setting.samplerate{p},setting);
                    case 'HP'       %high pass
                        curTraceFilt2 = filterLowCutOff(curTrace,setting.samplerate{p},setting);
                    case 'BP'       %band pass
                        %emtyp
                end
                plot(1:numel(curTraceFilt2),curTraceFilt2,'Color','blue','LineWidth',1); hold on;
            end
            if setting.intitialunit == 'V'
                curTrace = dataV2{p};      xvec = 1:numel(curTrace);
                switch setting.filter.type
                    case 'LP'       %low pass
                        curTraceFilt2 = filterLowPass(curTrace,setting.samplerate{p},setting);
                    case 'HP'       %high pass
                        curTraceFilt2 = filterLowCutOff(curTrace,setting.samplerate{p},setting);
                    case 'BP'       %band pass
                        %emtyp
                end                
                plot(1:numel(curTraceFilt2),curTraceFilt2,'Color','blue','LineWidth',1);
            end
            tmpunitwf = setting.intitialunit2;
            tmpunitwfval = setting.unit.value2;
        end
        ylim([min(atmp) max(atmp)]);
        legend(tmplabel{2},1);     ylabel(sprintf('%s (%s)',tmpunitwf,tmpunitwfval));
    end
    % FOR each component (ende)
    
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

