function [currStats,refStats] = getStatisticsReferenceToCurrStats(data,dataref,setting)
% currstats
%
%
% data = timeflt,lat,lon,ml,orid,depth
%          1      2   3   4   5    6   
currStats = []; refStats = [];
currStats.currperiod.ml.accum = sum(data(:,4));
currStats.currperiod.count = size(data,1);
[maxcurr,indcurr] = max(data(:,4));
currStats.currperiod.maxevent.ml = maxcurr;
currStats.currperiod.maxevent.orid = data(indcurr,6);
currStats.currperiod.maxevent.timestr = datestr(data(indcurr,1),'mm.dd.yyyy HH:MM:SS');
currStats.currperiod.daycounts = (str2epoch(setting.time.end) - str2epoch(setting.time.start)) / (60*60*24);

if setting.computeRefstats == 1
    refStats.refperiod.ml.accum = sum(dataref(:,4));
    refStats.refperiod.count = size(dataref,1);
    [maxref,indref] = max(dataref(:,4));
    refStats.refperiod.maxevent.ml = maxref;
    refStats.refperiod.maxevent.orid = dataref(indref,6);
    refStats.refperiod.maxevent.timestr = datestr(dataref(indref,1),'mm.dd.yyyy HH:MM:SS');
    refStats.refperiod.daycounts = (str2epoch(setting.time.refend) - str2epoch(setting.time.refstart)) / (60*60*24);
end


fprintf('.');






disp(' ');
