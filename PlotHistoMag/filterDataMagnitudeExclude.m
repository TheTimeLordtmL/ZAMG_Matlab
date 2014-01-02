function [dataout,setting,datastructout] = filterDataMagnitudeExclude(data,datastruct,setting)
% // filter data by minimal magnitude value or intensity value

flag = zeros(size(data,1),1);

for p=1:size(data,1)
    %use saveDBmode=0 (see saveDBdata.m)
    if setting.saveDBmode == 0
        if setting.eqlist.useinensities == 0
            currml = data(p,5);
        end
        if setting.eqlist.useinensities == 1
            currint = data(p,7);
        end
    end
    
    %use saveDBmode=1
    if setting.saveDBmode == 1
        if setting.eqlist.useinensities == 0
            currml = data(p,4);
        end
        if setting.eqlist.useinensities == 1
            currint = data(p,7);
        end
    end
    
    %constrain magnitude or intensity
    if setting.eqlist.useinensities == 0
        if currml >= setting.eqlist.minmag
            flag(p,1) = 1;
        end
    end
    if setting.eqlist.useinensities == 1
        if currint >= setting.eqlist.minintensity
            flag(p,1) = 1;
        end
    end
end
ind = find(flag==1);
dataout = data(ind,:);  clear data;
datastructout = datastruct(ind);        %store the datastruct
