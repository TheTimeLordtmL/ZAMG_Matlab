function stationsout = addFixStationsManually(setting,stations)

filesfound = 0;
for h=1:setting.manuallStationsRecords
    for k=1:numel(stations.val1(:))
        currsta = setting.manuallStations(h).sta;
        currchan = setting.manuallStations(h).chan;
        if strcmp(currsta,stations.sta(k)) && strcmp(currchan,stations.chan(k))
            fprintf('[info]: add/fix %s-%s from value %8.2f to %8.2f %s (ind=%3g).   \n',currsta,currchan,stations.val1(k),setting.manuallStations(h).val1,setting.manuallStations(h).units1,k);
            stations.val1(k) = 0;
            stations.val2(k) = 0;            
            stations.val1cm(k) = setting.manuallStations(h).val1;
            stations.val2cm(k) = setting.manuallStations(h).val2;
            stations.units1(k) = {setting.manuallStations(h).units1};
            stations.units2(k) = {setting.manuallStations(h).units2};
            k = numel(stations.val1(:));
            filesfound = 1;
        end
    end
end

if filesfound == 0
   fprintf('sub addFixStationsManually(setting,stations): no data correlated to add/fix amplitude vals.  \n'); 
end
stationsout = stations;