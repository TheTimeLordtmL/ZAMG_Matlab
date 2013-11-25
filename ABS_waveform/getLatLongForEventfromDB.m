function [lat,lon,depth,ml,mb] = getLatLongForEventfromDB(setting,event)
lat = [];    lon = [];     depth = [];

 
% // Origin based query
%open db and first subset
db = dbopen(setting.db.events,'r');
dborigin = dblookup(db,'','origin','','');
str_querry1 = sprintf('evid == %f',event);
dborigin = dbsubset(dborigin,str_querry1);

%join with event :orid\#prefor
dbevent = dblookup(dborigin,'','event','','');
dbj = dbjoin(dborigin,dbevent);
str_querry2 = 'orid==prefor';
dbj1 = dbsubset(dbj,str_querry2);

n = dbnrecs(dbj1);
if n>0
    [lat,lon,depth,ml,mb] = dbgetv(dbj1,'lat','lon','depth','ml','mb');
    dbclose(db);
else
    fprintf('NO data were extracted from %15g to get event location \n',event);
end
