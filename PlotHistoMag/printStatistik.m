function setting = printStatistik(data,setting)

z = 0;
for h=setting.from:setting.to
    z = z + 1;
    ind = find(data(:,1)==h);
    dataneu = data(ind,:);
    datastack(z) = size(dataneu,1);
end

tmpSNbegin = datenum(setting.fromexcact,'dd.mm.yyyy HH:MM:SS');
tmpSNend = datenum(setting.toexcact,'dd.mm.yyyy HH:MM:SS');
switch setting.temporalresolution
    case 'j'
        setting.period.month = 0;
        setting.period.count = 0;
        strtempres = 'Years';
    case 'm'
        setting.period.month = 0;
        setting.period.count = 0;
        strtempres = 'Months';
    case 'd'
        setting.period.day = (tmpSNend-tmpSNbegin);
        setting.period.count = ceil(setting.period.day);          %gerundet
        strtempres = 'Days';
    case 'h'
        setting.period.hour = (tmpSNend-tmpSNbegin)*24;        %excact
        setting.period.count = ceil(setting.period.hour);          %gerundet
        strtempres = 'Hours';
end
setting.strtempres = strtempres;
fprintf('The data cover a period lasting from %s(%g) to %s(%g)\n',setting.fromSTR,setting.from,setting.toSTR,setting.to);
fprintf('%s: %g  events: %g    sumteststack=%g   date format: %s\n',strtempres,setting.period.count,setting.count,sum(datastack),setting.format.date2);
fprintf('excact begin: %s  \n',setting.fromexcact);
fprintf('excact end:   %s  \n',setting.toexcact);