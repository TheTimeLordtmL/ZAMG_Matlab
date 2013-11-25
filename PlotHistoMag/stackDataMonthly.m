
function [datastack,setting] = stackDataMonthly(data,zdatstr,setting)
%compute the magnitude stack for the monthly period
datadatestr = datestr(data(:,1),'mm/yyyy');
datadatenum = datenum(datadatestr,'mm/yyyy');
ddatstr = unique([datadatestr;zdatstr],'rows');
ddatenum = datenum(ddatstr,'mm/yyyy'); setting.xlabelname = ddatstr;
z = 0;   setting.period.count = numel(ddatenum);
for h=1:numel(ddatenum)
    z = z + 1;
    monatnum = ddatenum(h);
    ind = find(datadatenum==monatnum);
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
