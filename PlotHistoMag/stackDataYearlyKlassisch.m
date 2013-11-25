function [datastack,setting] = stackDataYearlyKlassisch(data,zdatstr,setting)
%compute the magnitude stack for the yearly period
datadatestr = datestr(data(:,1),'yyyy');
datadatenum = datenum(datadatestr,'yyyy');
ddatstr = unique([datadatestr;zdatstr],'rows');
ddatenum = datenum(ddatstr,'yyyy'); setting.xlabelname = ddatstr;
z = 0;  j = 1;  setting.period.count = numel(ddatenum);
for h=1:numel(ddatenum)
    z = z + 1;
    monatnum = ddatenum(h);
    ind = find(datadatenum==monatnum);
    currday = data(ind,:);
    datastack(z,j) = size(currday,1);
end