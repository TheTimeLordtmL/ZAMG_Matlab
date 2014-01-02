function setting = plotStackedMagHistogram(datastack,setting)
% plot stacked Magnitude or Intensity Values
% data format:
%    date(datenum)  lat  lon  depth  mag/int
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
  set(gca,'YTick',ytickold,'YMinorTick','off','TickDir','out'); 
end
set(gca,'YAxisLocation','left','XTick',xtickval,'XMinorTick', 'off', 'TickDir','out');
set(gca,'XTickLabel',xtickvallabel,'fontsize',setting.fontsizeaxis);
ylabel(setting.labely,'fontsize',setting.fontsize);

for g=1:numel(setting.stacks)
    alteMag = setting.stacks{g};
    if g >= numel(setting.stacks) && g ~= 1
        if setting.eqlist.useinensities == 1
            legstr{g} = sprintf(' I>%1.0f',alteMag);
        else
            legstr{g} = sprintf(' M>%1.0f',alteMag);
        end
    else
        neueMag = setting.stacks{g+1};
        if setting.eqlist.useinensities == 1
            legstr{g} = sprintf('%2.0f<I<%1.0f',alteMag,neueMag);
        else
            legstr{g} = sprintf('%2.0f<M<%1.0f',alteMag,neueMag);
        end
    end
    if setting.legend.setsmallMagZero == 1
        if g == 1
            neueMag = setting.stacks{g+1};
            if setting.eqlist.useinensities == 1
                legstr{g} = sprintf(' I<%1.0f',neueMag);
            else
                legstr{g} = sprintf(' M<%1.0f',neueMag);
            end
        end
    end
end

% // plot the second plot
setting.h1 = gca;
if setting.plot2ndPlotOnHistogramm.yesno == 1
    [setting] = plotSecondPlot(setting);
end

% // plot the legend of the main plot
legend(setting.h1,legstr{:},numel(setting.stacks));  


%fprintf('median: %g    max:  %g     ratio:%3.1f\n',median(n),max(n),max(n)/median(n));