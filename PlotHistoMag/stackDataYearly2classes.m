
function [datastack,setting] = stackDataYearly2classes(data1,data2,zdatstr,setting)
%compute the magnitude stack for the yearly period
datadatestr1 = datestr(data1(:,1),'yyyy'); datadatestr2 = datestr(data2(:,1),'yyyy');
datadatenum1 = datenum(datadatestr1,'yyyy'); datadatenum2 = datenum(datadatestr2,'yyyy');
ddatstr1 = unique([datadatestr1;zdatstr],'rows'); ddatstr2 = unique([datadatestr2;zdatstr],'rows');
ddatenum1 = datenum(ddatstr1,'yyyy'); ddatenum2 = datenum(ddatstr2,'yyyy');
setting.xlabelname = ddatstr1;
z = 0;   setting.period.count = numel(ddatenum1);
for h=1:numel(ddatenum1)
    z = z + 1;
    monatnum1 = ddatenum1(h);
    monatnum2 = ddatenum2(h);
    ind1 = find(datadatenum1==monatnum1);
    ind2 = find(datadatenum2==monatnum2);
    currday1 = data1(ind1,:);
    currday2 = data2(ind2,:);
    datastack(z,1) = size(currday1,1);
    datastack(z,2) = size(currday2,1);
end
disp(' ');