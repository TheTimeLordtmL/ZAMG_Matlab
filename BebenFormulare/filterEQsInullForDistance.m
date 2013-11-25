function [EQneu] = filterEQsInullForDistance(EQlist,setting)
%use the setting.logNJahr.distmax value to filter
% the data

ind = find(EQlist.distancekm(:)<=setting.logNJahr.distmax);

if numel(ind)==1
 EQneu.timeflt = EQlist.timeflt(ind);  
 EQneu.lat = EQlist.lat(ind);
 EQneu.lon = EQlist.lon(ind) ;
 EQneu.depth =  EQlist.depth(ind) ;
 EQneu.ml = EQlist.ml(ind);
 EQneu.inull = EQlist.inull(ind); 
 EQneu.mmacro = EQlist.mmacro(ind);
 EQneu.etype = {EQlist.etype(ind)};
 EQneu.magtype = {EQlist.magtype(ind)};
 EQneu.evname = {EQlist.evname(ind)};
 EQneu.auth = {EQlist.auth(ind)};
 EQneu.timestr = {EQlist.timestr(ind)};
 EQneu.orid = EQlist.orid(ind);
 EQneu.evid =  EQlist.evid(ind);
 EQneu.distancekm = EQlist.distancekm(ind);
 EQneu.ilocal = EQlist.ilocal(ind);
 EQneu.accel = EQlist.accel(ind);
 EQneu.damaging = {EQlist.damaging(ind)};
 EQneu.questionable = {EQlist.questionable(ind)};    
else
 EQneu.timeflt = EQlist.timeflt(ind);  
 EQneu.lat = EQlist.lat(ind);
 EQneu.lon = EQlist.lon(ind) ;
 EQneu.depth =  EQlist.depth(ind) ;
 EQneu.ml = EQlist.ml(ind);
 EQneu.inull = EQlist.inull(ind); 
 EQneu.mmacro = EQlist.mmacro(ind);
 EQneu.etype = EQlist.etype(ind);
 EQneu.magtype = EQlist.magtype(ind);
 EQneu.evname = EQlist.evname(ind);
 EQneu.auth = EQlist.auth(ind);
 EQneu.timestr = EQlist.timestr(ind);
 EQneu.orid = EQlist.orid(ind);
 EQneu.evid =  EQlist.evid(ind);
 EQneu.distancekm = EQlist.distancekm(ind);
 EQneu.ilocal = EQlist.ilocal(ind);
 EQneu.accel = EQlist.accel(ind);
 EQneu.damaging = EQlist.damaging(ind);
 EQneu.questionable = EQlist.questionable(ind);         
end

fprintf('filter: Inull for distances <= %g km, - removed were %g records.\n',setting.logNJahr.distmax,numel(EQlist.timeflt(:))-numel(EQneu.timeflt(:)));




