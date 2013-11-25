function [datastack] = stackDataHourlyDaily(data,interval,setting)
%compute the magnitude stack for the hourly/daily period
z = 0;
for h=fix(setting.from):interval:ceil(setting.to)
    z = z + 1;
    ind = find(data(:,1)==h);
    currday = data(ind,:);
    for j=1:numel(setting.stacks)
        alteMag = setting.stacks{j};
        if j >= numel(setting.stacks)
            neueMag = 99;
        else
            neueMag = setting.stacks{j+1};
        end
        ind2 = find(currday(:,5)>= alteMag & currday(:,5)<neueMag);
        currday_magclass = currday(ind2,:);
        datastack(z,j) = size(currday_magclass,1);
    end
end
