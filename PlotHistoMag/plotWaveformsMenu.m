function plotWaveformsMenu(setting)

%// plot waveforms: show one station and several events
if setting.waveforms.ploteventsperstation==1
    fprintf('Select the station \n');
    fprintf(' [1] CONA    [2] CSNA     [3] MOA      [4] KBA      [5] ARSA     [6] SOKA  \n');
    fprintf(' [7] OBKA    [8] MYKA     [9] ABTA    [10] RISI    [11] WTTA    [12] WATA  \n');
    fprintf('[13] SQTA   [14] MOTA    [15] FETA    [16] DAVA    [17] ROSI    [18] ABSI  \n');
    fprintf('[19] MARA   [20] PUBA    [21] GUWA    [22] SITA    [23] TU    [24] TU  \n');
    fprintf('[0] User specific input (e.g. SOP(BHZ), KRUC(HHZ)) \n');    
    inp = input('>> Please select the option [q..quit]\n','s');
    if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
        switch str2num(inp)
            case 0
                np2 = input('>> Please input a station name [q..quit]\n','s');
                if isnumeric(str2num(np2)) && ~strcmp(np2,'q')
                    setting.waveforms.station = np2;
                else
                    setting.waveforms.station = 'CONA';
                end
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
            case 19
                setting.waveforms.station = 'MARA';
            case 20
                setting.waveforms.station = 'PUBA'; 
            case 21
                setting.waveforms.station = 'GUWA';
            case 22
                setting.waveforms.station = 'SITA';   
            case 23
                setting.waveforms.station = 'TU';
            case 24
                setting.waveforms.station = 'TU';                 
        end
    end
    
    fprintf('Select the component\n');
    fprintf(' [1] only HHZ       [4] only HHN       [7] only HHE \n');
    fprintf(' [2] only HNZ       [5] only HNN       [8] only HHE \n');
    fprintf(' [3] only HLZ       [6] only HLN       [9] only HHE \n');    
    fprintf(' [10] HHZ/HHE/HHN     \n');
    fprintf(' [11] HNZ/HNE/HNN     \n');
    fprintf(' [12] HLZ/HLE/HLN     \n');
    fprintf(' [0] User specific input (e.g. SOP(BHZ), KRUC(HHZ)) \n');
    inp = input('>> Please select the option [q..quit]\n','s');
    if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
        switch str2num(inp)
            case 0
                np3 = input('>> Please input a component [q..quit]\n','s');
                if isnumeric(str2num(np3)) && ~strcmp(np3,'q')
                    setting.waveforms.comp{1} = np3;
                else
                    setting.waveforms.comp{1} = 'HHZ';
                end
            case 1
                setting.waveforms.comp{1} = 'HHZ'; 
            case 2
                setting.waveforms.comp{1} = 'HNZ'; 
            case 3
                setting.waveforms.comp{1} = 'HLZ';
            case 4
                setting.waveforms.comp{1} = 'HHN'; 
            case 5
                setting.waveforms.comp{1} = 'HNN'; 
            case 6
                setting.waveforms.comp{1} = 'HLN';   
            case 7
                setting.waveforms.comp{1} = 'HHE'; 
            case 8
                setting.waveforms.comp{1} = 'HNE'; 
            case 9
                setting.waveforms.comp{1} = 'HLE';                
            case 10
                setting.waveforms.comp{1} = 'HHZ'; setting.waveforms.comp{2} = 'HHN'; setting.waveforms.comp{3} = 'HHE';
            case 11
                setting.waveforms.comp{1} = 'HNZ'; setting.waveforms.comp{2} = 'HNN'; setting.waveforms.comp{3} = 'HNE';
            case 12
                setting.waveforms.comp{1} = 'HLZ'; setting.waveforms.comp{2} = 'HLN'; setting.waveforms.comp{3} = 'HLE';                
        end
    end
    
    %// get the data and plot the waveforms
    plotWaveformsPerStationDataPlot(setting)
end
