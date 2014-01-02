function  plotWaveformsPerStationDataPlot(setting)


%// get the events: evid
fprintf('get the event list: evid  \n');
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

% // search data within Landesgrenzen (see getSetting.m)
if setting.useshape.useLandgrenzen == 1;
    [data,datastruct,setting] = filterDataWithinPolygonShp(data,datastruct,setting,'normal');
end

% // Filter the data for Magnitude or Intensity
if setting.filter.Felt == 0
    [data,setting,datastruct] = filterDataMagnitudeExclude(data,datastruct,setting);
end

% // Filter the data: revome 'km','sm' etc. (see getSetting.m)
if setting.filter.UseTheFilter==1
    [data,excludedtype,setting,datastruct] = filterDataEtypeExclude(data,datastruct,setting);
    if numel(data)<=0
        fprintf('All data were filtered and NO EVENTS remain!\n');
    else
        fprintf('%g EQ''s remained after applying the filters (for etype,magnitude and polygon)\n',size(data,1));
    end
end



%// get the origin time t0
% get begin/end for the timestring: eg. '_2013-09-20 02:06:35_';
if setting.waveforms.timespanfromtnull == 1
    fprintf('get the origin time(s) t0  \n');
    [evtime,evtimestr,evid] = getEventOriginTime(data,setting);
    [cellstrEnd,cellstrBegin] = getBeginEndTimeFromTzero(evtime,evtimestr,setting);
end
if setting.waveforms.timespanfrompicks == 1
    fprintf('get the phase onset times for the first arrival(s) \n');
    [evtime,evtimestr,evid] = getFirstArrival(data,setting);
    [cellstrEnd,cellstrBegin] = getBeginEndTimeFromPicks(evtime,evtimestr,setting);
end
magnitude = getMagnitudeMlfromDB(data,setting);

%// get the data
fprintf('get the data  \n');
% copy settings
settingTRC = setting;
settingTRC.db.events = setting.DB.DBpath;
settingTRC.station = setting.waveforms.station;
compstring = '';
for t=1:numel(setting.waveforms.comp)
    settingTRC.comp{t} = setting.waveforms.comp{t};
    compstring = sprintf('%s ',setting.waveforms.comp{t});
end
if strcmp(settingTRC.comp{1},'HHZ') || strcmp(settingTRC.comp{1},'HHE') || strcmp(settingTRC.comp{1},'HHN') 
   settingTRC.intitialunit = 'V';
end
if strcmp(settingTRC.comp{1},'HNZ') || strcmp(settingTRC.comp{1},'HNE') || strcmp(settingTRC.comp{1},'HNN') 
   settingTRC.intitialunit = 'A';
end
if strcmp(settingTRC.comp{1},'HLZ') || strcmp(settingTRC.comp{1},'HLE') || strcmp(settingTRC.comp{1},'HLN') 
   settingTRC.intitialunit = 'A';
end




% read the data
for p=1:size(data,1)
    %settingTRC.time.start = '_2013-09-20 02:06:35_';
    %settingTRC.time.end ='_2013-09-20 02:07:40_';
    settingTRC.time.start = cellstrBegin{p};
    settingTRC.time.end = cellstrEnd{p};   
    [dataV1,dataA1,settingTRC,error] = getTracesfromAntelope(settingTRC,p,size(data,1));
    currV{p} = dataV1;
    currA{p} = dataA1;
end

%// plot the waveforms
fprintf('plot the waveforms  \n');
%find parameters col,row for subplots
nmax = 6;       % dimension zeilen
[mmax,n,m] = getMNsizeforSubpots(size(data,1),1,nmax);  
indMatrix = cell(nmax,mmax);
kalt = 0; 
for i=1:nmax
    for o=1:mmax
        kalt = (i-1)*nmax + o*2;
        % matrix contains indizies for the subplot: e.g. [3 4] for cell(1,2)
        indMatrix{i,o} = [kalt-1 kalt];
    end
end


for p=1:size(evtime,1)
    %n.. aktuelle spalte  m..aktuelle zeile   mmax..max.spaltenanzahl  nmax..dimension zeilen
    if p<=18
        if p==1
            figure('name',sprintf('waveforms for numerous events: 01-18 (%g) | Filter: %s (%s) | Site: %s (%s)',size(evtime,1),setting.filter.type,setting.filter.filterstring,setting.waveforms.station,compstring));
        end
        [mmax,n,m] = getMNsizeforSubpots(size(data,1),p,nmax); 
    else
        if p==19
            figure('name',sprintf('waveforms for numerous events: 19-36 (%g) | Filter: %s (%s) | Site: %s (%s)',size(evtime,1),setting.filter.type,setting.filter.filterstring,setting.waveforms.station,compstring));
        end 
        [mmax,n,m] = getMNsizeforSubpots(size(data,1),p-18,nmax); 
    end
    axesplt(p) = subplot(nmax,nmax,indMatrix{m,n});
    if settingTRC.intitialunit == 'V'
        currWF = currV{p};
        if setting.filter.on == 1
             switch setting.filter.type
                case 'LP'       %low pass
                    currWFfiltered = filterLowPass(currWF{1},settingTRC.samplerate{1},settingTRC);
                case 'HP'       %high pass
                    currWFfiltered = filterLowCutOff(currWF{1},settingTRC.samplerate{1},settingTRC);
                case 'BP'       %band pass
                    currWFfiltered = filterBandpass(currWF{1},settingTRC.samplerate{1},settingTRC);
             end   
            plot(currWFfiltered);
        else
            plot(currWF{1});
        end
         
    end
    if settingTRC.intitialunit == 'A'
        currWF = currV{p};
        if setting.filter.on == 1
            switch setting.filter.type
                case 'LP'       %low pass
                    currWFfiltered = filterLowPass(currWF{1},settingTRC.samplerate{1},settingTRC);
                case 'HP'       %high pass
                    currWFfiltered = filterLowCutOff(currWF{1},settingTRC.samplerate{1},settingTRC);
                case 'BP'       %band pass
                    currWFfiltered = filterBandpass(currWF{1},settingTRC.samplerate{1},settingTRC);
            end            
            plot(currWFfiltered);
        else
            plot(currWF{1});
        end
    end
    % create and plot the legend
    strlegend = sprintf('Ml=%3.1f %s ',magnitude(p),evtimestr{p});
    legend(strlegend,1); 
    fprintf('Ml=%3.1f %s  %s(%s)   evid: %10.0f  \n',magnitude(p),evtimestr{p},setting.waveforms.station,setting.waveforms.comp{1},evid(p));
end
linkaxes(axesplt(:), 'x');
disp(' ');





function [cellstrEnd,cellstrBegin] = getBeginEndTimeFromTzero(evtime,evtimestr,setting)
% settingTRC.time.start = '_2013-09-20 02:06:35_';
% settingTRC.time.end ='_2013-09-20 02:07:40_';   

for p=1:size(evtime,1)
    % compute Datenum format from the time strings (DB used, Textfile used)
    exactstr1 = epoch2str(evtime(p),'%G %H:%M:%S');
    exactstr2 = epoch2str(evtime(p)+setting.waveforms.timewindow,'%G %H:%M:%S');
    cellstrBegin{p} = sprintf('_%s_',exactstr1);
    cellstrEnd{p} =  sprintf('_%s_',exactstr2);
end










 
 




