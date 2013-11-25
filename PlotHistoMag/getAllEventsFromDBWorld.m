function [setting,data,datastruct] = getAllEventsFromDBWorld(setting,flag)
% read all EarthQuakes from a specified
%  database e.g. 
%  /net/zagsun17/export/home/seismo/antelope/db/zagsun17
%  
if strcmp(flag,'normal')
  curr_database = setting.DB.DBpath;
  curr_start = setting.time.start;
  curr_end =setting.time.end; 
end
if strcmp(flag,'reference')
  curr_database = setting.DB.refDBpath; 
  curr_start = setting.time.refstart;
  curr_end = setting.time.refend;
end
fprintf('..opening DB %s\n',curr_database);
tic;
 
%open db and first subset
db = dbopen(curr_database,'r');
dborigin = dblookup(db,'','origin','','');
if setting.DB.userectangle == 3
  str_querry1 = sprintf('time >= %s && time <= %s',setting.time.start,setting.time.end);
else    
  str_querry1 = sprintf('time >= %s && time <= %s && lat >= %6.2f && lat <= %6.2f && lon >= %6.2f && lon <= %6.2f',curr_start,curr_end,setting.DB.rectangle.Bmin,setting.DB.rectangle.Bmax,setting.DB.rectangle.Lmin,setting.DB.rectangle.Lmax);
end
dborigin = dbsubset(dborigin,str_querry1);

%join with event :orid\#prefor
dbevent = dblookup(dborigin,'','event','','');
dbj = dbjoin(dborigin,dbevent);
str_querry2 = 'orid==prefor';
dbj1 = dbsubset(dbj,str_querry2);

%join with netamg
dbnetmag = dblookup(dbj1,'','netmag','','');
dbj2 = dbjoin(dbj1,dbnetmag);

%dbsubsets 
dbj2 = dbsort(dbj2,'ml','ms','mb');
dbj2 = dbsort(dbj2,'orid','dbSORT_UNIQUE');
dbsub = dbsort(dbj2,'time');
n = dbnrecs(dbsub);
if n>0
 [timeflt,lat,lon,ml,etype,orid,depth,evname] = dbgetv(dbsub,'time','lat','lon','magnitude','etype','orid','depth','evname');
 timestr = strtime(dbgetv(dbsub,'time'));
 %  1      2   3   4   5    6     7
 dbclose(db);
 fprintf('DB fetched! - %g data sets were found (getAllEventsFromDBWorld.m).\n',n); disp('...start saving the data');
 [data,datastruct,setting] = saveDBdata(timestr,timeflt,lat,lon,ml,etype,orid,depth,evname,setting);
                            % saveDBdata(timestr,timeflt,lat,lon,ml,etype,orid,depth,evname,setting)
else
 t = toc;
 fprintf('NO EQ''s were extracted from %s (%4.1f s) (getAllEventsFromDBWorld.m)\n',curr_database,t);
 disp('You may need to specify another time span, DB or region..');
end