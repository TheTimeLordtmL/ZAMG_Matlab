function [Reports,setting] = getEqReports(FeltEQ,setting)
%get all reports within a specified time span before and after an event

Reports =  [];
tic;

if numel(FeltEQ.timeflt) > 0
 for k=1:numel(FeltEQ.timeflt)
    curr_timespan = FeltEQ.timespan(k);
    timestart = FeltEQ.timeflt(k) - curr_timespan*60*60;
    timeend = FeltEQ.timeflt(k) + curr_timespan*60*60;
    %if numel(FeltEQ.timeflt)==1  % habe nur 1 Beben gefunden
    %   strevent = FeltEQ.timestr(k); 
    %else
       strevent = FeltEQ.timestr(k); 
       strevent = strevent{1}; 
       stretype = FeltEQ.etype(k);
       stretype = stretype{1};
    %end 
    currmagtype = FeltEQ.magtype(k);
    curr_evname = FeltEQ.evname(k);    curr_evname = char(curr_evname{1});
    fprintf('[%g] %s %s (%3.1f%s) %-16s',k,strevent,stretype,FeltEQ.ml(k),currmagtype{1},curr_evname);
    
    %open db and first subset
    db = dbopen(setting.db.formular,'r');
    dbextr = dblookup(db,'',setting.db.formulartable,'','');
    str_querry1 = sprintf('time >= %f && time <= %f && lat!=NULL && felt==''y''',timestart,timeend);
    dbformextr = dbsubset(dbextr,str_querry1);
    n = dbnrecs(dbformextr);
    Reports(k).formcounts = n;
    Reports(k).distkmlist = [];
    Reports(k).azimlist = [];
    Reports(k).distmax = 0;
    Reports(k).distmin = 0;
    if n>0
        if setting.save.individualforms==1
           strifsaved = '(saved)';
           %querry all basic parameters or strings
           [timeflt,lat,lon,place_input,zip_input,felt,damaging,vulclass,fid] = dbgetv(dbformextr,'time','lat','lon','place_input','zip_input','felt','damaging','vc','fid');
           Reports(k).timeflt = timeflt; 
           Reports(k).lat = lat; 
           Reports(k).lon = lon; 
           Reports(k).place_input = place_input; 
           Reports(k).zip_input = zip_input; 
           origlat = ones(numel(lat),1) * FeltEQ.lat(k);
           origlon = ones(numel(lon),1) * FeltEQ.lon(k);
           [s,a12,a21] = vdist(lat,lon,origlat,origlon);
           Reports(k).distkmlist = s/1000;
           Reports(k).azimlist = a21;
           Reports(k).distmax = max(Reports(k).distkmlist);
           Reports(k).distmin = min(Reports(k).distkmlist);
           Reports(k).felt = felt; Reports(k).damaging = damaging;
           Reports(k).vulnerbclass = vulclass;
           Reports(k).fid = fid;
                      
           %querry all matrix based parameters
           [H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,dam,dg] = dbgetv(dbformextr,'H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','damaging','dg');
           for g=1:numel(dam)
               %convert dam field from string to number 
               if strcmp(dam(g),'y')
                   damnum(g) = 1;
               else
                   damnum(g) = 0;
               end
           end
           Reports(k).damaging = damnum';
           Reports(k).repMatrix = [H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,damnum',dg];
           fprintf('reports= %g %s    %5.0f km\n',n,strifsaved,Reports(k).distmax);
           clear damnum;
        else 
           fprintf('reports= %g               \n',n);
        end       
    else
        fprintf(' No reports were found.\n');
    end
    dbclose(db);
 end

 t = toc;
 fprintf('..needed %4.1f s',t);

 for h=1:k
   tmp(h)=  Reports(h).formcounts;
 end
 fprintf(' - found %g reports.\n',sum(tmp));
else
 fprintf('NO felt EQ''s found within the specified period:\n  from: %s \n    to: %s',setting.time.start,setting.time.end);   
end
%figure;%semilogy(tmp);
%plot(tmp);
disp(' ');

