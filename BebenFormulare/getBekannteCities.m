function BekannteCities = getBekannteCities(x_lim,y_lim,setting)
%outputs location and name of cities within
%the specified rectangle
tic;  
BekannteCities = [];

%open db and first subset
db = dbopen(setting.showSignificantEQs.bekanntecities,'r');
dborigin = dblookup(db,'','place','','');
str_querry1 = sprintf('lat <= %8.4f && lat >= %8.4f && lon <= %8.4f && lon >= %8.4f',y_lim(2),y_lim(1),x_lim(2),x_lim(1));
dborigin = dbsubset(dborigin,str_querry1);
n = dbnrecs(dborigin);
if n>0
 [placename,lat,lon] = dbgetv(dborigin,'placename','lat','lon');
 dbclose(db);
 BekannteCities.lat = lat;  
 BekannteCities.lon = lon; 
 BekannteCities.name = placename; 
 t = toc;
 fprintf('%g Cities''s were extracted from %s (%4.1f s)\n',n,setting.showSignificantEQs.bekanntecities,t);
else
 BekannteCities = [];
 t = toc;
 fprintf('NO SIGNIFICANT Citie''s were extracted from %s (%4.1f s)\n',setting.showSignificantEQs.bekanntecities,t);
end


