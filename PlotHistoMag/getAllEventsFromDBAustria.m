function [setting,data,datastruct] = getAllEventsFromDBAustria(setting,flag)
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
if strcmp(flag,'periodhist')
  curr_database = setting.DB.DBpath; 
  curr_start = '_1000-01-01 00:00_';
  curr_end = '_1900-01-01 00:00_';
end
if strcmp(flag,'periodseisgraph')
  curr_database = setting.DB.DBpath; 
  curr_start = '_1900-01-01 00:00_';
  curr_end = '_2001-01-01 00:00_';
end
if strcmp(flag,'periodlast20year')
  curr_database = setting.DB.DBpath; 
  yearnow = datestr(now, 'yyyy');
  curr_start = sprintf('_%4g-01-01 00:00_',str2num(yearnow)-1-20);
  curr_end = sprintf('_%4g-01-01 00:00_',str2num(yearnow));
end
if setting.DB.userectangle == 3
    %no constrainst, %1..near Austria, 2..user specified, 3..no geographic filter
    fprintf('..opening DB %s with no geographic constraints (getAllEventsFromAustria)\n',curr_database);
else
    fprintf('..opening DB %s  Bmin:%5.2f Bmax:%5.2f  Lmin:%5.2f Lmax:%5.2f (getAllEventsFromAustria)\n',curr_database,setting.DB.rectangle.Bmin,setting.DB.rectangle.Bmax,setting.DB.rectangle.Lmin,setting.DB.rectangle.Lmax);
end
tic;

%open db and first subset
db = dbopen(curr_database,'r');
dborigin = dblookup(db,'','origin','','');
if setting.DB.userectangle == 3
    %no constrainst, %1..near Austria, 2..user specified, 3..no geographic filter
    str_querry1 = sprintf('time >= %s && time <= %s',curr_start,curr_end);    
else
    str_querry1 = sprintf('time >= %s && time <= %s && lat >= %6.2f && lat <= %6.2f && lon >= %6.2f && lon <= %6.2f',curr_start,curr_end,setting.DB.rectangle.Bmin,setting.DB.rectangle.Bmax,setting.DB.rectangle.Lmin,setting.DB.rectangle.Lmax);
end
dborigin = dbsubset(dborigin,str_querry1);

%join with event :orid\#prefor
dbevent = dblookup(dborigin,'','event','','');
dbj = dbjoin(dborigin,dbevent);
str_querry2 = 'orid==prefor';
dbj1 = dbsubset(dbj,str_querry2);

%join with meval and search 'felt' earthquakes
if setting.filter.Felt == 1 || setting.eqlist.useinensities == 1
    dbmeval = dblookup(dbj1,'','meval','','');
    dbmevalj1 = dbjoin(dbj1,dbmeval);
    if setting.eqlist.useinensities == 1
        str_querryfelt = sprintf('(inull >= %3.1f && i_est != ''y'')',setting.eqlist.minintensity);
    else
        str_querryfelt = sprintf('( etype == ''fe'' && inull >= %3.1f && i_est != ''y'') || ( etype == ''ke'' && inull >= %3.1f && i_est != ''y'') || ( etype == ''de'' && inull >= %3.1f && i_est != ''y'')',setting.felt.minintensity,setting.felt.minintensity,setting.felt.minintensity);
    end
    dbj1 = dbsubset(dbmevalj1,str_querryfelt);
    n = dbnrecs(dbj1);
else
    %join with netamg
    dbnetmag = dblookup(dbj1,'','netmag','','');
    dbj2 = dbjoin(dbj1,dbnetmag);
    
    %dbsubsets
    str_querry3 = 'magtype == ''ml''';
    dbsub = dbsubset(dbj2,str_querry3);
    str_querry4 = 'magnitude > -999.0';
    dbsub = dbsubset(dbsub,str_querry4);
    dbsub = dbsort(dbsub,'time');
    n = dbnrecs(dbsub);
end


if n>0
    if setting.filter.Felt == 1 || setting.eqlist.useinensities == 1
        [timeflt,lat,lon,ml,etype,orid,depth,evname,inull] = dbgetv(dbj1,'time','lat','lon','ml','etype','orid','depth','evname','inull');
        timestr = strtime(dbgetv(dbj1,'time'));
    else
        [timeflt,lat,lon,ml,etype,orid,depth,evname] = dbgetv(dbsub,'time','lat','lon','ml','etype','orid','depth','evname');
        inull = ones(size(ml,1),1);
        timestr = strtime(dbgetv(dbsub,'time'));
    end
    %  1      2   3   4   5    6     7
    dbclose(db);
    fprintf('DB fetched! - %g data sets were found (getAllEventsFromDBAustria.m).\n',n); disp('...start saving the data');
    if setting.felt.showFeltEQhisto==1
        showInullHistogram(timestr,inull,setting);
    end
    [data,datastruct,setting] = saveDBdata(timestr,timeflt,lat,lon,ml,etype,orid,depth,evname,inull,setting);
else
    t = toc;
    fprintf('NO EQ''s were extracted from %s (%4.1f s) (getAllEventsFromDBAustria.m)\n',curr_database,t);
    disp('You may need to specify another time span, DB or region.');
end
