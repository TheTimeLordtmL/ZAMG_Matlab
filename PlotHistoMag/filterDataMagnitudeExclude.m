function [dataout,setting,datastructout] = filterDataMagnitudeExclude(data,datastruct,setting,minmag)
% // filter data by minimal magnitude value

flag = zeros(size(data,1),1);

for p=1:size(data,1)
    if setting.saveDBmode == 0
        currml = data(p,5);
    end
    if setting.saveDBmode == 1
        currml = data(p,4);
    end
    if currml >= minmag
        flag(p,1) = 1;
    end
end
ind = find(flag==1);
dataout = data(ind,:);  clear data;
datastructout = datastruct(ind);        %store the datastruct
