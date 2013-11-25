
 function plotDatawithABS(dataV,dataA,ABS,Arias,RMSv,setting)
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
AriasData = Arias{1};    AriasVal = Arias{2};


% //figure 2
if setting.plot.specialplots1 == 1
    figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height],'Name',setting.plot.title);
    set(gcf,'Color','w');
    
    % plot the ABS - Vector Sum (unfiltered and filtered)
    subplot(3,1,1);
    xvec = 1:numel(ABS{1});
    plot(xvec,ABS{1},'Color',[0.88 0.88 0.88],'LineWidth',4); hold on;
    plot(xvec,ABS{2},'Color',[0.6 0.6 0.6],'LineWidth',1);
    legend('ABS','ABS filtered',2);
    ylabel(setting.ABS.plot.ycaption);   xlabel(setting.plot.xlabel1);
    axesub1h1 = gca;
    
    xtickold = get(axesub1h1,'XTick');   %values in samples
    for k=1:numel(xtickold)
        xtickvallabel{k} = sprintf('%6.1f',xtickold(k)/setting.samplerate{1});  %values in seconds
    end
    axesub1h2 = axes('Position',get(axesub1h1,'Position'),'XAxisLocation','top','Color','none');
    set(axesub1h2,'XTickLabel',xtickvallabel,'XTick',xtickold,'YTick',[]);
    set(axesub1h2,'XLim',get(axesub1h1,'XLim'));
    set(get(axesub1h2,'XLabel'),'String',setting.plot.xlabel2);
    axes(axesub1h1);
    
    % plot the Amplitude spectra for **Z  - data{1}
    curTrace = dataTRC{1};
    switch setting.filter.type
        case 'LP'       %low pass
            curTraceFilt = filterLowPass(curTrace,setting.samplerate{1},setting);
        case 'HP'       %high pass
            curTraceFilt = filterLowCutOff(curTrace,setting.samplerate{1},setting);
        case 'BP'       %band pass
            %emtyp
    end
    [sSigSpec,maxampl] = getSpectrumfromCurData(curTrace,setting.samplerate{1});
    [sSigSpecFilt,maxamplFilt] = getSpectrumfromCurData(curTraceFilt,setting.samplerate{1});
    subplot(3,1,2);
    loglog(sSigSpec.frequ(:),sSigSpec.fft(:),'Color',[0.88 0.88 0.88],'LineWidth',4); hold on;
    loglog(sSigSpecFilt.frequ(:),sSigSpecFilt.fft(:),'Color',[0.6 0.6 0.6],'LineWidth',1);
    legend(sprintf('Amp.specta - %s',setting.comp{1}),'Amp.specta - filtered',2);
    ylabel(setting.Spectra.plot.ycaption); xlabel(setting.Spectra.plot.xcaption);
    
    
    % plot the Arias Intensity
    subplot(3,1,3);
    xvec = 1:numel(AriasData{1});
    plot(xvec,AriasData{1},'Color',[0.6 0.6 0.6],'LineWidth',3); hold on;
    plot([AriasVal{1}.xvec AriasVal{1}.xvec],[AriasVal{1}.cur_max AriasVal{1}.cur_min],'Color',[0.6 0.6 0.6],'LineWidth',1.5);
    plot(xvec,AriasData{2},'Color',[1.0 0.6 0.6],'LineWidth',1); hold on;
    plot([AriasVal{2}.xvec AriasVal{2}.xvec],[AriasVal{2}.cur_max AriasVal{2}.cur_min],'Color',[1.0 0.6 0.6],'LineWidth',0.75);
    plot(xvec,AriasData{3},'Color',[0.6 0.6 1.0],'LineWidth',1); hold on;
    plot([AriasVal{3}.xvec AriasVal{3}.xvec],[AriasVal{3}.cur_max AriasVal{3}.cur_min],'Color',[0.6 0.6 1.0],'LineWidth',0.75);
    %plot(AriasVal{1}.xvec,AriasVal{1}.val,'o');
    %plot(AriasVal{2}.xvec,AriasVal{2}.val,'o');
    %plot(AriasVal{3}.xvec,AriasVal{3}.val,'o');
    legend(sprintf('%s filtered',setting.comp{1}),sprintf('%s filtered',setting.comp{2}),sprintf('%s filtered',setting.comp{3}),3);
    ylabel(setting.Arias.plot.ycaption);    xlabel(setting.plot.xlabel1);
    
    axesub3h1 = gca;
    
    xtickold = get(axesub3h1,'XTick');   %values in samples
    for k=1:numel(xtickold)
        xtickvallabel{k} = sprintf('%6.1f',xtickold(k)/setting.samplerate{1});  %values in seconds
    end
    axesub3h2 = axes('Position',get(axesub3h1,'Position'),'XAxisLocation','top','Color','none');
    set(axesub3h2,'XTickLabel',xtickvallabel,'XTick',xtickold,'YTick',[]);
    set(axesub3h2,'XLim',get(axesub3h1,'XLim'));
    set(get(axesub3h2,'XLabel'),'String',setting.plot.xlabel2);   
    axes(axesub3h1);   
end

fprintf('Arias Intensity (from Acceleration)\n');
fprintf('                       %s             %s             %s\n',setting.comp{1},setting.comp{2},setting.comp{3});
fprintf('@%2g%%   %s (ind)     %4.2f (%g)     %4.2f (%g)     %4.2f (%g)\n',setting.Arias.signalduration,'m/s',AriasVal{1}.val,AriasVal{1}.xvec,AriasVal{2}.val,AriasVal{2}.xvec,AriasVal{3}.val,AriasVal{3}.xvec);
disp(' ');
 
%display RMS values
fprintf('RMS value (from %s)\n',setting.unitstr);
fprintf('             %s         %s         %s\n',setting.comp{1},setting.comp{2},setting.comp{3});
fprintf('      %s   %4.2f        %4.2f        %4.2f \n',setting.unit.value,RMSv{1},RMSv{2},RMSv{3});
if strcmp(setting.unit.value,'cm/s²')==1
    fprintf('      (g)   %8.6f        %8.6f        %8.6f \n',RMSv{1}/981,RMSv{2}/981,RMSv{3}/981);
    fprintf('      m/s²   %6.5f        %6.5f        %6.5f \n',RMSv{1}/100,RMSv{2}/100,RMSv{3}/100);
else
    fprintf('      (g)   %8.6f        %8.6f        %8.6f \n',0,0,0);
    fprintf('      m/s²   %6.3f        %6.3f        %6.3f \n',0,0,0);
end

