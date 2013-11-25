function analyzePhases(setting)

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

%get the phases
[phasesP,phasesstructP] = getPhases(setting,data,'P'); 
%[phasesS,phasesstructS] = getPhases(setting,data,'S'); 



disp('finshced');