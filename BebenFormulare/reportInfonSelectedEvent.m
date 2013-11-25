
function infoSelectEvent = reportInfonSelectedEvent(FeltEQ,Reports,indexnu)
% // generate an struct 'infoSelectEvent' with the following fields:
% /   {1}..Selected event [1] is on 2012-02-01  {2}..Magnitude: 3.2ml
% /   {3}..Location: Pitten 48.3332 16.4531  {4}..Reports: 234   evid: 522124    orid: 105475
% /   {5}..date  {6}..magnitude  {7}..location  {8}..curr_timespan  
% /   {9}..timeflt {10}..latitude  {11}..longitude
 strevent = FeltEQ.timestr(indexnu);
 currmagtype = FeltEQ.magtype(indexnu);
 curr_evname = FeltEQ.evname(indexnu);
 curr_lat = FeltEQ.lat(indexnu);
 curr_lon = FeltEQ.lon(indexnu);
infoSelectEvent{1} = sprintf('Selected event [%g] is on %s \n',indexnu,strevent{1});
infoSelectEvent{2} = sprintf('Magnitude: %3.1f%s \n',FeltEQ.ml(indexnu),currmagtype{1});
infoSelectEvent{3} = sprintf('Location: %-16s  %5.3f(lat) %5.3f(lon)\n',curr_evname{1},curr_lat,curr_lon);
infoSelectEvent{4} = sprintf('Reports: %g   evid: %10.0f    orid: %10.0f \n',Reports(indexnu).formcounts,FeltEQ.evid(indexnu),FeltEQ.orid(indexnu));
fprintf(' %s\n %s \n %s\n %s\n',infoSelectEvent{1},infoSelectEvent{2},infoSelectEvent{3},infoSelectEvent{4});
  token = strtok(strevent{1}, ' ');
infoSelectEvent{5} = strtrim(token);   %date
infoSelectEvent{6} = FeltEQ.ml(indexnu);    %magnitude
  token = strtok(curr_evname{1}, ' ');
infoSelectEvent{7} = strtrim(token);   %location
infoSelectEvent{8} = FeltEQ.timespan(indexnu);  %curr_timespan
infoSelectEvent{9} = FeltEQ.timeflt(indexnu); %FeltEQ.timeflt(k) 
infoSelectEvent{10} = curr_lat;  %latitude
infoSelectEvent{11} = curr_lon;  %longitude



