function [timestr] = getLatestManuallIntensityFilledInAEC(setting)
% use the specified path (setting.DB.DBpath;) to the AEC Catalog and output the most recent
% timestring where the catalog has been filled with the epicentral intensity values manually. 
timestr = '';

%e.g. /net/zagsun26/iscsi/homes/rt/antelope/bebenkatalog/AEC_css30
% or /net/zagsun17/export/home/seismo/bebenkatalog/AEC


%open db 
curr_database = setting.DB.DBpath;
db = dbopen(curr_database,'r');
dborigin = dblookup(db,'','origin','','');
str_querry1 = sprintf('time >= %s ','_2010-01-01 00:00_');    
dborigin = dbsubset(dborigin,str_querry1);

%join with event and assoc
dbevent = dblookup(dborigin,'','event','','');
dbj = dbjoin(dborigin,dbevent);
str_querry2 = 'orid==prefor';
dbj1 = dbsubset(dbj,str_querry2);
dbmassoc = dblookup(dbj1,'','massoc','','');
dbj2 = dbjoin(dbj1,dbmassoc);

%check if meval exists
dbmeval = dblookup(dbj2,'','meval','','');
n = dbnrecs(dbmeval);
if n<=0
    fprintf('[error] Table meval not found in DB %s \n',curr_database);
    t = toc;
    data = []; datastruct = [];
    return;
end

%join with meval
dbmevalj1 = dbjoin(dbj2,dbmeval);
str_querryfelt = sprintf('(review ==''y'' && i_est == ''n'')');
dbj3 = dbsubset(dbmevalj1,str_querryfelt);
dbj3= dbsort(dbj3,'time');
n = dbnrecs(dbj3);
if n>0
    [timeflt,lat,lon,ml,etype,orid,depth,evname,inull,evid] = dbgetv(dbj3,'time','lat','lon','ml','etype','orid','depth','evname','inull','evid');
    temptimestr = strtime(dbgetv(dbj3,'time'));
    timestr = temptimestr(n);
    timestr = timestr{1};
end

fprintf('[info] The last manual input of inull was found for EQ %s on %s (M=%3.1f, evid=%10.0f)\n',evname{n},timestr,ml(n),evid(n));
disp(' ');

