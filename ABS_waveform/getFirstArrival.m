function [evtime,evtimestr,evid] = getFirstArrival(data,setting)
% read all first arrivals with author /ZAMG/  auth!~/.*EDR.*/ 

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

    %join with assoc
    dbassoc = dblookup(dborigin,'','assoc','','');
    dbj1 = dbjoin(dbsub,dbassoc);  
    
     %join with arrival
    dbarrival = dblookup(dborigin,'','arrival','','');
    dbj2 = dbjoin(dbj1,dbarrival);      

    str_querry2 = sprintf('auth=~/.*ZAMG.*/ && phase=~/P.*/ && sta==''%s'' ',setting.waveforms.station);
    %   str_querry2 = sprintf('auth=~/.*ZAMG.*/ && sta==''%s'' ',setting.waveforms.station);
    dbsub2 = dbsubset(dbj2,str_querry2);
    
    n = dbnrecs(dbsub2);
    switch n
        case 0
            currdata = data(p,:);
            [currevtime,currevtimestr,currevid] = getEventOriginTime(currdata,setting);
            evphase = '';  auth{p} = 'n.a.';
            evtimestr{p} = currevtimestr{1};
            evtime(p) = currevtime;
            evid(p) = currevid;            
        case 1
            [timeflt,evidn,phase,authtmp] = dbgetv(dbsub2,'arrival.time','evid','phase','auth');
            evtimestr{p} = strtime(dbgetv(dbsub2,'time'));
            auth{p} = authtmp;
            evphase = phase;
            evtime(p) = timeflt;
            evid(p) = evidn;
        otherwise
            % take the first entry: may be sort for earliest pick?
            dbsub2 = dbsort(dbsub2,'arrival.time');
            [timeflt,evidn,phase,authtmp] = dbgetv(dbsub2,'arrival.time','evid','phase','auth');
            tmptime = strtime(dbgetv(dbsub2,'time'));
            auth{p} = authtmp;
            evphase = phase{1};
            evtimestr{p} = tmptime{1};
            evtime(p) = timeflt(1);
            evid(p) = evidn(1);           
    end

    fprintf('..add phase %s picked at %s by %s\n',evphase,evtimestr{p},auth{p});
end
fprintf('\n');
