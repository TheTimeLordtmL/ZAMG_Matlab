function [evtime,evtimestr,evid] = getEventOriginTime(data,setting)
% read all event times from a specified
%  database e.g. 
%  /net/zagsun17/export/home/seismo/antelope/db/zagsun17
%  

curr_database = setting.DB.DBpath;
evtime = zeros(size(data,1),1);
evid = evtime;
for p=1:size(data,1)
    %open db and first subset
    db = dbopen(curr_database,'r');
    dborigin = dblookup(db,'','origin','','');
    str_querry1 = sprintf('orid == %10.0f',data(p,5));
    dbsub = dbsubset(dborigin,str_querry1);
    n = dbnrecs(dbsub);
    [timeflt,evidn] = dbgetv(dbsub,'time','evid');
    evtimestr{p} = strtime(dbgetv(dbsub,'time'));
    evtime(p) = timeflt;
    evid(p) = evidn;
    fprintf('.');
end
fprintf('..add origin time %s\n',evtimestr{p});
%fprintf('\n');

