function showEventAcceleration(setting)
% prepare data for distance dependend plots of acceleration or velocity

[stations,origin,setting] = getDBevidInOutParameters(setting);
[stations] = changeUnitsMgUgtoCMpers(stations,setting);

% (optional) add/fix values manually
if setting.addFixStationsManually == 1
    stations = addFixStationsManually(setting,stations);
end 

plotAccelerationDistance(stations,origin,setting);









