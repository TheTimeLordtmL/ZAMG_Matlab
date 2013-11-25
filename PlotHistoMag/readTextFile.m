function [setting,data,datastruct] = readTextFile(setting)
tic;
fid = fopen(setting.filepath,'r');  

p = 0;
while(~feof(fid))
    tline = fgetl(fid);
    if(isempty(tline))
        continue;
    end
    tmp1 = textscan(tline, '%s %s %s %s %s %s %s %s');
    %10/05/2012   47.8361   16.1614    0.0000    1.33 sm  1043284
    if numel(tmp1)>=7
       p = p + 1;
       curr_datestr = tmp1{1};
       curr_timestr = tmp1{2};
       curr_latstr = tmp1{3};
       curr_lonstr = tmp1{4};
       curr_depthstr = tmp1{5};
       curr_magstr = tmp1{6};
       curr_etypestr = tmp1{7};
       curr_oridstr = tmp1{8}; 
       curr_datetimestr = sprintf('%s %s',curr_datestr{1},curr_timestr{1});
       switch setting.temporalresolution
           case 'j'
               curr_datum = datenum(curr_datetimestr,setting.format.date);
           case 'm'
               curr_datum = datenum(curr_datetimestr,setting.format.date);
           case 'd'
               curr_datum = datenum(curr_datetimestr,setting.format.date);
           case 'h'
               curr_datum = datenum(curr_datetimestr,setting.format.date1);
       end
       data(p,1) = curr_datum;
       data(p,2) = str2double(curr_latstr);
       data(p,3) = str2double(curr_lonstr);
       data(p,4) = str2double(curr_depthstr);
       data(p,5) = str2double(curr_magstr);
       curr_datum_excact = datenum(curr_datetimestr,setting.format.date2);
       data(p,6) = curr_datum_excact;
       datastruct(p).date = curr_datum;
       datastruct(p).origin.lat = str2double(curr_latstr);
       datastruct(p).origin.lon = str2double(curr_lonstr);
       datastruct(p).origin.depth = str2double(curr_depthstr);
       datastruct(p).netmag = str2double(curr_magstr);
       datastruct(p).etype = curr_etypestr;
       datastruct(p).orid = str2double(curr_oridstr);
       if mod(p,2000)==0
           fprintf('.');
           if mod(p,10000)==0
               fprintf('|');
               if mod(p,20000)==0
                   fprintf(' +20k\n');
               end
           end
       end
    end
end
fclose(fid);

t = toc;
disp(' ');
fprintf('Read %g lines from %s in %5.1f seconds.\n',p,setting.filepath,t);
setting.count = p;  setting.countold = p;
setting.from = min(data(:,1));      %date grouped
setting.to = max(data(:,1));        %date grouped
setting.fromSTR = datestr(min(data(:,1)),'dd.mm.yyyy HH:MM:SS');
setting.toSTR = datestr(max(data(:,1)),'dd.mm.yyyy HH:MM:SS');
setting.fromexcact = datestr(min(data(:,6)),'dd.mm.yyyy HH:MM:SS'); %date excact
setting.toexcact = datestr(max(data(:,6)),'dd.mm.yyyy HH:MM:SS');   %date excact

