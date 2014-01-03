function writeOnlyEQList(setting)
minvallandgrenz = 12;

if setting.DB.readfromDB==1
    % //get historic EQ's
       switch setting.DB.userectangle
        case 1  % near Austria - AEC
          [settinghist,datahist,datastructhist] = getAllEventsFromDBAustria(setting,'normal'); 
        case 2  % user specified - zagsunxx
          [settinghist,datahist,datastructhist] = getAllEventsFromDBWorld(setting,'normal');   
        otherwise  % no geographic filter
          [settinghist,datahist,datastructhist] = getAllEventsFromDBWorld(setting,'normal');   
    end 
    
    % plot data within Landesgrenzen (see getSetting.m)
    if setting.useshape.useLandgrenzen == 1;
        [datahist,datastructhist,settinghist] = filterDataWithinPolygonShp(datahist,datastructhist,settinghist,'normal');
    end

    % // Filter the data for Magnitude or Intensity
    if setting.filter.Felt == 0
        [datahist,settinghist,datastructhist] = filterDataMagnitudeExclude(datahist,datastructhist,settinghist);
    end
    
    %Filter the data: revome 'km','sm' etc. (see getSetting.m)
    if setting.filter.UseTheFilter==1
        [datahist,excludedtypehist,settinghist,datastructhist] = filterDataEtypeExclude(datahist,datastructhist,settinghist,'normal');
        if numel(datahist)<=0
            fprintf('All data were filtered and NO EVENTS remain!\n');
        end
    end
    if setting.useshape.selectedLandgrenzen > minvallandgrenz
        [datastructhist] = replaceEvnameOutsideAustria2(datastructhist,settinghist);
    end
end

writeBebenListe(setting,datastructhist);
if setting.eqlist.format ~= 99
    writeBebenOnlytoKML(setting,datastructhist)
end



