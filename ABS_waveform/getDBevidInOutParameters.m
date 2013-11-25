function [stations,origin,setting] = getDBevidInOutParameters(setting)
% read all felt EarthQuakes ('fe' 'de') from the specified
%  database e.g. 
%  /net/zagsun17/export/home/seismo/antelope/db/zagsun17
% 
stations = [];  origin = []; 
strtmp = sprintf('%18.0f',setting.evid);
dbpath = fullfile(setting.pathDBinout,sprintf('dbin%s',strtrim(strtmp)));
tic;
 
% // Origin based query
%open db and first subset
db = dbopen(dbpath,'r');
dborigin = dblookup(db,'','origin','','');
str_querry1 = sprintf('evid == %f',setting.evid);
dborigin = dbsubset(dborigin,str_querry1);

%join with event :orid\#prefor
dbevent = dblookup(dborigin,'','event','','');
dbj = dbjoin(dborigin,dbevent);
str_querry2 = 'orid==prefor';
dbj1 = dbsubset(dbj,str_querry2);

%join with netamg
dbnetmag = dblookup(dbj1,'','netmag','','');
dbj2 = dbjoin(dbj1,dbnetmag);

n = dbnrecs(dbj2);
if n>0
    [timeflt,lat,lon,ml,etype,magtype,evname,auth,orid,evid] = dbgetv(dbj2,'time','lat','lon','ml','etype','magtype','evname','auth','orid','evid');
    dbclose(db);
    origin2.timeflt = timeflt;
    origin2.lat = lat;
    origin2.lon = lon;
    origin2.ml = ml;
    origin2.etype = etype;
    origin2.magtype = magtype;
    origin2.evname = evname;
    origin2.auth = auth;
    origin2.orid = orid;
    origin2.evid = evid;
    origin2.timestr = epoch2str(timeflt,'%G %H:%M:%S');
    t = toc;
    fprintf('%g data were extracted from %s (%4.1f s)\n',n,dbpath,t);
else
    t = toc;
    fprintf('NO data were extracted from %s (%4.1f s)\n',dbpath,t);
end

% // use the prefored magtype
magtypestr = ' ';
typemb = -999;   typeml = -999;  saveid = 0;
for k=1:numel(origin2.evid)
    currmagtype =  origin2.magtype{k};
    switch currmagtype
        case 'mb'
            typemb = 1;      %mb was found   
            saveid = k;
            magtypestr = currmagtype;
        case  'ml'
            typeml = 1;     %ml was found
            k = numel(origin2.evid);   
            saveid = k;   
            magtypestr = currmagtype;
            break;
    end
end
origin.timeflt =  origin2.timeflt(saveid);
origin.lat =  origin2.lat(saveid);
origin.lon  =  origin2.lon(saveid);
origin.ml =  origin2.ml(saveid);
origin.etype =  origin2.etype(saveid);
origin.magtype =  origin2.magtype(saveid);
origin.evname =  origin2.evname(saveid);
origin.auth  =  origin2.auth(saveid);
origin.orid =  origin2.orid(saveid);
origin.evid  =  origin2.evid(saveid);
origin.timestr =  origin2.timestr(saveid);


% // Station based data
% % open db and first subset

% dbnetmag = dblookup(dbj1,'','netmag','','');
% dbj2 = dbjoin(dbj1,dbnetmag);

db = dbopen(dbpath,'r');
dbwfmeas = dblookup(db,'','wfmeas','','');
dbsite = dblookup(db,'','site','','');
dbjoinwf = dbjoin(dbwfmeas,dbsite);
dbsit = dbsort(dbjoinwf,'sta');
n = dbnrecs(dbsit);
if n>0
 [timeflt,timefltmeas,lat,lon,val1,val2,units1,units2,sta,chan] = dbgetv(dbsit,'time','tmeas','lat','lon','val1','val2','units1','units2','sta','chan');
 dbclose(db);
end
stations.timeflt = timeflt;
stations.timestr = epoch2str(timeflt,'%G %H:%M:%S');
stations.timefltmeas = timefltmeas;
stations.timestrmwas = epoch2str(timefltmeas,'%G %H:%M:%S');
stations.lat = lat;
stations.lon = lon;
stations.val1 = val1;
stations.val2 = val2;
stations.units1 = units1;
stations.units2 = units2;
stations.sta = sta;
stations.chan = chan;

origlat = ones(numel(lat),1) * origin.lat;
origlon = ones(numel(lon),1) * origin.lon;
[s,a12,a21] = vdist(lat,lon,origlat,origlon);
stations.distkmlist = s/1000;
stations.azimlist = a21;

% db = dbopen(dbpath,'r');
% dborigin = dblookup(db,'','origin','','');
% str_querry1 = sprintf('evid == %f',setting.evid);
% dborigin = dbsubset(dborigin,str_querry1);
% 
% %join with event :orid\#prefor
% dbevent = dblookup(dborigin,'','event','','');
% dbj = dbjoin(dborigin,dbevent);
% str_querry2 = 'orid==prefor';
% dbj1 = dbsubset(dbj,str_querry2);
% 
% %join with netamg
% dbnetmag = dblookup(dbj1,'','netmag','','');
% dbj2 = dbjoin(dbj1,dbnetmag);
% 
% str_querry3 = sprintf('magtype=="%s"',currmagtype);
% dbmagtype = dbsubset(dbj2,str_querry3);
% 
% %join with assoc arrival site
% dbassoc = dblookup(dbmagtype,'','assoc','','');
% dbass = dbjoin(dbmagtype,dbassoc);
% dbarrival = dblookup(dbass,'','assoc','','');
% dbarr = dbjoin(dbass,dbarrival);
% dbsite = dblookup(dbarr,'','assoc','','');
% dbsit = dbjoin(dbarr,dbsite);
% 
% dbsit = dbsort(dbsit,'sta');
% n = dbnrecs(dbsit);
% if n>0
%  [timeflt,lat,lon,ml,etype,magtype,evname,auth,orid,evid] = dbgetv(dbsub,'time','lat','lon','ml','etype','magtype','evname','auth','orid','evid');
%  dbclose(db);
%  FeltEQ.timeflt = timeflt;
%  FeltEQ.lat = lat;
%  FeltEQ.lon = lon;
%  FeltEQ.ml = ml;
%  FeltEQ.etype = etype;
%  FeltEQ.magtype = magtype;
%  FeltEQ.evname = evname;
%  FeltEQ.auth = auth;
%  FeltEQ.orid = orid;
%  FeltEQ.evid = evid;
%  FeltEQ.timestr = epoch2str(timeflt,'%G %H:%M:%S');
%  FeltEQ.timespan = ones(numel(timeflt),1)*setting.time.span;
%  setting.datacountorig = numel(timeflt);
%  setting.time.from = min(timeflt);
%  setting.time.to = max(timeflt);
%  t = toc;
%  fprintf('%g %s were extracted from %s (%4.1f s)\n',setting.datacountorig,strfprint,setting.db.events,t);
% else
%  setting.datacountorig = 0;  FeltEQ = [];
%  setting.time.from = 0; setting.time.to = 0;
%  t = toc;
%  fprintf('NO %s were extracted from %s (%4.1f s)\n',strfprint,setting.db.events,t);
%  disp('You may need to specify another time span.');
% end
% 
% 
% 


