function MaxMagnitudeperCalendarYear(setting)
marksizekugel = 7.3;
linewidthline = 1.7;
minvallandgrenz = 12;

if setting.DB.readfromDB==1
    % //get historic EQ's
    if setting.magPerCalendarYear.plothierachy >= 1
        fprintf('Historic Earthquakes: 1000-1900      \n');
        [settinghist,datahist,datastructhist] = getAllEventsFromDBAustria(setting,'periodhist');
        disp(' ');
        % plot data within Landesgrenzen (see getSetting.m)
        if setting.useshape.useLandgrenzen == 1;
            [datahist,datastructhist,settinghist] = filterDataWithinPolygonShp(datahist,datastructhist,settinghist,'periodhist');
        end
        %Filter the data: revome 'km','sm' etc. (see getSetting.m)
        if setting.filter.UseTheFilter==1
            [datahist,excludedtypehist,settinghist,datastructhist] = filterDataEtypeExclude(datahist,datastructhist,settinghist,'periodhist');
            if numel(datahist)<=0
                fprintf('All data were filtered and NO EVENTS remain for periodhist!\n');
            end
        end
        if setting.useshape.selectedLandgrenzen > minvallandgrenz
            [datastructhist] = replaceEvnameOutsideAustria2(datastructhist,settinghist);
        end
    else
        datahist = [];  datastructhist = [];  settinghist = [];
        datastructhist = [];
        dataseisgraph = [];  datastructseisgraph = [];  settingseisgraph = [];
        datastructseisgraph = [];
        datalast20year = [];  excludedtypelast20year = [];  settinglast20year  = [];
        datastructlast20year = [];
    end
    
    % //get EQ's from 1900-2000
    if setting.magPerCalendarYear.plothierachy >= 2
        fprintf('Seismograph/meter Earthquakes: 1900-2000      \n');
        [settingseisgraph,dataseisgraph,datastructseisgraph] = getAllEventsFromDBAustria(setting,'periodseisgraph');
        % plot data within Landesgrenzen (see getSetting.m)
        if setting.useshape.useLandgrenzen == 1;
            [dataseisgraph,datastructseisgraph,settingseisgraph] = filterDataWithinPolygonShp(dataseisgraph,datastructseisgraph,settingseisgraph,'periodseisgraph');
        end
        if setting.filter.UseTheFilter==1
            [dataseisgraph,excludedtypeseisgraph,settingseisgraph,datastructseisgraph] = filterDataEtypeExclude(dataseisgraph,datastructseisgraph,settingseisgraph,'periodseisgraph');
            if numel(dataseisgraph)<=0
                fprintf('All data were filtered and NO EVENTS remain for periodseisgraph!\n');
            end
        end
        if setting.useshape.selectedLandgrenzen > minvallandgrenz
            [datastructseisgraph] = replaceEvnameOutsideAustria2(datastructseisgraph,settingseisgraph);
        end
    else
        dataseisgraph = [];  datastructseisgraph = [];  settingseisgraph = [];
        datastructseisgraph = [];
        datalast20year = [];  excludedtypelast20year = [];  settinglast20year  = [];
        datastructlast20year = [];
    end
    
    % //get EQ's from the last 20 years
    if setting.magPerCalendarYear.plothierachy >= 3
        fprintf('Earthquakes in the last 20 year:      \n');
        [settinglast20year,datalast20year,datastructlast20year] = getAllEventsFromDBAustria(setting,'periodlast20year');
        % plot data within Landesgrenzen (see getSetting.m)
        
        figure;
        plot(datalast20year(:,3),datalast20year(:,2),'ro'); hold on;
        [shape] = shaperead(setting.useshape.LangrenzenPath);
        count_shapefile = size(shape,1);
        for r=1:count_shapefile
            IND = find(~isnan(shape(r).X));
            shape(r).X = shape(r).X(IND);
            shape(r).Y = shape(r).Y(IND);
            curr_X = shape(r).X;
            curr_Y = shape(r).Y;
            plot(curr_X(:),curr_Y(:),'bo'); 
        end
        
        if setting.useshape.useLandgrenzen == 1;
            [datalast20year,datastructlast20year,settinglast20year] = filterDataWithinPolygonShp(datalast20year,datastructlast20year,settinglast20year,'periodlast20year');
        end
        if setting.filter.UseTheFilter==1
            [datalast20year,excludedtypelast20year,settinglast20year,datastructlast20year] = filterDataEtypeExclude(datalast20year,datastructlast20year,settinglast20year,'periodlast20year');
            if numel(datalast20year)<=0
                fprintf('All data were filtered and NO EVENTS remain for periodlast20year!\n');
            end
        end
        if setting.useshape.selectedLandgrenzen > minvallandgrenz
            [datastructlast20year] = replaceEvnameOutsideAustria2(datastructlast20year,settinglast20year);
        end
    else
        datalast20year = [];  excludedtypelast20year = [];  settinglast20year  = [];
        datastructlast20year = [];
    end
else
    [setting,data,datastruct] = readTextFile(setting);
end

% get a list of magnitude with highest value
if setting.magPerCalendarYear.plothierachy >= 1
    [yearlisthist,datastructhist] = getMagnitudePerCalendarYear(datahist,datastructhist);
else
    yearlisthist = [];
    yearlistseisgraph = [];
    yearlistlast20year = [];
end
if setting.magPerCalendarYear.plothierachy >= 2
    [yearlistseisgraph,datastructseisgraph] = getMagnitudePerCalendarYear(dataseisgraph,datastructseisgraph);
else
    yearlistseisgraph = [];
    yearlistlast20year = [];
end
if setting.magPerCalendarYear.plothierachy >= 3
    [yearlistlast20year,datastructlast20year] = getMagnitudePerCalendarYear(datalast20year,datastructlast20year);
else
    yearlistlast20year = [];
end



% // WRITE DATA TO a file
 writeMagnitudePerCalendarYear(datastructhist,datastructseisgraph,datastructlast20year,setting);
 
 
 
 % // PLOT the DATA
 if setting.magPerCalendarYear.plothierachy >= 1
     %scrsz = get(0,'ScreenSize');
     figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height],'Name',sprintf('%s source: AEC',setting.magPerCalendarYear.strregion));
     set(gcf,'Color','w');
     
     % //get historic EQ's
     subplot(3,1,1); hold on;  grid on;
     if ~isempty(yearlisthist)
         h1 = stem(yearlisthist(:,5),'fill',':');
         set(h1,'MarkerFaceColor','red','MarkerSize',marksizekugel,'LineWidth',linewidthline,'MarkerEdgeColor','k');
         xmin = min(str2num(datestr(yearlisthist(:,6),'yyyy')));
         xmax = max(str2num(datestr(yearlisthist(:,6),'yyyy')));
         xtickold = get(gca,'XTick'); indold = xtickold';
         xticknew = num2str(indold+xmin-1);
         set(gca,'XTickLabel',xticknew,'fontsize',setting.fontsizeaxis);
         ylabel(setting.labely,'fontsize',setting.fontsize);
         xlabel(setting.labelx,'fontsize',setting.fontsize);
         title('Max. Magnitude per Calendar Year (Historic Data < 1900)');
     end
 end
 
 % //get EQ's from 1900-2000
 if setting.magPerCalendarYear.plothierachy >= 2
     subplot(3,1,2); hold on; grid on;
     if ~isempty(yearlistseisgraph)
         h2 = stem(yearlistseisgraph(:,5),'fill',':');
         set(h2,'MarkerFaceColor','red','MarkerSize',marksizekugel,'LineWidth',linewidthline,'MarkerEdgeColor','k');
         xmin = min(str2num(datestr(yearlistseisgraph(:,6),'yyyy')));
         xmax = max(str2num(datestr(yearlistseisgraph(:,6),'yyyy')));
         if size(yearlistseisgraph,1)>1
             xlim([1 size(yearlistseisgraph,1)]);
         end
         ylim(setting.ylim);
         xtickold = get(gca,'XTick');  indold = xtickold';
         xticknew = num2str(indold+xmin-1);
         set(gca,'XTickLabel',xticknew,'fontsize',setting.fontsizeaxis);
         ylabel(setting.labely,'fontsize',setting.fontsize);
         xlabel(setting.labelx,'fontsize',setting.fontsize);
         title('Max. Magnitude per Calendar Year (1900-2000)');
     end
 end
 
 % //get EQ's from the last 20 years
 if setting.magPerCalendarYear.plothierachy >= 3
     subplot(3,1,3); hold on;  grid on;
     if ~isempty(yearlistlast20year)
         h3 = stem(yearlistlast20year(:,5),'fill',':');
         set(h3,'MarkerFaceColor','red','MarkerSize',marksizekugel,'LineWidth',linewidthline,'MarkerEdgeColor','k');
         xmin = min(str2num(datestr(yearlistlast20year(:,6),'yyyy')));
         xmax = max(str2num(datestr(yearlistlast20year(:,6),'yyyy')));
         if size(yearlistlast20year,1)>1
             xlim([1 size(yearlistlast20year,1)]);
         end
         ylim(setting.ylim);
         xtickold = get(gca,'XTick');  indold = xtickold';
         xticknew = num2str(indold+xmin-1);
         set(gca,'XTickLabel',xticknew,'fontsize',setting.fontsizeaxis);
         ylabel(setting.labely,'fontsize',setting.fontsize);
         xlabel(setting.labelx,'fontsize',setting.fontsize);
         title('Max. Magnitude per Calendar Year (last 20 Years)');
     end
 end
 
%tmp1 = find(yearlisthist~=NaN);
%tmp2 = find(yearlistseisgraph~=NaN);
%tmp3 = find(yearlistlast20year~=NaN);
%fprintf('PLot MaxMagnitudePerCalendarYear:  Historic Data %g,     Period 1900-2000 %g,    Last 20 Years %g',sum(tmp1),sum(tmp2),55);
disp(' ');









function [yearlist,datastructout] = getMagnitudePerCalendarYear(datain,datastruct)
% group the data per year and find the maximum magnitude
% datain 1..curr_datum,  2..lat,  3..lon,  4..depth,  
%        5..ml,   6..curr_datum_excact
%                                         ' 6/13/1900   2:50:00.000'
%datenum1 = datenum(datastruct(:).datestr, 'dd/mm/yyyy  HH:MM:SS');
allyears = str2num(datestr(datain(:,6),'yyyy'));
[sortyears,ind] = sort(allyears,'ascend');
datainsort = datain(ind,:);
datastructsort = datastruct(ind);

clear ind;
minyear = min(str2num(datestr(datainsort(:,6),'yyyy')));
maxyear = max(str2num(datestr(datainsort(:,6),'yyyy')));

yearlist = NaN(maxyear-minyear+1,6);
z = 0;   datastructout = [];
for p=minyear:maxyear
    ind2 = find(str2num(datestr(datainsort(:,6),'yyyy'))==p);
    curr_year = datainsort(ind2,:);
    curr_struct = datastructsort(ind2);
    [maxmag,maxind] = max(curr_year(:,5));
    z = z + 1;
    if ~isempty(maxind)
        yearlist(z,1) = curr_year(maxind,1);
        yearlist(z,2) = curr_year(maxind,2);
        yearlist(z,3) = curr_year(maxind,3);
        yearlist(z,4) = curr_year(maxind,4);
        yearlist(z,5) = curr_year(maxind,5);
        yearlist(z,6) = curr_year(maxind,6);
        currstruct = curr_struct(maxind); 
        datastructout = [datastructout currstruct];        %store the datastruct
        clear currstruct curr_year curr_struct;
    end
end


    
    
    
    
    
    
    
    
    
    
    
    
    
