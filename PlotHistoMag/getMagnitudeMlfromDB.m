function magnitude = getMagnitudeMlfromDB(data,setting)


curr_database = setting.DB.DBpath;
for p=1:size(data,1)
    %open db and first subset
    
    db = dbopen(curr_database,'r');
    dborigin = dblookup(db,'','origin','','');
    str_querry1 = sprintf('orid == %10.0f',data(p,5));
    dbsub = dbsubset(dborigin,str_querry1);
      
    %join with event :orid\#prefor
    dbevent = dblookup(dbsub,'','event','','');
    dbj = dbjoin(dbsub,dbevent);
    str_querry2 = 'orid==prefor';
    dbj1 = dbsubset(dbj,str_querry2);
    
    %join with netamg
    dbnetmag = dblookup(dbj1,'','netmag','','');
    dbj2 = dbjoin(dbj1,dbnetmag);
    
    %dbsubsets
    str_querry3 = 'magtype == ''ml''';
    dbsub2 = dbsubset(dbj2,str_querry3);
    str_querry4 = 'magnitude > -999.0';
    dbsub2 = dbsubset(dbsub2,str_querry4);
    %dbsub2 = dbsort(dbsub2,'time');
    n = dbnrecs(dbsub2);  
    [ml] = dbgetv(dbsub2,'ml');
    magnitude(p)= ml;
end