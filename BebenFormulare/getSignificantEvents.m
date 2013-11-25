function [EQlist] = getSignificantEvents(B,L,deltaB,deltaL,minMag,setting)
%get a list of EQ's within a rectangle and above a specified magnitude
EQlist = [];
tic;

l1 = L-deltaL/2; l2 = L+deltaL/2;
b1 = B-deltaB/2; b2 = B+deltaB/2;

%open db and first subset
db = dbopen(setting.db.aec,'r');
dborigin = dblookup(db,'','origin','','');
str_querry1 = sprintf('time >= %s && time <= %s',setting.time.start,setting.time.end);
dborigin = dbsubset(dborigin,str_querry1);

%join with event :orid\#prefor
dbevent = dblookup(dborigin,'','event','','');
dbj = dbjoin(dborigin,dbevent);
str_querry2 = 'orid==prefor';
dbj1 = dbsubset(dbj,str_querry2);

%join with netamg
dbnetmag = dblookup(dbj1,'','netmag','','');
dbj2 = dbjoin(dbj1,dbnetmag);

%join with meval
dbmeval = dblookup(dbj2,'','meval','','');
dbj3 = dbjoin(dbj2,dbmeval);

%dbsubsets 
str_querry3 = 'magtype == ''ml''';
dbsub = dbsubset(dbj3,str_querry3);
str_querry4 = sprintf('inull > -9.99');
dbsub = dbsubset(dbsub,str_querry4);
dbsub = dbsort(dbsub,'time');
n = dbnrecs(dbsub);
if n>0
 [timeflt,lat,lon,depth,ml,inull,mmacro,etype,magtype,evname,auth,orid,evid,damaging,questionable] = dbgetv(dbsub,'time','lat','lon','depth','ml','inull','mmacro','etype','magtype','evname','auth','orid','evid','damaging','questionable');
 dbclose(db);
 EQlist.timeflt = timeflt;  
 EQlist.lat = lat;
 EQlist.lon = lon;
 EQlist.depth = depth;
 ml = checkMagorIntensity(ml,inull,depth,timeflt,'ml');
 EQlist.ml = ml;
 inull = checkMagorIntensity(ml,inull,depth,timeflt,'inull');
 EQlist.inull = inull; 
 EQlist.mmacro = mmacro;
 EQlist.etype = etype;
 EQlist.magtype = magtype;
 EQlist.evname = evname;
 EQlist.auth = auth;
 EQlist.timestr = epoch2str(timeflt,'%G %H:%M:%S');
 EQlist.orid = orid;
 EQlist.evid = evid;
 origlat = ones(numel(lat),1) * B;
 origlon = ones(numel(lon),1) * L;
 [s,azi] = vdist(lat,lon,origlat,origlon);
 EQlist.distancekm = s/1000;
 [ilocal,accel] = getIlocalatBL(s/1000,inull,depth,ml,setting);
 EQlist.ilocal = ilocal;
 EQlist.accel = accel;
 EQlist.damaging = damaging;
 EQlist.questionable = questionable; 
 t = toc;
 fprintf('%g Events''s were extracted from %s (%4.1f s)\n',n,setting.db.aec,t);
else
 EQlist = [];
 t = toc;
 fprintf('NO SIGNIFICANT EVENTS''s were extracted from %s (%4.1f s)\n',setting.db.aec,t);
end




