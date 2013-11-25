function [FeltEQ,setting] = applyTimeSpanCorrections(FeltEQ,setting)
% Read and apply time span corrections in hours 
% for each specified event. Acc=minute
% Format csv: '2012-02-19 15:35,0.7'


[setting,data] = readTextFile(setting);

%correct the time span for the specified events
fprintf('Correct the time spans according to %s.\n',setting.corr.timespan);
corrcount = 0;
for k=1:setting.corr.number
   for g=1:numel(FeltEQ.timeflt)
       %if numel(FeltEQ.timeflt)==1  %habe nur 1 Beben gefunden
       %   timestring= FeltEQ.timestr(g);
       %else
          timestEv = FeltEQ.timestr(g); 
          timestring = timestEv{1};
       %end
       strcompi = strcmp(timestring,data(k).timestr);
       if strcompi==1
           FeltEQ.timespan(g) = data(k).corr;
           g = numel(FeltEQ.timeflt);
           corrcount = corrcount + 1;
           fprintf('..set %s to %5.3f. \n',timestring,data(k).corr);  
       end
   end
end
if corrcount==0
  disp('NO corrections applied.');    disp('.');
else
  disp('.');
end




function [setting,data] = readTextFile(setting)
fid = fopen(setting.corr.timespan,'r');  

p = 0;
while(~feof(fid))
    tline = fgetl(fid);
    if(isempty(tline))
        continue;
    end
    tmp1 = textscan(tline, '%19c %s');
    %[token,remain] = strtok(tmp1,',');
    %a = token{1};
    if numel(tmp1)>=2
       p = p + 1;
       curr_datetimestr = tmp1{1};
       a = tmp1{2};
       curr_corr = a{1};
       data(p).timestr = curr_datetimestr;
       data(p).corr = str2num(curr_corr);
    end
end
fclose(fid);
setting.corr.number = p;

