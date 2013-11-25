function [placename,lat,lon] = findNearestCity2(setting)

%open db and first subset
db = dbopen(setting.showAllEventsforaCity.europe_small_cities,'r');
dborigin = dblookup(db,'','places','','');
%str_querry1 = sprintf('lat <= %8.4f && lat >= %8.4f && lon <= %8.4f && lon >= %8.4f',curr_B+val,curr_B-val,curr_L+val,curr_L-val);
str_querry1 = sprintf('lat >= %8.4f && lat <= %8.4f && lon >= %8.4f && lon <= %8.4f',setting.DB.rectangle.Bmin,setting.DB.rectangle.Bmax,setting.DB.rectangle.Lmin,setting.DB.rectangle.Lmax);

dborigin = dbsubset(dborigin,str_querry1);
n = dbnrecs(dborigin);
if n>0
 [placename,lat,lon] = dbgetv(dborigin,'place','lat','lon');
 dbclose(db);

 %fprintf('%g Cities''s were extracted from %s. \n',n,setting.showAllEventsforaCity.europe_small_citiess);
else
 placename = [];
 lat = [];
 lon = [];
 fprintf('NO SIGNIFICANT Citie''s were extracted from %s. \n',setting.showAllEventsforaCity.europe_small_cities);
end



