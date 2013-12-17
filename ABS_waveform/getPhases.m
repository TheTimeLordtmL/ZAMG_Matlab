function [phases,phasesstruct] = getPhases(setting,data,strPhase)
%phases .. arrivtime | arid | deltime | delta
phases = [];  phasesstruct = [];  strcount = 0;
curr_database = setting.DB.DBpath;

for k=1:size(data,1)
    fprintf('.');
    if mod(k,50)
       fprintf('.+50\n') ;
    end
    
    %open db and first subset
    db = dbopen(curr_database,'r');
    dborigin = dblookup(db,'','origin','','');
    str_querry1 = sprintf('orid == %g',data(k,5));
    dborigin = dbsubset(dborigin,str_querry1);
    
    %join assoc
    dbassoc = dblookup(dborigin,'','assoc','','');
    dbjassoc = dbjoin(dborigin,dbassoc);
    
    %join arrival
    dbarrival = dblookup(dbjassoc,'','arrival','','');
    dbjarrival = dbjoin(dbjassoc,dbarrival);
    
    str_querry2 = sprintf('phase=~/%s./ && delta<=%f',strPhase,setting.phases.maximumdelta);
    dbsub2 = dbsubset(dbjarrival,str_querry2);
 
    if setting.phases.useonlyZAMGstation == 1
        str_querry3 = sprintf('sta=~/%s/',setting.phases.ZAMG);
        dbsubfinal = dbsubset(dbsub2,str_querry3);
    else
        dbsubfinal = dbsub2;
    end
    
    n = dbnrecs(dbsubfinal);
    
    if n>0
        [time,phase,sta,arid,arrivtime,deltime,delta] = dbgetv(dbsubfinal,'time','phase','sta','arid','arrival.time','deltim','delta');
        dbclose(db);
        phases = [phases;arrivtime arid deltime delta];
        %fill the struct array
        for r=1:numel(time)
            if delta(r)>0
                strcount = strcount + 1;
                phasesstruct(strcount).time = time(r);
                phasesstruct(strcount).phase = phase(r);
                phasesstruct(strcount).sta = sta(r);
                phasesstruct(strcount).arid = arid(r);
                phasesstruct(strcount).time = time(r);
                phasesstruct(strcount).arrivtime = arrivtime(r);
                phasesstruct(strcount).deltime = deltime(r);
                phasesstruct(strcount).delta = delta(r);
            end
        end
    end
end

disp('kl');