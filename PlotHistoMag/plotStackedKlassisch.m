function setting = plotStackedKlassisch(datastack,setting)
% data format:
%    date(datenum)  lat  lon  depth  mag
%valuebins = unique(datastack(:,1));
[zdatstring,interval] = getZDatestr(setting);

scrsz = get(0,'ScreenSize');
figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height]);
set(gcf,'Color','w');

subplot(setting.InfoPlot.subM,1,1:4);
bar(datastack,'stack');  hold on;
title(setting.title,'fontsize',setting.fontsizetitle);
xtickold = get(gca,'XTick'); ytickold = get(gca,'YTick');
[limit,xtickvallabel,xtickval] = getXticksXtickLabelsMag(datastack,setting,zdatstring,interval,xtickold);
xlim(limit.xlim); 
if setting.plotAutoscaleOn == 0
    ylim(limit.ylim );
end

xtickvallabel = transformTickEng2Ger(xtickvallabel,setting);
if setting.plot2ndPlotOnHistogramm.yesno == 1 
   set(gca,'Box','off','Color','white','XTick',[],'YTick',[]); 
end
set(gca,'YTick',ytickold,'YMinorTick','off','TickDir','in'); 
set(gca,'YAxisLocation','left','XTick',xtickval,'XMinorTick', 'off', 'TickDir','in');
set(gca,'XTickLabel',xtickvallabel,'fontsize',setting.fontsizeaxis);
ylabel(setting.labely,'fontsize',setting.fontsize);

% // plot the second plot
setting.h1 = gca;
if setting.plot2ndPlotOnHistogramm.yesno == 1
    [setting] = plotSecondPlot(setting);
end

% // plot the legend of the main plot
%legend(setting.h1,legstr{:},numel(setting.stacks));  