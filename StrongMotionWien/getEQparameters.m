function [FeltEQ,setting] = getEQparameters(setting,curr_evid)
FeltEQ = [];  
tic;
 
%open dB
db = dbopen(setting.db.aec,'r');
dborigin = dblookup(db,'','origin','','');
str_querry1 = sprintf('evid == %10.0f',curr_evid);
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
str_querry4 = 'magnitude > -999.0';
dbsub = dbsubset(dbsub,str_querry4);
dbsub = dbsort(dbsub,'time');
n = dbnrecs(dbsub);
if n>0
 [timeflt,lat,lon,ml,etype,magtype,evname,auth,orid,evid,depth,inull,mmacro] = dbgetv(dbsub,'time','lat','lon','ml','etype','magtype','evname','auth','orid','evid','depth','inull','mmacro');
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
 FeltEQ.depth = depth;
 FeltEQ.inull = inull;
 FeltEQ.mmacro = mmacro;
 FeltEQ.timestr = epoch2str(timeflt,'%G %H:%M:%S');
 setting.datacountorig = numel(timeflt);
 t = toc;
 fprintf('Evid: %10.0f - found in %s (%4.1f s)\n',curr_evid,setting.db.aec,t);
else
 setting.datacountorig = 0;  FeltEQ = [];
 t = toc;
 fprintf('Evid: %10.0f - NOT found in %s (%4.1f s)\n',curr_evid,setting.db.aec,t);
 disp('You may need to specify another time span.');
end


