function TemporalStatistics(setting)
corrval = 2.5; % fontsize - corrval = size text in plot
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
            [datahist,excludedtypehist,settinghist,datastructhist] = filterDataEtypeExclude(datahist,datastructhist,settinghist);
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
            [dataseisgraph,excludedtypeseisgraph,settingseisgraph,datastructseisgraph] = filterDataEtypeExclude(dataseisgraph,datastructseisgraph,settingseisgraph);
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
               
        if setting.useshape.useLandgrenzen == 1;
            [datalast20year,datastructlast20year,settinglast20year] = filterDataWithinPolygonShp(datalast20year,datastructlast20year,settinglast20year,'periodlast20year');
        end
        if setting.filter.UseTheFilter==1
            [datalast20year,excludedtypelast20year,settinglast20year,datastructlast20year] = filterDataEtypeExclude(datalast20year,datastructlast20year,settinglast20year);
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


% // get a list of number per temporal resolution (hour, day, month, year)
%    and seismic moment
if setting.magPerCalendarYear.plothierachy >= 1
    [numbhist,momenthist,interval] = prepareDataStackTemporal(datahist,setting);
else
    numbhist = [];          momenthist = [];
    numbseisgraph = [];     momentseisgraph = [];
    numblast20year = [];    momentlast20year = [];
end
if setting.magPerCalendarYear.plothierachy >= 2
    [numbseisgraph,momentseisgraph,interval] = prepareDataStackTemporal(dataseisgraph,setting);
else
    numbseisgraph = [];     momentseisgraph = [];
    numblast20year = [];    momentlast20year = [];
end
if setting.magPerCalendarYear.plothierachy >= 3
    [numblast20year,momentlast20year,interval] = prepareDataStackTemporal(datalast20year,setting);
else
    numblast20year = [];    momentlast20year = [];
end



% // WRITE DATA TO a file
 %write(datastructhist,datastructseisgraph,datastructlast20year,setting);
 
 
 
 
 % // PLOT the DATA
 if setting.magPerCalendarYear.plothierachy >= 1
     %scrsz = get(0,'ScreenSize');
     figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height],'Name',sprintf('%s source: AEC  (%s)',setting.magPerCalendarYear.strregion,setting.title));
     set(gcf,'Color','w');
     
     % //get historic EQ's
     subplot(3,2,1); hold on;  grid on;
     if ~isempty(numbhist)
         bar(numbhist);
         set(gca,'fontsize',setting.fontsizeaxis);
         ylabel(setting.labely1,'fontsize',setting.fontsize);
         xlabel(setting.labelx,'fontsize',setting.fontsize); 
     end
     title('Temporal Effects (Historic Data < 1900)');
     subplot(3,2,2); hold on;  grid on;
     if ~isempty(momenthist)
         bar(momenthist);
         set(gca,'fontsize',setting.fontsizeaxis);
         ylabel(setting.labely2,'fontsize',setting.fontsize);
         xlabel(setting.labelx,'fontsize',setting.fontsize);
     end        
     text(1,max(momenthist),sprintf('n=%g',sum(numbhist)),'FontSize',setting.fontsize-corrval);
 end
 
 % //get EQ's from 1900-2000
 if setting.magPerCalendarYear.plothierachy >= 2
     subplot(3,2,3); hold on; grid on;
     if ~isempty(numbseisgraph)
         bar(numbseisgraph);
         set(gca,'fontsize',setting.fontsizeaxis);
         ylabel(setting.labely1,'fontsize',setting.fontsize);
         xlabel(setting.labelx,'fontsize',setting.fontsize);
     end
     title('Temporal Effects (Years 1900-2000)');
     subplot(3,2,4); hold on; grid on;
     if ~isempty(momentseisgraph)
         bar(momentseisgraph);
         set(gca,'fontsize',setting.fontsizeaxis);
         ylabel(setting.labely2,'fontsize',setting.fontsize);
         xlabel(setting.labelx,'fontsize',setting.fontsize);
     end
      text(1,max(momentseisgraph),sprintf('n=%g',sum(numbseisgraph)),'FontSize',setting.fontsize-corrval);
 end
 
 % //get EQ's from the last 20 years
 if setting.magPerCalendarYear.plothierachy >= 3
     subplot(3,2,5); hold on; grid on;
     if ~isempty(numblast20year)
         bar(numblast20year);
         set(gca,'fontsize',setting.fontsizeaxis);
         ylabel(setting.labely1,'fontsize',setting.fontsize);
         xlabel(setting.labelx,'fontsize',setting.fontsize);
     end
     title('Temporal Effects (last 20 Years)');
     subplot(3,2,6); hold on; grid on;
     if ~isempty(momentlast20year)
         bar(momentlast20year);
         set(gca,'fontsize',setting.fontsizeaxis);
         ylabel(setting.labely2,'fontsize',setting.fontsize);
         xlabel(setting.labelx,'fontsize',setting.fontsize);
     end
     text(1,max(momentlast20year),sprintf('n=%g',sum(numblast20year)),'FontSize',setting.fontsize-corrval);
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
