function plotWaveformsMenu(setting)

%// plot waveforms: show one station and several events
if setting.waveforms.ploteventsperstation==1
    fprintf('Select the station \n');
    fprintf(' [1] CONA    [2] CSNA     [3] MOA      [4] KBA      [5] ARSA     [6] SOKA  \n');
    fprintf(' [7] OBKA    [8] MYKA     [9] ABTA    [10] RISI    [11] WTTA    [12] WATA  \n');
    fprintf('[13] SQTA   [14] MOTA    [15] FETA    [16] DAVA    [17] ROSI    [18] ABSI  \n');
    fprintf('[0] empty \n');    
    inp = input('>> Please select the option [q..quit]\n','s');
    if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
        switch str2num(inp)
            case 1
                setting.waveforms.station = 'CONA';
            case 2
                setting.waveforms.station = 'CSNA';
            case 3
                setting.waveforms.station = 'MOA';
            case 4
                setting.waveforms.station = 'KBA';
            case 5
                setting.waveforms.station = 'ARSA';
            case 6
                setting.waveforms.station = 'SOKA';
            case 7
                setting.waveforms.station = 'OBKA';
            case 8
                setting.waveforms.station = 'MYKA';
            case 9
                setting.waveforms.station = 'ABTA';
            case 10
                setting.waveforms.station = 'RISI';
            case 11
                setting.waveforms.station = 'WTTA';
            case 12
                setting.waveforms.station = 'WATA';
            case 13
                setting.waveforms.station = 'SQTA';
            case 14
                setting.waveforms.station = 'MOTA';
            case 15
                setting.waveforms.station = 'FETA';
            case 16
                setting.waveforms.station = 'DAVA';
            case 17
                setting.waveforms.station = 'ROSI';
            case 18
                setting.waveforms.station = 'ABSI';
        end
    end
    
    fprintf('Select the component\n');
    fprintf(' [1] only HHZ     \n');
    fprintf(' [2] only HNZ     \n');
    fprintf(' [3] only HLZ     \n');    
    fprintf(' [4] HHZ/HHE/HHN     \n');
    fprintf(' [5] HNZ/HNE/HNN     \n');
    fprintf(' [6] HLZ/HLE/HLN     \n');
    fprintf(' [0] empty \n');
    inp = input('>> Please select the option [q..quit]\n','s');
    if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
        switch str2num(inp)
            case 1
                setting.waveforms.comp{1} = 'HHZ'; 
            case 2
                setting.waveforms.comp{1} = 'HNZ'; 
            case 3
                setting.waveforms.comp{1} = 'HLZ';
            case 4
                setting.waveforms.comp{1} = 'HHZ'; setting.waveforms.comp{2} = 'HHN'; setting.waveforms.comp{3} = 'HHE';
            case 5
                setting.waveforms.comp{1} = 'HNZ'; setting.waveforms.comp{2} = 'HNN'; setting.waveforms.comp{3} = 'HNE';
            case 6
                setting.waveforms.comp{1} = 'HLZ'; setting.waveforms.comp{2} = 'HLN'; setting.waveforms.comp{3} = 'HLE';                
        end
    end
    
    %// get the data and plot the waveforms
    plotWaveformsPerStationDataPlot(setting)
end
