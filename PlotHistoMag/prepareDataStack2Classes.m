function [datastack,setting] = prepareDataStack2Classes(data1,data2,setting)
flagfakedate = 0;
datastack = [];

%fülle leerbereiche bzw. Lücken auf
[zdatenum,zdatstr,interval] = getZDatenums(setting);

%sortiere nach Datum
data1 = sortrows(data1,1);
data2 = sortrows(data2,1);

switch setting.temporalresolution
    case 'j'
        [datastack,setting] = stackDataYearly2classes(data1,data2,zdatstr,setting);
    case 'h'
         fprintf('Option %s (setting.temporalresolution) not supported until now! \n',setting.temporalresolution);
    case 'd'
         fprintf('Option %s (setting.temporalresolution) not supported until now! \n',setting.temporalresolution);
end