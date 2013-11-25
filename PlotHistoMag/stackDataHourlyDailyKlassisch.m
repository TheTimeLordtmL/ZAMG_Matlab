function [datastack] = stackDataHourlyDailyKlassisch(data,interval,setting)
%compute the magnitude stack for the hourly/daily period
z = 0; j = 1;
for h=fix(setting.from):interval:ceil(setting.to)
    z = z + 1;
    ind = find(data(:,1)==h);
    currday = data(ind,:);
    datastack(z,j) = size(currday,1);
end