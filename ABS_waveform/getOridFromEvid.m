function oridOut = getOridFromEvid(setting,evid)
oridOut = 0;

curr_database = setting.DB.DBpath;
%open db and first subset

db = dbopen(curr_database,'r');
dborigin = dblookup(db,'','origin','','');
str_querry1 = sprintf('evid == %10.0f',evid);
dbsub = dbsubset(dborigin,str_querry1);

%join with event :orid\#prefor
dbevent = dblookup(dbsub,'','event','','');
dbj = dbjoin(dbsub,dbevent);
str_querry2 = 'orid==prefor';
dbj1 = dbsubset(dbj,str_querry2);

n = dbnrecs(dbj1);
if n>0
    [oridOut,time,ml] = dbgetv(dbj1,'orid','time','ml');
    if ~isempty(ml)
       fprintf(' orid %10.0f resolved for evid %10.0f (%s Magnitude Ml=%3.1f) \n',oridOut,evid,time,ml);
    else
       fprintf(' orid %10.0f resolved for evid %10.0f (%s)  \n',oridOut,evid,time); 
    end
else
    fprintf('[error] Could not find the orid for evid %10.0f\n',evid);
end
dbclose(db);