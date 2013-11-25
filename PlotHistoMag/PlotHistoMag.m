function PlotHistoMag()
% // start the code with PlotHistoMag()
%
% // reads a textfile from a db query and plots the
%EQ distribution per day file format:
%    date          lat       lon       depth    mag  etyp  orid
% 10/05/2012   47.8361   16.1614    0.0000    1.33 sm  1043284

setting = getSettings();

% DATABASE
inp = '9999';   u = 0;
while strcmp(inp,'q') == 0 && strcmp(inp,'0') ==  0
    if setting.DB.readfromDB == 1
        %clc;
        u = u + 1;  setting.statref.currRun = u;
        if u==1
            setting.computeRefstats = 1;
        else
            setting.computeRefstats = 0;
        end
        dbseismo07 = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2007';
        dbseismo06 = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2006';
        dbseismo05 = '/net/zagsun17/export/home/seismo/antelope/db/SEISMO_2005';
        dbzagsun17 = '/net/zagsun17/export/home/seismo/antelope/db/zagsun17';
        fprintf('run %g:  ..read the data from \n',u);
        fprintf('[1] %s \n',setting.DB.DBpath);
        fprintf('[2] %s \n',setting.DB.refDBpath);
        fprintf('[3] %s \n',dbzagsun17);
        fprintf('[4] %s \n',dbseismo07);
        fprintf('[5] %s \n',dbseismo06);
        fprintf('[6] %s \n',dbseismo05);
        fprintf('[0] write all %g runs to a file and show the stats \n\n',u-1);
        inp = input('>> Please select the database [q..quit]\n','s');
        if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            switch str2num(inp)
                case 1
                    setting.DB.DBpath = setting.DB.DBpath;
                case 2
                    setting.DB.DBpath = setting.DB.refDBpath;
                case 3
                    setting.DB.DBpath = dbzagsun17;
                case 4
                    setting.DB.DBpath = dbseismo07;
                case 5
                    setting.DB.DBpath = dbseismo06;
                case 6
                    setting.DB.DBpath = dbseismo05;
                case 0
                    %do nothing
                    setting.exit = 0;
            end
        end
    else
        fprintf('..read the data from file %s \n',setting.filepath);
    end
    disp(' ');
    
    if strcmp(inp,'q') == 1 || strcmp(inp,'0') == 1
        setting.exit = 1;
    else
        setting = getSettingsFromMenu(setting);
    end
    
    if setting.exit == 0
        switch setting.flag
            case 1
                setting.saveDBmode = 0;
                NormalHistplotmitMag(setting);
            case 2
                setting.saveDBmode = 0;
                NormalHistplotEQmitandere(setting);
            case 3
                setting.saveDBmode = 0;
                NormalHistplotKlassisch(setting);
                %plotNormalHistogram(data,setting);
            case 4
                setting.saveDBmode = 1;
                [currStats,refStats] = StatisticsToReferencePeriod(setting);
                if setting.computeRefstats == 1
                    if u==1
                        statisticsRef{1} = refStats;
                        fprintf('[info]: The reference period has been fixed now. You may proceed with other regions and show/export them together after n+1 runs.\n');
                    else
                        statisticsRef{u} = statisticsRef{1};
                        fprintf('[info]: The first reference period was added for run %g',u);
                    end
                else
                    statisticsRef{u} = refStats;
                    fprintf('[info]: A new reference period was added for run %g',u);
                end
                statistics{u} = currStats;
                %Statistik (mit Vergleich zu Mittlerer Periode, Wiederkehrperiode (ab 1900)
            case 5
                setting.saveDBmode = 0;
                MaxMagnitudeperCalendarYear(setting);
            case 6
                setting.saveDBmode = 0;
                TemporalStatistics(setting);
            case 7
                setting.saveDBmode = 0;
                writeOnlyEQList(setting);
            case 8
                setting.saveDBmode = 1;
                analyzePhases(setting);
            case 9
                setting.saveDBmode = 1;
                plotWaveformsMenu(setting);                
        end
    end
end


%//export the statistics to a file
[syear,smonth,sday,shour,sminute,ssecond] = datevec(now());
minutesincemidnight = sminute+shour*60;
setting.filenamestatistic = sprintf('%s%s_M%04.0f-No%02.0f.txt',setting.filenamestatistic,datestr(now, 'dd.mm.yyyy'),minutesincemidnight,u);
if setting.exit == 1
    if strcmp(inp,'q') ~= 1
        % //display the statistics
        displayTheStatisticsWithRefPeriode(statisticsRef,statistics,setting);
        
        % //write the statistics to a file
        fprintf('write the statistics now to %s \n',setting.filenamestatistic);
    end
else
    fprintf('no need to write the statistics to %s \n',setting.filenamestatistic);
end






function NormalHistplotKlassisch(setting)
if setting.DB.readfromDB==1
    switch setting.DB.userectangle
        case 1  % near Austria - AEC
          [setting,data,datastruct] = getAllEventsFromDBAustria(setting,'normal'); 
        case 2  % user specified - zagsunxx
          [setting,data,datastruct] = getAllEventsFromDBWorld(setting,'normal');
        otherwise  %no geographic filter
          [setting,data,datastruct] = getAllEventsFromDBWorld(setting,'normal');  
    end
else  
  [setting,data,datastruct] = readTextFile(setting);
end
[setting] = printStatistik(data,setting);

% plot data within Landesgrenzen (see getSetting.m)
if setting.useshape.useLandgrenzen == 1;   
    [data,datastruct,setting] = filterDataWithinPolygonShp(data,datastruct,setting,'normal');
end

%Filter the data: revome 'km','sm' etc. (see getSetting.m)
if setting.filter.UseTheFilter==1
    [data,excludtype,setting] = filterDataEtypeExclude(data,datastruct,setting,'normal');
    if numel(data)<=0
        fprintf('All data were filtered and NO EVENTS remain!\n');
    end  
end

[datastack,setting] = prepareDataStackKlassisch(data,setting);
[setting] = printStatistikMagStack(datastack,setting);
[setting] = plotStackedKlassisch(datastack,setting);
if setting.plotInfoSubplot==1
   plotInfoOnHistoSubplot(setting);
end
disp(' ');




function NormalHistplotmitMag(setting)
if setting.DB.readfromDB==1
    switch setting.DB.userectangle
        case 1  % near Austria - AEC
          [setting,data,datastruct] = getAllEventsFromDBAustria(setting,'normal'); 
        case 2  % user specified - zagsunxx
          [setting,data,datastruct] = getAllEventsFromDBWorld(setting,'normal');   
        otherwise  % no geographic filter
          [setting,data,datastruct] = getAllEventsFromDBWorld(setting,'normal');   
    end
else  
  [setting,data,datastruct] = readTextFile(setting);
end
[setting] = printStatistik(data,setting);

% plot data within Landesgrenzen (see getSetting.m)
if setting.useshape.useLandgrenzen == 1;   
    [data,datastruct,setting] = filterDataWithinPolygonShp(data,datastruct,setting,'normal');
end

%Filter the data: revome 'km','sm' etc. (see getSetting.m)
if setting.filter.UseTheFilter==1
    [data,excludtype,setting] = filterDataEtypeExclude(data,datastruct,setting,'normal');
    if numel(data)<=0
        fprintf('All data were filtered and NO EVENTS remain!\n');
    end
end

[datastack,setting] = prepareDataStack(data,setting);
[setting] = printStatistikMagStack(datastack,setting);
[setting] = plotStackedMagHistogram(datastack,setting);
if setting.plotInfoSubplot==1
   plotInfoOnHistoSubplot(setting);
end
disp(' ');





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




function NormalHistplotEQmitandere(setting)
if setting.DB.readfromDB==1
    switch setting.DB.userectangle
        case 1  % near Austria - AEC
          [setting,data,datastruct] = getAllEventsFromDBAustria(setting,'normal'); 
        case 2  % user specified - zagsunxx
          [setting,data,datastruct] = getAllEventsFromDBWorld(setting,'normal');   
        otherwise  % no geographic filter
          [setting,data,datastruct] = getAllEventsFromDBWorld(setting,'normal');   
    end
else  
  [setting,data,datastruct] = readTextFile(setting);
end
[setting] = printStatistik(data,setting);

%Filter the data: revome 'km','sm'
if setting.filter.UseTheFilter==0
    fprintf('Note that this algorithm needs the specification of two filters!\n');
end
   
setting.filter.WhichData = setting.filter1.WhichData;
[data1,excludtype,setting] = filterDataEtypeExclude(data,datastruct,setting,'normal');
setting.filter.NumberEtypeExclude1 = setting.filter.NumberEtypeExclude;
setting.filter.excludedDataStr1 = setting.filter.excludedDataStr;

setting.filter.WhichData = setting.filter2.WhichData;
[data2,excludtype,setting] = filterDataEtypeExclude(data,datastruct,setting,'normal');
setting.filter.NumberEtypeExclude2 = setting.filter.NumberEtypeExclude;
setting.filter.excludedDataStr2 = setting.filter.excludedDataStr;

[datastack,setting] = prepareDataStack2Classes(data1,data2,setting);
%[setting] = printStatistikMagStack(datastack,setting);
plotStacked2Classes(datastack,setting);
if setting.plotInfoSubplot==1
   plotInfoOnHistoSubplot(setting);
end
disp('a');




function [datastack,setting] = prepareDataStack2Classes(data1,data2,setting)
flagfakedate = 0;
datastack = [];

%fülle leerbereiche bzw. Lücken auf
[zdatenum,zdatstr,interval] = getZDatenums(setting);

%sortiere nach Datum
data1 = sortrows(data1,1);
data2 = sortrows(data2,1);

switch setting.temporalresolution
    case 'j'
        [datastack,setting] = stackDataYearly2classes(data1,data2,zdatstr,setting);
    case 'h'
         fprintf('Option %s (setting.temporalresolution) not supported until now! \n',setting.temporalresolution);
    case 'd'
         fprintf('Option %s (setting.temporalresolution) not supported until now! \n',setting.temporalresolution);
end










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









function [datastack,setting] = prepareDataStackKlassisch(data,setting)
flagfakedate = 0;

%fülle leerbereiche bzw. Lücken auf
[zdatenum,zdatstr,interval] = getZDatenums(setting);

% markiere die doppelten Tage/Stunden
if  setting.temporalresolution=='d' || setting.temporalresolution=='h'
    zdatenumFlag = zeros(size(zdatenum,1),1);
    dataunique = unique(data(:,1));
    altegroesse = size(dataunique,1);
    for k=1:altegroesse
        for j=1:size(zdatenum,1)
            if dataunique(k)==zdatenum(j)
                zdatenumFlag(j) = 1;
            end
        end
    end
    %speichere und hinzufügen der neuen Tage/Stunden
    if sum(zdatenumFlag)~=size(zdatenum,1)
        ind = find(zdatenumFlag==0);
        neuedatenum = zdatenum(ind);
        tmp = ones(size(neuedatenum,1),5);
        data = [data;neuedatenum tmp];
        flagfakedate = 1;
        fprintf('Number of faked data points: %g of %g(dates where no data were found)\n',size(neuedatenum,1),size(zdatenum,1));
    end
    %figure; hold on;
    %plot(neuedatenum(:),ones(size(neuedatenum,1)),'rs');
    %plot(dataunique(:),ones(size(dataunique,1)),'bd','MarkerSize',14);
end

%sortiere nach Datum
data = sortrows(data,1);

%suche anzahl an beben pro zeiteinheit
%datastack = NaN((setting.to-setting.from),numel(setting.stacks));
veclen = NaN(numel(setting.stacks),1);
for g=1:numel(setting.stacks)
    veclen(g) = setting.stacks{g};
end

switch setting.temporalresolution
    case 'j'
        [datastack,setting] = stackDataYearlyKlassisch(data,zdatstr,setting);
    case 'm'
        [datastack,setting] = stackDataMonthlyKlassisch(data,zdatstr,setting);
    case 'd'
        [datastack] = stackDataHourlyDailyKlassisch(data,interval,setting);
    case 'h'
        [datastack] = stackDataHourlyDailyKlassisch(data,interval,setting);
end


%entferne die leerbereiche bzw. Lücken wieder
if  setting.temporalresolution=='d' || setting.temporalresolution=='h'
    if flagfakedate == 1
        dummy = zeros(1,numel(setting.stacks));
        z = 0;
        for h=fix(setting.from):interval:ceil(setting.to)
            z = z + 1;
            ind2 = find(neuedatenum==h);
            if ~isempty(ind2)
                datastack(z,:) = dummy;
            end
        end
    end
end
disp(' ');








function setting = plotStackedMagHistogram(datastack,setting)
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
  set(gca,'YTick',ytickold,'YMinorTick','off','TickDir','out'); 
end
set(gca,'YAxisLocation','left','XTick',xtickval,'XMinorTick', 'off', 'TickDir','out');
set(gca,'XTickLabel',xtickvallabel,'fontsize',setting.fontsizeaxis);
ylabel(setting.labely,'fontsize',setting.fontsize);

for g=1:numel(setting.stacks)
    alteMag = setting.stacks{g};
    if g >= numel(setting.stacks) && g ~= 1
        legstr{g} = sprintf(' M>%1.0f',alteMag);
    else
        neueMag = setting.stacks{g+1};
        legstr{g} = sprintf('%2.0f<M<%1.0f',alteMag,neueMag);
    end
    if setting.legend.setsmallMagZero == 1
      if g == 1
          neueMag = setting.stacks{g+1};
          legstr{g} = sprintf(' M<%1.0f',neueMag);
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


function [zdatstring,interval] = getZDatestr(setting)
interval = 1;
switch setting.temporalresolution
    case 'j'
        zdatstr0 = 'yyyy'; zdatstr1 = ''; zdatestr2 = ''; zdatestr3 = '';
    case 'm'
        zdatstr0 = 'mmm'; zdatstr1 = ''; zdatestr2 = ''; zdatestr3 = '';
    case 'd'
        interval = 1;
        zdatstr0 = 'dd.mmm'; zdatstr1 = ''; zdatestr2 = ''; zdatestr3 = '';
    case 'h'
        interval = 1/24;
        zdatstr0 = 'dd.mm'; zdatstr1 = 'HH'; zdatestr2 = ' '; zdatestr3 = 'h';
end
zdatstring{1} = zdatstr0;
zdatstring{2} = zdatstr1;
zdatstring{3} = zdatestr2;
zdatstring{4} = zdatestr3;




function [limit,xtickvallabel,xtickval] = getXticksXtickLabelsMag(datastack,setting,zdatstring,interval,xtickold)
%compute the disered xticks with labels as
% specified in the setting

zdatstr0 = zdatstring{1};
zdatstr1 = zdatstring{2};
zdatestr2 = zdatstring{3};
zdatestr3 = zdatstring{4};

tageabstand = setting.period.count /setting.xticknumber;
if setting.temporalresolution=='j'
    xtickval = 1:ceil(tageabstand):size(setting.xlabelname,1);
    z = 0;
    for p=1:ceil(tageabstand):size(setting.xlabelname,1)
         z = z + 1;
        valuenum = datenum(setting.xlabelname(p,:),'yyyy');
        xtickvallabel{z} = datestr(valuenum,'yyyy');
    end
    limit.xlim = [0 size(datastack,1)+1];
    limit.ylim = setting.ylim;
end
if setting.temporalresolution=='m'
    xtickval = xtickold;
    for p=1:size(setting.xlabelname,1)
        valuenum = datenum(setting.xlabelname(p,:),'mm/yyyy');
        xtickvallabel{p} = datestr(valuenum,'mmm');
    end
    limit.xlim = [0 size(datastack,1)+1];
    limit.ylim = setting.ylim;
end
if setting.temporalresolution=='d'
    %tmp = fix(setting.from):ceil(tageabstand)*interval:ceil(setting.to);
    %tageabstand = numel(tmp)/setting.xticknumber;
    p = 0;
    for z=fix(setting.from):ceil(tageabstand)*interval:ceil(setting.to)
        p = p + 1;
        xtickvallabel{p} = sprintf('%s%s%s%s',datestr(z,zdatstr0),zdatestr2,datestr(z,zdatstr1),zdatestr3);
        if p==1
            xtickval(p) = 1;
        else
            xtickval(p) = xtickval(p-1)+ceil(tageabstand);
        end
    end
    limit.xlim = [xtickval(1)-1 setting.period.count+1]; 
    limit.ylim = setting.ylim;
end
if setting.temporalresolution=='h' 
    tmp = fix(setting.from):ceil(tageabstand)*interval:ceil(setting.to);
    tageabstand = numel(tmp)/setting.xticknumber;
    p = 0;
    for z=fix(setting.from):ceil(tageabstand)*interval:ceil(setting.to)
        p = p + 1;
        xtickvallabel{p} = sprintf('%s%s%s%s',datestr(z,zdatstr0),zdatestr2,datestr(z,zdatstr1),zdatestr3);
        if p==1
            xtickval(p) = 1;
        else
            xtickval(p) = xtickval(p-1)+ceil(tageabstand);
        end
    end
    limit.xlim = [xtickval(1)-1 xtickval(p)+1]; 
    limit.ylim = setting.ylim;
end




function plotStacked2Classes(datastack,setting)
% data format:
%    date(datenum)  lat  lon  depth  mag
%valuebins = unique(datastack(:,1));
[zdatstring,interval] = getZDatestr(setting);

scrsz = get(0,'ScreenSize');
figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height]);
set(gcf,'Color','w');
 
subplot(setting.InfoPlot.subM,1,1:4);
bar(datastack,'stack'); hold on;
title(setting.title,'fontsize',setting.fontsizetitle);
xtickold = get(gca, 'XTick');  ytickold = get(gca,'YTick');
[limit,xtickvallabel,xtickval] = getXticksXtickLabelsMag(datastack,setting,zdatstring,interval,xtickold);
xlim(limit.xlim); 
if setting.plotAutoscaleOn == 0
    ylim(limit.ylim );
end
colormap(jet(2));
xtickvallabel = transformTickEng2Ger(xtickvallabel,setting);
if setting.plot2ndPlotOnHistogramm.yesno == 1 
   set(gca,'Box','off','Color','white','XTick',[],'YTick',[]);
end
set(gca,'YTick',ytickold,'YMinorTick','off','TickDir','in'); 
set(gca,'YAxisLocation','left','XTick',xtickval);
set(gca,'XTickLabel',xtickvallabel,'fontsize',setting.fontsizeaxis);
ylabel(setting.labely,'fontsize',setting.fontsize);

% // plot the second plot
setting.h1 = gca;
if setting.plot2ndPlotOnHistogramm.yesno == 1
    [setting] = plotSecondPlot(setting);
end

% // plot the legend of the main plot
legend(setting.h1,setting.legend2classes{:},2);  




function [setting] = printStatistikMagStack(datastack,setting)

strmagmax =   'Max. Numbers/Class '; 
strmagclass = 'Magnitude Classes  ';
strmagval = 'Magnitude Values  ';
%string magnitude max
summag = 0;
for k=1:size(datastack,2)
    tmpstack = datastack(:,k);
    strmagmax = sprintf('%s      %4.0f',strmagmax,max(tmpstack));
    strmagval = sprintf('%s      %4.0f',strmagval,sum(tmpstack));
    summag = summag + sum(tmpstack);
end

%string magnitude classes
for g=1:numel(setting.stacks)
    alteMag = setting.stacks{g};
    if g >= numel(setting.stacks)
        strmagclass = sprintf('%s  M>=%3.1f',strmagclass,alteMag);
    else
        neueMag = setting.stacks{g+1};
        strmagclass = sprintf('%s  %3.1f<M<%3.1f',strmagclass,alteMag,neueMag);
    end
end
fprintf('%s   Summe\n',strmagclass);
fprintf('%s \n',strmagmax);
fprintf('%s   %g\n',strmagval,summag);
setting.statvalues{1}=strmagclass;
setting.statvalues{2}=strmagmax;
setting.statvalues{3}=strmagval;
setting.statvalues{4}=summag;























 



function legstr=transformTickEng2Ger(legstr,setting)

for k=1:numel(legstr)
    switch setting.temporalresolution
        case 'd'  
            tmp = legstr{k};
            [tmpleft,tmpright] = strtok(tmp, '.');
            tmpright = strtok(tmpright, '.');
            switch tmpright
                case 'May'
                    legstr{k} = sprintf('%s.Mai',tmpleft);
                case 'Oct'
                    legstr{k} = sprintf('%s.Okt',tmpleft);
                case 'Dec'
                    legstr{k} = sprintf('%s.Dez',tmpleft);
            end
    end
end




