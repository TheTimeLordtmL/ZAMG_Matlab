function [data,datastruct,setting] = saveDBdata(timestr,timeflt,lat,lon,ml,etype,orid,depth,evname,inull,evid,setting)
%10/05/2012   47.8361   16.1614    0.0000    1.33 sm  1043284
 % set the date string format (DB used, Textfile used)
  switch setting.temporalresolution
     case 'j'
         curr_datum0 = epoch2str(timeflt,'%G');        
         dateformat = 'yyyy-mm-dd';
     case 'm'
         curr_datum0 = epoch2str(timeflt,'%G');
         dateformat = 'yyyy-mm-dd';
     case 'd'
         curr_datum0 = epoch2str(timeflt,'%G');
         dateformat = 'yyyy-mm-dd';  
     case 'h'
         curr_datum0 = epoch2str(timeflt,'%G %H');
         dateformat = 'yyyy-mm-dd HH';     
  end
  
  % compute Datenum format from the time strings (DB used, Textfile used)
  exactstr = epoch2str(timeflt,'%G %H:%M:%S');
  dateformat2 = 'yyyy-mm-dd HH:MM:SS';
  if numel(timeflt) > 1
      tmp = cell2mat(curr_datum0);
  else
      tmp = curr_datum0;
  end
for r=1:numel(timeflt)
    curr_str = strcat(tmp(r,:));
    curr_datum(r) = datenum(curr_str,dateformat);
    curr_strexact = strcat(exactstr(r,:));
    curr_datum_excact(r) = datenum(curr_strexact,dateformat2);
    datastruct(r).date = curr_datum_excact(r);
    datastruct(r).datestr = timestr(r);
    datastruct(r).origin.lat = lat(r);
    datastruct(r).origin.lon = lon(r);
    datastruct(r).origin.depth = depth(r);
    datastruct(r).netmag = ml(r);
    datastruct(r).etype = etype(r);
    datastruct(r).orid = orid(r);
    datastruct(r).evname = evname(r);
    datastruct(r).inull = inull(r);
    datastruct(r).evid = evid(r);
      if mod(r,2000)==0
           fprintf('.');
           if mod(r,10000)==0
               fprintf('|');
               if mod(r,20000)==0
                   fprintf(' +20k\n');
               end
           end
      end       
end
if setting.saveDBmode == 0
    data(:,1) = curr_datum';
    data(:,2) = lat;
    data(:,3) = lon;
    data(:,4) = depth;
    data(:,5) = ml;
    data(:,6) = curr_datum_excact';
    data(:,7) = inull ;
    data(:,8) = evid ;
end
if setting.saveDBmode == 1
    data(:,1) = curr_datum';
    data(:,2) = lat;
    data(:,3) = lon;
    data(:,4) = ml;
    data(:,5) = orid;
    data(:,6) = depth ;
    data(:,7) = inull ;
    data(:,8) = evid ;
end

setting.datacountorig = numel(timeflt);
setting.time.from = min(timeflt);
setting.time.to = max(timeflt);
t = toc;
fprintf('%g EQ''s were extracted from %s (%4.1f s)\n',setting.datacountorig,setting.DB.DBpath,t);
setting.count = numel(timeflt);  setting.countold = numel(timeflt);
setting.from = min(data(:,1));      %date grouped
setting.to = max(data(:,1));        %date grouped
setting.fromSTR = datestr(min(data(:,1)),'dd.mm.yyyy HH:MM:SS');
setting.toSTR = datestr(max(data(:,1)),'dd.mm.yyyy HH:MM:SS');
setting.fromexcact = datestr(min(data(:,6)),'dd.mm.yyyy HH:MM:SS'); %date excact
setting.toexcact = datestr(max(data(:,6)),'dd.mm.yyyy HH:MM:SS');   %date excact

