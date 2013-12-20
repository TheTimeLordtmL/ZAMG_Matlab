function [limit,xtickvallabel,xtickval] = getXticksXtickLabelsMag(datastack,setting,zdatstring,interval,xtickold)
%compute the disered xticks with labels as
% specified in the setting

zdatstr0 = zdatstring{1};
zdatstr1 = zdatstring{2};
zdatestr2 = zdatstring{3};
zdatestr3 = zdatstring{4};

tageabstand = setting.period.count /setting.xticknumber;
if setting.temporalresolution=='j'
    xtickval = 1:ceil(tageabstand):size(setting.xlabelname,1);
    z = 0;
    for p=1:ceil(tageabstand):size(setting.xlabelname,1)
         z = z + 1;
        valuenum = datenum(setting.xlabelname(p,:),'yyyy');
        xtickvallabel{z} = datestr(valuenum,'yyyy');
    end
    limit.xlim = [0 size(datastack,1)+1];
    limit.ylim = setting.ylim;
end
if setting.temporalresolution=='m'
    xtickval = xtickold;
    for p=1:size(setting.xlabelname,1)
        valuenum = datenum(setting.xlabelname(p,:),'mm/yyyy');
        xtickvallabel{p} = datestr(valuenum,'mmm');
    end
    limit.xlim = [0 size(datastack,1)+1];
    limit.ylim = setting.ylim;
end
if setting.temporalresolution=='d'
    %tmp = fix(setting.from):ceil(tageabstand)*interval:ceil(setting.to);
    %tageabstand = numel(tmp)/setting.xticknumber;
    p = 0;
    for z=fix(setting.from):ceil(tageabstand)*interval:ceil(setting.to)
        p = p + 1;
        xtickvallabel{p} = sprintf('%s%s%s%s',datestr(z,zdatstr0),zdatestr2,datestr(z,zdatstr1),zdatestr3);
        if p==1
            xtickval(p) = 1;
        else
            xtickval(p) = xtickval(p-1)+ceil(tageabstand);
        end
    end
    limit.xlim = [xtickval(1)-1 setting.period.count+1]; 
    limit.ylim = setting.ylim;
end
if setting.temporalresolution=='h' 
    tmp = fix(setting.from):ceil(tageabstand)*interval:ceil(setting.to);
    tageabstand = numel(tmp)/setting.xticknumber;
    p = 0;
    for z=fix(setting.from):ceil(tageabstand)*interval:ceil(setting.to)
        p = p + 1;
        xtickvallabel{p} = sprintf('%s%s%s%s',datestr(z,zdatstr0),zdatestr2,datestr(z,zdatstr1),zdatestr3);
        if p==1
            xtickval(p) = 1;
        else
            xtickval(p) = xtickval(p-1)+ceil(tageabstand);
        end
    end
    limit.xlim = [xtickval(1)-1 xtickval(p)+1]; 
    limit.ylim = setting.ylim;
end