function [setting,evid] = readTextFile(setting)
fid = fopen(setting.file.evid,'r');  
header = 1;
p = 0;
while(~feof(fid))
    tline = fgetl(fid);
    if(isempty(tline))
        continue;
    end
    tmp1 = textscan(tline, '%s');
    %[token,remain] = strtok(tmp1,',');
    tmp1 = tmp1{1};
    if numel(tmp1)>=6
        if header == 1
           if tmp1{1} == 'evid'
              header = 0;
           end
        else
          idx = strfind(tmp1{1}, '#');
          if isempty(idx)
            p = p + 1;
            evid(p,1) = str2num(tmp1{1});    %evid
            evid(p,2) = str2num(tmp1{2});    %acc max (cm/s²) BGWA
            evid(p,3) = str2num(tmp1{3});    %acc max (cm/s²) UMW
            evid(p,4) = str2num(tmp1{4});    %acc max (cm/s²) WIWA
            evid(p,5) = str2num(tmp1{5});    %acc max (cm/s²) KMWA
            evid(p,6) = str2num(tmp1{6});    %acc max (cm/s²) SNWA
          end
        end
    end
end
fclose(fid);
setting.file.counts = p;