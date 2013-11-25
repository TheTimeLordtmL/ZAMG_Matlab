function [EQneu] = filterEQsForIlocal(EQlist,setting,intensity)
%use the setting.logNJahr.distmax value to filter
% the data

ind = find(EQlist.ilocal(:)<=intensity+1 & EQlist.ilocal(:)>=intensity);
numbfoundevents = numel(ind);
if numbfoundevents > setting.logNJahr.showlastnumbersofEQs
    ind = ind(numbfoundevents-setting.logNJahr.showlastnumbersofEQs+1:numbfoundevents);
end

if numel(ind)==1
 EQneu.timeflt = EQlist.timeflt(ind);  
 EQneu.ml = EQlist.ml(ind);
 EQneu.inull = EQlist.inull(ind); 
 EQneu.magtype = {EQlist.magtype(ind)};
 EQneu.evname = {EQlist.evname(ind)};
 EQneu.timestr = {EQlist.timestr(ind)};
 EQneu.evid =  EQlist.evid(ind);
 EQneu.distancekm = EQlist.distancekm(ind);
 EQneu.ilocal = EQlist.ilocal(ind);
 EQneu.accel = EQlist.accel(ind);    
else
 EQneu.timeflt = EQlist.timeflt(ind);  
 EQneu.ml = EQlist.ml(ind);
 EQneu.inull = EQlist.inull(ind); 
 EQneu.magtype = EQlist.magtype(ind);
 EQneu.evname = EQlist.evname(ind);
 EQneu.timestr = EQlist.timestr(ind);
 EQneu.evid =  EQlist.evid(ind);
 EQneu.distancekm = EQlist.distancekm(ind);
 EQneu.ilocal = EQlist.ilocal(ind);
 EQneu.accel = EQlist.accel(ind);        
end



