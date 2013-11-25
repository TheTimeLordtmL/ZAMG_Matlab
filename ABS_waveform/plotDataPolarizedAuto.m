function error = plotDataPolarizedAuto(dataV,dataA,Auto,setting)
    
error = 0;
if setting.intitialunit == 'V'
    for p=1:numel(setting.comp)
        dataTRC{p} = dataV{p};
    end
end
if setting.intitialunit == 'A'
    for p=1:numel(setting.comp)
        dataTRC{p} = dataA{p};
    end
end
AutoData = Auto{1};
AutoMaxVal  =Auto{2};

% // plot figure 3
if setting.plot.specialplots2 == 1 
    %get index limits for xvec for polarisation
    inp = input('>> Please enter x_beginn for the polarization: [q..quit]\n','s');
    if strcmp(inp,'q')
        fprintf('[input]  quit the sub plotDataPolarizedAuto \n');
        error = 1;
        return;
    end  
    if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
        xvec_start = str2num(inp);    
    end
    inp = input('>> Please enter x_end for the polarization: [q..quit]\n','s');
    if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
        xvec_end = str2num(inp);
    else
        if strcmp(inp,'q')
            fprintf('[input]  quit the sub plotDataPolarizedAuto \n');
            error = 1;
            return;
        end
    end
    if xvec_start >= xvec_end
       fprintf('[warning] xvec_end must be smaller as xvec_start!\n'); 
    end
    if xvec_start > numel(dataTRC{1}) || xvec_end > numel(dataTRC{1})
       fprintf('[warning] xvec_end and xvec_start must be smaller as the nsamp=%g !\n',numel(dataTRC{1})); 
    end    
    if error == 0
        figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height],'Name',setting.plot.title);
        set(gcf,'Color','w');
        % // plot the polarization
        dataPolarization{1} = dataTRC{1}(xvec_start:xvec_end);
        dataPolarization{2} = dataTRC{2}(xvec_start:xvec_end);
        dataPolarization{3} = dataTRC{3}(xvec_start:xvec_end);
        switch setting.filter.type
            case 'LP'       %low pass
                dataPolarizationFilt{1} = filterLowPass(dataPolarization{1},setting.samplerate{1},setting);
                dataPolarizationFilt{2} = filterLowPass(dataPolarization{2},setting.samplerate{2},setting);
                dataPolarizationFilt{3} = filterLowPass(dataPolarization{3},setting.samplerate{3},setting);
            case 'HP'       %high pass
                dataPolarizationFilt{1} = filterLowCutOff(dataPolarization{1},setting.samplerate{1},setting);
                dataPolarizationFilt{2} = filterLowCutOff(dataPolarization{2},setting.samplerate{2},setting);
                dataPolarizationFilt{3} = filterLowCutOff(dataPolarization{3},setting.samplerate{3},setting);
            case 'BP'       %band pass
                %emtyp
        end
        % plot comp{1}..Z & comp{2}..N
        subplot(2,3,1);
        plot(dataPolarization{2},dataPolarization{1},'Color',[0.88 0.88 0.88],'LineWidth',4); hold on;
        plot(dataPolarizationFilt{2},dataPolarizationFilt{1},'Color',[0.6 0.6 0.6],'LineWidth',1); 
        legend(sprintf('%s - %s|%s - %s Filt',setting.comp{1},setting.comp{2},setting.comp{1},setting.comp{2}),1);
        
        % plot comp{1}..Z & comp{3}..E
        subplot(2,3,2);
        plot(dataPolarization{3},dataPolarization{1},'Color',[0.88 0.88 0.88],'LineWidth',4); hold on;
        plot(dataPolarizationFilt{3},dataPolarizationFilt{1},'Color',[0.6 0.6 0.6],'LineWidth',1);
        legend(sprintf('%s - %s|%s - %s Filt',setting.comp{1},setting.comp{3},setting.comp{1},setting.comp{3}),1);
        
        % plot comp{2}..N & comp{3}..E
        subplot(2,3,3);
        plot(dataPolarization{3},dataPolarization{2},'Color',[0.88 0.88 0.88],'LineWidth',4); hold on;
        plot(dataPolarizationFilt{3},dataPolarizationFilt{2},'Color',[0.6 0.6 0.6],'LineWidth',1); 
        legend(sprintf('%s - %s|%s - %s Filt',setting.comp{2},setting.comp{3},setting.comp{2},setting.comp{3}),1);
        
        % plot autocorrelation comp{1}..Z
        xvec = 1:numel(AutoData{1});    xanz60 = fix(numel(AutoData{1})*0.6);
        ind_start = fix((numel(AutoData{1}) - xanz60)/2) + 1;
        ind_end = numel(AutoData{1}) - fix((numel(AutoData{1}) - xanz60)/2);
        xvec60 = xvec(ind_start:ind_end);  %plot 60% of xvector
        subplot(2,3,4);
        plot(xvec60,AutoData{1}(ind_start:ind_end),'Color',[0.6 0.6 0.6],'LineWidth',1); hold on;
        legend(sprintf('%s',setting.comp{1}),1);
        xlim([ind_start ind_end]);  ylim([-100 100]);
        ylabel(setting.ABS.plot.ycaption);   xlabel(setting.plot.xlabel1);
        axesub1h1 = gca;
        
        xtickold = get(axesub1h1,'XTick');   %values in samples
        for k=1:numel(xtickold)
            xtickvallabel{k} = sprintf('%6.1f',xtickold(k)/setting.samplerate{1});  %values in seconds
        end
        axesub1h2 = axes('Position',get(axesub1h1,'Position'),'XAxisLocation','top','Color','none');
        set(axesub1h2,'XTickLabel',xtickvallabel,'XTick',xtickold,'YTick',[]);
        set(axesub1h2,'XLim',get(axesub1h1,'XLim'));
        set(axesub1h2,'XMinorTick','on');
        set(get(axesub1h2,'XLabel'),'String',setting.plot.xlabel2);
        axes(axesub1h1);
        
        % plot autocorrelation comp{2}..N
        subplot(2,3,5);
        plot(xvec60,AutoData{2}(ind_start:ind_end),'Color',[1.0 0.6 0.6],'LineWidth',1); hold on;
        legend(sprintf('%s',setting.comp{2}),1);
        xlim([ind_start ind_end]);  ylim([-100 100]);
        ylabel(setting.ABS.plot.ycaption);   xlabel(setting.plot.xlabel1);
        axesub2h1 = gca;
        
        xtickold = get(axesub2h1,'XTick');   %values in samples
        for k=1:numel(xtickold)
            xtickvallabel{k} = sprintf('%6.1f',xtickold(k)/setting.samplerate{1});  %values in seconds
        end
        axesub2h2 = axes('Position',get(axesub2h1,'Position'),'XAxisLocation','top','Color','none');
        set(axesub2h2,'XTickLabel',xtickvallabel,'XTick',xtickold,'YTick',[]);
        set(axesub2h2,'XLim',get(axesub2h1,'XLim'));
        set(axesub2h2,'XMinorTick','on');
        set(get(axesub2h2,'XLabel'),'String',setting.plot.xlabel2);
        axes(axesub2h1);
        
        % plot autocorrelation comp{3}..E
        subplot(2,3,6);
        plot(xvec60,AutoData{3}(ind_start:ind_end),'Color',[0.6 0.6 1.0],'LineWidth',1); hold on;
        xlim([ind_start ind_end]);  ylim([-100 100]);
        ylabel(setting.ABS.plot.ycaption);   xlabel(setting.plot.xlabel1);
        axesub3h1 = gca;
        
        xtickold = get(axesub3h1,'XTick');   %values in samples
        for k=1:numel(xtickold)
            xtickvallabel{k} = sprintf('%6.1f',xtickold(k)/setting.samplerate{1});  %values in seconds
        end
        axesub3h2 = axes('Position',get(axesub3h1,'Position'),'XAxisLocation','top','Color','none');
        set(axesub3h2,'XTickLabel',xtickvallabel,'XTick',xtickold,'YTick',[]);
        set(axesub3h2,'XLim',get(axesub3h1,'XLim'));
        set(axesub3h2,'XMinorTick','on');
        set(get(axesub3h2,'XLabel'),'String',setting.plot.xlabel2);
        axes(axesub3h1);
    end
end

if error == 0
    %display Autocorrelation values
    fprintf('Autocorrelation (from %s)\n',setting.unitstr);
    fprintf(' maxvalue = %10.0f  -  the plot displays only 60%% of the xvector (%g)\n',AutoMaxVal,numel(AutoData{1}));
    
    % // plot figure 4
    if setting.plot.specialplots2 == 1
        figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height],'Name',setting.plot.title);
        set(gcf,'Color','w');
        subplot(2,1,1);
        
        % plot the Amplitude spectra from the auto-correlation comp{1}..Z
        [AutoSpec1,maxamplauto1] = getSpectrumfromCurData(AutoData{1}(ind_start:ind_end),setting.samplerate{1});
        loglog(AutoSpec1.frequ(:),AutoSpec1.fft(:),'Color',[0.6 0.6 0.6],'LineWidth',1); hold on;
        ylabel(setting.Spectra.plot.ycaption); xlabel(setting.Spectra.plot.xcaption);
        
        % plot the Amplitude spectra from the auto-correlation comp{2}..N
        [AutoSpec2,maxamplauto2] = getSpectrumfromCurData(AutoData{2}(ind_start:ind_end),setting.samplerate{2});
        loglog(AutoSpec2.frequ(:),AutoSpec2.fft(:),'Color',[1.0 0.6 0.6],'LineWidth',1);
        
        % plot the Amplitude spectra from the auto-correlation comp{3}..E
        [AutoSpec3,maxamplauto3] = getSpectrumfromCurData(AutoData{3}(ind_start:ind_end),setting.samplerate{3});
        loglog(AutoSpec3.frequ(:),AutoSpec3.fft(:),'Color',[0.6 0.6 1.0],'LineWidth',1);
      
        
        % plot the Amplitude spectra from the polarization window comp{1}..Z
        [PolSpec1,maxamplpol1] = getSpectrumfromCurData(dataPolarizationFilt{1},setting.samplerate{1});
        loglog(PolSpec1.frequ(:),PolSpec1.fft(:),'Color',[0.2 0.6 0.6],'LineWidth',0.5); hold on;
        
        % plot the Amplitude spectra from the polarization window comp{2}..N
        [PolSpec2,maxamplpol2] = getSpectrumfromCurData(dataPolarizationFilt{2},setting.samplerate{2});
        loglog(PolSpec2.frequ(:),PolSpec2.fft(:),'Color',[0.6 0.6 0.6],'LineWidth',0.5);
      
        % plot the Amplitude spectra from the polarization window comp{3}..E
        [PolSpec3,maxamplpol3] = getSpectrumfromCurData(dataPolarizationFilt{3},setting.samplerate{3});
        loglog(PolSpec3.frequ(:),PolSpec3.fft(:),'Color',[0.2 0.6 1.0],'LineWidth',0.5);
        
        tmpcell = setting.comp;
        tmpcell{4} = sprintf('%s pol',setting.comp{1});
        tmpcell{5} = sprintf('%s pol',setting.comp{2});
        tmpcell{6} = sprintf('%s pol',setting.comp{3});
        legend(tmpcell,6);
        
        
        % plot3d polarization
        subplot(2,1,2);
        %plot3(dataPolarization{1},dataPolarization{2},dataPolarization{3},'Color',[0.88 0.88 0.88],'LineWidth',4); hold on;
        plot3(dataPolarizationFilt{1},dataPolarizationFilt{2},dataPolarizationFilt{3},'Color',[0.6 0.6 0.6],'LineWidth',1);
        grid on;
        axis square;
        rotate3d on;
    end
end
        



disp('');

