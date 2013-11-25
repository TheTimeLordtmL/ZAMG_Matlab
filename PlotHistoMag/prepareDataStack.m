function [datastack,setting] = prepareDataStack(data,setting)
flagfakedate = 0;

%fülle leerbereiche bzw. Lücken auf
[zdatenum,zdatstr,interval] = getZDatenums(setting);

% markiere die doppelten Tage/Stunden
if  setting.temporalresolution=='d' || setting.temporalresolution=='h'
    zdatenumFlag = zeros(size(zdatenum,1),1);
    dataunique = unique(data(:,1));
    altegroesse = size(dataunique,1);
    for k=1:altegroesse
        for j=1:size(zdatenum,1)
            if dataunique(k)==zdatenum(j)
                zdatenumFlag(j) = 1;
            end
        end
    end
    %speichere und hinzufügen der neuen Tage/Stunden
     if sum(zdatenumFlag)~=size(zdatenum,1)
         disp('[warning] code in sub preparestack.m disabled and may cause wrong output!!');
%         ind = find(zdatenumFlag==0);
%         neuedatenum = zdatenum(ind);
%         tmp = ones(size(neuedatenum,1),5);
%         data = [data;neuedatenum' tmp];
%         flagfakedate = 1;
%         fprintf('Number of faked data points: %g of %g(dates where no data were found)\n',size(neuedatenum,1),size(zdatenum,1));
     end
    %figure; hold on;
    %plot(neuedatenum(:),ones(size(neuedatenum,1)),'rs');
    %plot(dataunique(:),ones(size(dataunique,1)),'bd','MarkerSize',14);
end

%sortiere nach Datum
data = sortrows(data,1);

%suche anzahl an beben pro tag und magnituden klasse
%datastack = NaN((setting.to-setting.from),numel(setting.stacks));
veclen = NaN(numel(setting.stacks),1);
for g=1:numel(setting.stacks)
    veclen(g) = setting.stacks{g};
end

switch setting.temporalresolution
    case 'j'
        [datastack,setting] = stackDataYearly(data,zdatstr,setting);
    case 'm'
        [datastack,setting] = stackDataMonthly(data,zdatstr,setting);
    case 'd'
        [datastack] = stackDataHourlyDaily(data,interval,setting);
    case 'h'
        [datastack] = stackDataHourlyDaily(data,interval,setting);
end


%entferne die leerbereiche bzw. Lücken wieder
if  setting.temporalresolution=='d' || setting.temporalresolution=='h'
    if flagfakedate == 1
        dummy = zeros(1,numel(setting.stacks));
        z = 0;
        for h=fix(setting.from):interval:ceil(setting.to)
            z = z + 1;
            ind2 = find(neuedatenum==h);
            if ~isempty(ind2)
                datastack(z,:) = dummy;
            end
        end
    end
end
disp(' ');