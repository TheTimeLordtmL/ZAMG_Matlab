function showABSwaveforms()
% read waveforms and plot abs trace for different filters
%  
setting = getSettingsABS();   setting = showInfos1(setting);

% (optional) add/fix values manually
if setting.addFixStationsManually == 1
    setting = getAmplitudeStationsManually(setting);
end

setting = getSettingsMenuABS(setting);

if setting.showSingleStationData == 1 || setting.showTwoStationData == 1 || setting.showTwoStationData == 2
    if setting.exportASCII.batchprocess == 0
        fprintf('[1] Import data from %s \n',setting.db.events);
        fprintf('[2] Import data from ASCII file %s \n',setting.ASCII.filename);
        fprintf('[q] Quit \n');
        inp = input('>> Please choose your selection [q..quit]\n','s');
        if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            switch str2num(inp)
                case 1
                    if setting.showSingleStationData == 1
                        showSingleStationData(setting);
                    else
                        if setting.showTwoStationData == 1
                            showTwoStationData(setting);
                        end
                        if setting.showTwoStationData == 2
                            showTwoStationData2New(setting);
                        end
                    end
                case 2
                    if setting.ASCII.intitialunit=='g'
                        setting.intitialunitvalue = 'g';
                        setting.unit.factor = 1/981;
                        setting.unit.value = 'cm/s�';
                        setting.intitialunit = 'A';
                    end
                    showSingleStationDataASCII(setting);
            end
        end
    end
    if setting.exportASCII.batchprocess == 1
        %read txt file
        [n,data] = importsettingbatch(setting);
        for k=1:n
            setting.intitialunit = data.typ{k};
            setting.comp{1} = data.comp1{k}; setting.comp{2} = data.comp2{k}; setting.comp{3} = data.comp2{k};
            setting.station = data.station{k};
            setting.plot.title = sprintf('Station: %s   Start at %s   Event: %s',setting.station,setting.time.start,setting.nameevent);
            showSingleStationData(setting)
        end
    end
end

% show the tools
if setting.showTools == 1
    fprintf('[1] get Orid from Evid (%s)\n',setting.db.events);
    fprintf('[2] empty \n');
    fprintf('[q] Quit \n');
    inp = input('>> Please choose your selection [q..quit]\n','s');
    if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
        switch str2num(inp)
            case 1
                evid = input('>> Please enter a number for evid [q..quit]\n','s');
                oridOut = getOridFromEvid(setting,str2num(evid));
                fprintf('The corresponding orid for evid=%10.0f is   %10.0f\n',str2num(evid),oridOut); 
            case 2
                % do nothing
        end
    end
    return;
end

if setting.showEventAcceleration == 1
    showEventAcceleration(setting)
end
    



function setting = showInfos1(setting)
if setting.intitialunit == 'V'
    setting.unitstr = sprintf('Velocity (%s)',setting.unit.value');
end
if setting.intitialunit == 'A'
    setting.unitstr = sprintf('Acceleration (%s)',setting.unit.value); 
end
fprintf('The data unit is set to %s\n',setting.unitstr);







 
