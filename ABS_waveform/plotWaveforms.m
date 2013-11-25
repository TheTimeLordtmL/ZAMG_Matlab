
function plotWaveforms(dataV,dataA,ABS,Arias,setting)
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

% // Figure 1
% Plot the waveforms (unfiltered and filtered)
if setting.plot.waveforms == 1
    figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height],'Name',setting.plot.title);
    set(gcf,'Color','w');
    for p=1:numel(setting.comp)
        ha(p) = subplot(3,1,p);
        curTrace = dataTRC{p};      xvec = 1:numel(curTrace);
        switch setting.filter.type
            case 'LP'       %low pass
                curTraceFilt = filterLowPass(curTrace,setting.samplerate{p},setting);
            case 'HP'       %high pass
                curTraceFilt = filterLowCutOff(curTrace,setting.samplerate{p},setting);
            case 'BP'       %band pass
              %emtyp  
        end
        
        if  setting.exportDataASCII==0 || (setting.exportDataASCII==1 && setting.exportASCII.filter==1)
            plot(xvec,curTrace,'Color',[0.88 0.88 0.88],'LineWidth',4); hold on;
            plot(xvec,curTraceFilt,'Color',[0.6 0.6 0.6],'LineWidth',1);
            legend(setting.comp{p},'filtered',2);
        else
            plot(xvec,curTrace,'Color',[0.6 0.6 0.6],'LineWidth',1);
            legend(setting.comp{p},1);
        end
        ylabel(sprintf('%s - %s',setting.unitstr,setting.comp{p}));
        xlabel(setting.plot.xlabel1);
        xlim([1 numel(curTrace)]);
        axesub1h1(p) = gca;
        
        xtickold = get(axesub1h1(p),'XTick');   %values in samples
        for k=1:numel(xtickold)
            xtickvallabel{k} = sprintf('%6.1f',xtickold(k)/setting.samplerate{1});  %values in seconds
        end
        axesub1h2(p) = axes('Position',get(axesub1h1(p),'Position'),'XAxisLocation','top','Color','none');
        set(axesub1h2(p),'XTickLabel',xtickvallabel,'XTick',xtickold,'YTick',[]);
        set(axesub1h2(p),'XLim',get(axesub1h1(p),'XLim'));
        set(get(axesub1h2(p),'XLabel'),'String',setting.plot.xlabel2);
        axes(axesub1h1(p));
    end
end
linkaxes(ha, 'x');

fprintf('Maximum Difference         %s             %s             %s\n',setting.comp{1},setting.comp{2},setting.comp{3});
fprintf('    %s         %12.2f      %12.2f      %12.2f \n',setting.unit.value,max(dataTRC{1})-min(dataTRC{1}),max(dataTRC{2})-min(dataTRC{2}),max(dataTRC{3})-min(dataTRC{3}));

