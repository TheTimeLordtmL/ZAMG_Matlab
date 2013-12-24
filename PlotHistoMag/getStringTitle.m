function [strtitle,jahrvonStr,jahrnachStr] = getStringTitle(setting,streventtype,strregion)
%get string title and string verspürt etc. vom settings
strtitle = '';

if setting.filter.Felt == 0
    strfelt = '';
else
    strfelt = 'Verspürte';
end

tmp = strtok(setting.time.start, '_'); jahrvonStr = strtok(tmp, '-');
tmp = strtok(setting.time.end, '_'); jahrnachStr = strtok(tmp, '-');
tmp2 = (str2epoch(setting.time.end) - str2epoch(setting.time.start))/(60*60*24);
if tmp2 <= 367 && tmp2 >= 364 
    %strtitle = sprintf('%s %s in %s %s-%s',strfelt,streventtype,strregion,jahrvonStr,jahrnachStr); 
    strtitle = sprintf('%s %s in %s - %s',strfelt,streventtype,strregion,jahrvonStr); 
else
    strtitle = sprintf('%s %s in %s %s-%s',strfelt,streventtype,strregion,jahrvonStr,jahrnachStr); 
    %strtitle = sprintf('%s %s in %s - %s',strfelt,streventtype,strregion,jahrvonStr); 
end