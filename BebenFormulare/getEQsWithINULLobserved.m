function [EQlist] = getEQsWithINULLobserved(setting,B,L)
%get a list of EQ's within a rectangle and above a specified magnitude
EQlist = [];
tic;

%open db and first subset
db = dbopen(setting.db.aec,'r');
dborigin = dblookup(db,'','origin','','');
str_querry1 = sprintf('(etype != ''se'' || etype !=''km'' || etype !=''sm'' || etype !=''sr'' || etype !=''kx'' || etype !=''kl'' || etype !=''uk'' || etype !=''kh'') && time > %s',setting.logNJahr.timestart);
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
%str_querry4 = sprintf('(felt == ''y'' && inull > -9.99 && induced !=''y'') || (i_est != ''y'' && inull > -9.99 && induced !=''y'')');
str_querry4 = sprintf('(i_est != ''y'' && inull > -9.99 && induced !=''y'')');
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
 [s,a12,a21] = vdist(lat,lon,origlat,origlon);
 EQlist.distancekm = s/1000;
 [ilocal,accel] = getIlocalatBL(s/1000,inull,depth,ml,setting);
 EQlist.ilocal = ilocal;
 EQlist.accel = accel;
 EQlist.damaging = damaging;
 EQlist.questionable = questionable;
 t = toc;
 fprintf('%g EQ''s were extracted from %s (%4.1f s)\n',n,setting.db.aec,t);
else
 EQlist = [];
 t = toc;
 fprintf('NO SIGNIFICANT EQ''s were extracted from %s (%4.1f s)\n',setting.db.aec,t);
end