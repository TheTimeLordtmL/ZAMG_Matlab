function [nearestCity,isinside] = findNearestCity(curr_B,curr_L,setting)
val = 1.5; %val in degree to constrain the db query per rectangle
isinside = 0;


%open db and first subset
db = dbopen(setting.showAllEventsforaCity.europe_small_cities,'r');
dborigin = dblookup(db,'','places','','');
str_querry1 = sprintf('lat <= %8.4f && lat >= %8.4f && lon <= %8.4f && lon >= %8.4f',curr_B+val,curr_B-val,curr_L+val,curr_L-val);
dborigin = dbsubset(dborigin,str_querry1);
n = dbnrecs(dborigin);
if n>0
 [placename,lat,lon] = dbgetv(dborigin,'place','lat','lon');
 %fprintf('%g Cities''s were extracted from %s. \n',n,setting.showAllEventsforaCity.europe_small_citiess);
else
 nearestCity = [];
 fprintf('NO SIGNIFICANT Citie''s were extracted from %s. \n',setting.showAllEventsforaCity.europe_small_cities);
end
dbclose(db);

if n>0
    %//sort by distance
    origlat = ones(numel(lat),1) * curr_B;
    origlon = ones(numel(lon),1) * curr_L;
    [s,a12,a21] = vdist(lat,lon,origlat,origlon);
    sdistkm = s/1000;
    mindist = min(sdistkm);
    ind = find(sdistkm==mindist);
    if numel(ind) > 1
        ind = ind(1);
    end
    nearestCity.lat = lat(ind);
    nearestCity.lon = lon(ind);
    nearestCity.name = placename(ind);
    isinside = 1;
else
    nearestCity = [];
end




