function writeOnlyEQList(setting)
minvallandgrenz = 12;

if setting.DB.readfromDB==1
    % //get historic EQ's
    
    [settinghist,datahist,datastructhist] = getAllEventsFromDBAustria(setting,'normal');
    disp(' ');
    % plot data within Landesgrenzen (see getSetting.m)
    if setting.useshape.useLandgrenzen == 1;
        [datahist,datastructhist,settinghist] = filterDataWithinPolygonShp(datahist,datastructhist,settinghist,'periodhist');
    end
    %Filter the data: revome 'km','sm' etc. (see getSetting.m)
    if setting.filter.UseTheFilter==1
        [datahist,excludedtypehist,settinghist,datastructhist] = filterDataEtypeExclude(datahist,datastructhist,settinghist);
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



