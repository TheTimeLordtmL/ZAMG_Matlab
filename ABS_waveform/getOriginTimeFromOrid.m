function origtime = getOriginTimeFromOrid(setting,orid)
% get the origin time from the orid and the DB defined in setting
origtime = 0;

curr_database = setting.DB.DBpath;
%open db and first subset
db = dbopen(curr_database,'r');
dborigin = dblookup(db,'','origin','','');
str_querry1 = sprintf('orid == %10.0f',orid);
dbsub = dbsubset(dborigin,str_querry1);
n = dbnrecs(dbsub);
if n>0
    [timeflt] = dbgetv(dbsub,'origin.time');
    if numel(timeflt)==1
        origtime = timeflt;
    else
        origtime = timeflt(1);
    end
end
