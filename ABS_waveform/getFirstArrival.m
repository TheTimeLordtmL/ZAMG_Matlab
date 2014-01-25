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
            % found no result
            currdata = data(p,:);
            [currevtime,currevtimestr,currevid] = getEventOriginTime(currdata,setting);
            evphase = '-';  auth{p} = 'n.a.';
            evtimestr{p} = currevtimestr{1};
            evtime(p) = currevtime;
            evid(p) = currevid;            
        case 1
            % found 1 result (normal)
            [timeflt,evidn,phase,authtmp] = dbgetv(dbsub2,'arrival.time','evid','phase','auth');
            evtimestr{p} = strtime(dbgetv(dbsub2,'arrival.time'));
            auth{p} = authtmp;
            evphase = phase;
            evtime(p) = timeflt;
            evid(p) = evidn;
        otherwise
            %found more than 1 results
            if n > 1
                % take the first entry: may be sort for earliest pick?
                dbsub2 = dbsort(dbsub2,'arrival.time');
                [timeflt,evidn,oridn,phase,authtmp,arid,chan,timeres,deltim] = dbgetv(dbsub2,'arrival.time','evid','orid','phase','auth','arid','chan','timeres','deltim');
                [indexbest] = getIndexbestForMultiplePicks(timeflt,evidn,oridn,phase,authtmp,arid,chan,timeres,deltim,setting); 
                tmptime = strtime(dbgetv(dbsub2,'arrival.time'));
                auth{p} = authtmp{indexbest};
                evphase = phase{indexbest};
                evtimestr{p} = tmptime{indexbest};
                evtime(p) = timeflt(indexbest);
                evid(p) = evidn(indexbest);
            end
    end

    fprintf('..add phase %s picked at %s by author %s (%g records found in DB)\n',evphase,evtimestr{p},auth{p},n);
end
fprintf('\n');











