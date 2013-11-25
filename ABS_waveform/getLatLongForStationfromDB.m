function [lat,lon,elev] = getLatLongForStationfromDB(setting,station)
lat = [];    lon = [];    elev = [];

 
% // Origin based query
%open db and first subset
db = dbopen(setting.db.events,'r');
dborigin = dblookup(db,'','site','','');
str_querry1 = sprintf('sta == ''%s''',station);
dborigin = dbsubset(dborigin,str_querry1);


n = dbnrecs(dborigin);
if n>0
    [lat,lon,elev] = dbgetv(dborigin,'lat','lon','elev');
    dbclose(db);
else
    fprintf('NO data were extracted from %s to get station coords \n',station);
end


