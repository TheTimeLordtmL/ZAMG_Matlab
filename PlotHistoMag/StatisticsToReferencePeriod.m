function [currStats,refStats] = StatisticsToReferencePeriod(setting)
%Statistik (mit Vergleich zu Mittlerer Periode, Wiederkehrperiode (ab 1900)
dataref = [];  data = [];  datastruct = [];   datastructref = []; 

% // check if the reference data has also to be taken (same region?, same timespan?)
if setting.statref.currRun > 1
    if strcmp(setting.statref.title{1},setting.statref.title{setting.statref.currRun})==0 || strcmp(setting.statref.timespan{1},setting.statref.timespan{setting.statref.currRun})==0
        setting.computeRefstats = 1;
    end
end

% // get the data from the DB
if setting.DB.readfromDB==1
    switch setting.DB.userectangle
        case 1  % near Austria - AEC
            [setting,data,datastruct] = getAllEventsFromDBAustria(setting,'normal');
            if setting.computeRefstats == 1
                [setting,dataref,datastructref] = getAllEventsFromDBAustria(setting,'reference');
            end
        case 2  % user specified - zagsunxx
            [setting,data,datastruct] = getAllEventsFromDBWorld(setting,'normal');
            if setting.computeRefstats == 1
                [setting,dataref,datastructref] = getAllEventsFromDBWorld(setting,'reference');
            end
        otherwise  %no geographic filter
            [setting,data,datastruct] = getAllEventsFromDBWorld(setting,'normal');
            if setting.computeRefstats == 1
                [setting,dataref,datastructref] = getAllEventsFromDBWorld(setting,'reference');
            end
    end
else  
  [setting,data,datastruct] = readTextFile(setting);
end
%[setting] = printStatistik(data,setting);

% plot data within Landesgrenzen (see getSetting.m)
if setting.useshape.useLandgrenzen == 1;
    [data,datastruct,setting] = filterDataWithinPolygonShp(data,datastruct,setting,'normal');
    if setting.computeRefstats == 1
        [dataref,datastructref,setting] = filterDataWithinPolygonShp(dataref,datastructref,setting,'reference');
    end
end

%Filter the data: revome 'km','sm' etc. (see getSetting.m)
if setting.filter.UseTheFilter==1
    [data,excludtype,setting] = filterDataEtypeExclude(data,datastruct,setting,'normal');
    if numel(data)<=0
        fprintf('All data were filtered and NO EVENTS remain!\n');
    end
    if setting.computeRefstats == 1
        [dataref,excludtyperef,setting] = filterDataEtypeExclude(data,datastructref,setting,'reference');
        if numel(dataref)<=0
            fprintf('All dataref were filtered and NO EVENTS remain!\n');
        end
    end
end

[currStats,refStats] = getStatisticsReferenceToCurrStats(data,dataref,setting);
