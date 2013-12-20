function [setting] = plotSecondPlot(setting)

if setting.temporalresolution=='j'
    xtickval = 1:size(setting.xlabelname,1);
    z = 0;
    for p=1:size(setting.xlabelname,1)
         z = z + 1;
        valuenum = datenum(setting.xlabelname(p,:),'yyyy');
        xtickvallabel{z} = datestr(valuenum,'yyyy');
    end
    xmin = 0;  xmax = numel(xtickvallabel)+1;
end
if setting.temporalresolution=='m'
    xtickval = xtickold;
    for p=1:size(setting.xlabelname,1)
        valuenum = datenum(setting.xlabelname(p,:),'mm/yyyy');
        xtickvallabel{p} = datestr(valuenum,'mmm');
    end
    xmin = 0;  xmax = numel(xtickvallabel,1)+1;
end
if setting.temporalresolution=='h' || setting.temporalresolution=='d'
    p = 0;
    for z=fix(setting.from):ceil(setting.to)
        p = p + 1;
        xtickvallabel{p} = sprintf('%s%s%s%s',datestr(z,zdatstr0),zdatestr2,datestr(z,zdatstr1),zdatestr3);
        if p==1
            xtickval(p) = 1;
        else
            xtickval(p) = xtickval(p-1);
        end
    end
    xmin = xtickval(1)-1;  xmax = setting.period.count+1;
end


ni = 0;
for h=1:numel(xtickval)
    for u=1:numel(setting.secondPlot.x)
        currstr = xtickvallabel{h};
        if strcmp(currstr,num2str(setting.secondPlot.x(u)))==1
            ni = ni + 1;
            tmpx(ni) = xtickval(h);
            tmpy(ni) = setting.secondPlot.y(u);
            u = numel(setting.secondPlot.x);
        end
    end
end
if ni==0
    fprintf('Could not align the second plot data with the histogramm data!\n You might check if the date of the data is %s\n',setting.format.date2);
    return;
end

setting.h2 = axes('Position',get(setting.h1,'Position'));
plot(tmpx,tmpy,'-ok','LineWidth',2,'MarkerEdgeColor','k',...
                'MarkerFaceColor','k','MarkerSize',10,'Parent',setting.h2);
hold on;
set(setting.h2,'YAxisLocation','right','Color','none','XTickLabel',[],'XTick',[]);
set(setting.h2,'Box','off','ylim',setting.secondPlot.ylim);     
set(setting.h2,'XLim',get(setting.h1,'XLim'),'Layer','top','fontsize',setting.fontsizeaxis);
ylabel(setting.secondPlot.ylabel,'FontSize',setting.fontsizeaxis);
disp(' ');
%set(setting.h2,'YAxisLocation','right','Color','none','XTickLabel',[],'xlim',[timeseries.start timeseries.end],'FontSize',14);
%set(setting.h2,'XTick', x_tick, 'XTickLabel', x_tick_label);  