function [dataout,excludedtype,setting,datastructout] = filterDataEtypeExclude(data,datastruct,setting,flag)

exclude = setting.filter.WhichData;
excludtype = { };
flag = ones(size(data,1),1);
z = 0; t = 0;
for p=1:size(data,1)
    sflag = 0;
    for k=1:numel(exclude)
        tmp =  exclude{k};
        if strcmp(datastruct(p).etype,tmp)==1
            flag(p,1) = 0;
            z = z + 1;
            sflag = 1;
            k = numel(exclude);
        end
    end
    if sflag == 0
       t = t + 1;
       excludtype(t) = cellstr(datastruct(p).etype);
    end
end
ind = find(flag==1);
dataout = data(ind,:);  clear data;
datastructout = datastruct(ind);        %store the datastruct

%set a new time min/max
if min(dataout(:,1)) < setting.from
    if strcmp(flag,'normal') || strcmp(flag,'periodhist') || strcmp(flag,'periodseisgraph') || strcmp(flag,'periodlast20year')
        setting.from = min(dataout(:,1));
    end
    if strcmp(flag,'reference')
        setting.fromref = min(dataout(:,1));
    end
end
if max(dataout(:,1)) > setting.to
    if strcmp(flag,'normal') || strcmp(flag,'periodhist') || strcmp(flag,'periodseisgraph') || strcmp(flag,'periodlast20year')
        setting.to = max(dataout(:,1));
        setting.filter.NumberEtypeExclude = z;
    end
    if strcmp(flag,'reference')
        setting.toref = max(dataout(:,1));
        setting.filter.NumberEtypeExcluderef = z;
    end
end

[a,b] = unique(excludtype);
excludedtype.etypes = a;
excludedtype.firstappear = b;
excludedtype.flaglist = flag;

%create the string for the excluded data
strdataexc = '';
for k=1:numel(setting.filter.WhichData)
    strdataexc = sprintf('%s %s',strdataexc,setting.filter.WhichData{k});
end

if strcmp(flag,'normal') || strcmp(flag,'periodhist') || strcmp(flag,'periodseisgraph') || strcmp(flag,'periodlast20year')
    setting.filter.excludedDataStr = strdataexc;
    fprintf('Number of excluded data is %g for eType =%s. \n',setting.filter.NumberEtypeExclude,setting.filter.excludedDataStr);
end
if strcmp(flag,'reference')
    setting.filter.excludedDataStrref = strdataexc;
    fprintf('Number of excluded dataref is %g for eType =%s. \n',setting.filter.NumberEtypeExcluderef,setting.filter.excludedDataStrref);
end

% for p=1:setting.count
%    e(p) =  cellstr(datastruct(p).etype);
% end
% [a,b] = unique(e);