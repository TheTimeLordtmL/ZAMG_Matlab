function [FeltEQ,setting] = getAllFeltEvents(setting)
% read all felt EarthQuakes ('fe' 'de') from the specified
%  database e.g. 
%  /net/zagsun17/export/home/seismo/antelope/db/zagsun17
% 
FeltEQ = [];  
tic;
 
%open db and first subset
switch setting.db.etype
    case 'eq'
       strfprint = 'EQ''s'; 
       db = dbopen(setting.db.events,'r');
       dborigin = dblookup(db,'','origin','','');
%       str_querry1 = sprintf('time >= %s && time <= %s && (etype == ''fe'' || etype ==''de'' || etype ==''ke'')',setting.time.start,setting.time.end);
       str_querry1 = sprintf('time >= %s && time <= %s && (etype == ''fe'' || etype ==''de'' || etype ==''ke'') && auth!~/.*EDR.*/',setting.time.start,setting.time.end);
       dborigin = dbsubset(dborigin,str_querry1);
    case 'other'
       strfprint = 'Other Events'; 
       db = dbopen(setting.db.events,'r');
       dborigin = dblookup(db,'','origin','','');
       str_querry1 = sprintf('time >= %s && time <= %s && (etype != ''fe'' && etype !=''de'' && etype !=''-'' && etype !=''ke'') && auth!~/.*EDR.*/',setting.time.start,setting.time.end);
       dborigin = dbsubset(dborigin,str_querry1);       
end

%join with event :orid\#prefor
dbevent = dblookup(dborigin,'','event','','');
dbj = dbjoin(dborigin,dbevent);
str_querry2 = 'orid==prefor';
dbj1 = dbsubset(dbj,str_querry2);

%join with netamg
dbnetmag = dblookup(dbj1,'','netmag','','');
dbj2 = dbjoin(dbj1,dbnetmag);

%dbsubsets 
if setting.useshape.useLandgrenzen == 1;   
  str_querry3 = 'magtype == ''ml''';
  dbsub = dbsubset(dbj2,str_querry3);
else
  dbsub = dbj2;
end
str_querry4 = 'magnitude > -999.0';
dbsub = dbsubset(dbsub,str_querry4);
dbsub = dbsort(dbsub,'time');
n = dbnrecs(dbsub);
if n>0
 [timeflt,lat,lon,ml,etype,magtype,evname,auth,orid,evid] = dbgetv(dbsub,'time','lat','lon','ml','etype','magtype','evname','auth','orid','evid');
 dbclose(db);
 FeltEQ.timeflt = timeflt;
 FeltEQ.lat = lat;
 FeltEQ.lon = lon;
 FeltEQ.ml = ml;
 FeltEQ.etype = etype;
 FeltEQ.magtype = magtype;
 FeltEQ.evname = evname;
 FeltEQ.auth = auth;
 FeltEQ.orid = orid;
 FeltEQ.evid = evid;
 FeltEQ.timestr = epoch2str(timeflt,'%G %H:%M:%S');
 FeltEQ.timespan = ones(numel(timeflt),1)*setting.time.span;
 setting.datacountorig = numel(timeflt);
 setting.time.from = min(timeflt);
 setting.time.to = max(timeflt);
 t = toc;
 fprintf('%g %s were extracted from %s (%4.1f s)\n',setting.datacountorig,strfprint,setting.db.events,t);
else
 setting.datacountorig = 0;  FeltEQ = [];
 setting.time.from = 0; setting.time.to = 0;
 t = toc;
 fprintf('NO %s were extracted from %s (%4.1f s)\n',strfprint,setting.db.events,t);
 disp('You may need to specify another time span.');
end





