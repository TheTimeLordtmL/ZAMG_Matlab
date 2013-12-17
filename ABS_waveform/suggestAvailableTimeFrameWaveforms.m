function suggestAvailableTimeFrameWaveforms(setting,strstation,curr_component)
% use waveform (wfdisc) db to suggest available time frames of the 
% specified station and channels. The output is maximum number of 3.


% /get available time frames
db = dbopen(setting.db.events,'r');
dbextr = dblookup(db,'','wfdisc','','');
strcomponents = sprintf('chan==''%s''',curr_component);
str_querry1 = sprintf('sta==''%s'' && %s',strstation,strcomponents);
%str_querry1 = sprintf('time <= %s && endtime >= %s && sta==''%s''',setting.time.start,setting.time.end,strstation);
dbtimextr = dbsubset(dbextr,str_querry1);
n = dbnrecs(dbtimextr);
if n > 0
    format long;
    [time,endtime,nsamp,samprate] = dbgetv(dbtimextr,'time','endtime','nsamp','samprate');
    %look for the best 1 or (3) time frames
    [time,endtime,nsamp,samprate] = reduceTimeFrames(time,endtime,nsamp,samprate,setting,1);
    displayAvailableTimes(time,endtime,nsamp,samprate);
end
dbclose(db);




function [timeOut,endtimeOut,nsampOut,samprateOut] = reduceTimeFrames (time,endtime,nsamp,samprate,setting,numberReduce)

timestart = str2epoch(setting.time.start);
timeend = str2epoch(setting.time.end);
timecenter = (timestart+timeend)/2;

timeres2 = abs(time-timecenter);
[sortedt,ind] = sortrows(timeres2);

timeOut = time(ind);
endtimeOut = endtime(ind);
nsampOut = nsamp(ind);
samprateOut = samprate(ind);

if size(timeOut,1)>numberReduce
    timeOut = timeOut(1:numberReduce);
    endtimeOut = endtimeOut(1:numberReduce);
    nsampOut = nsampOut(1:numberReduce);
    samprateOut = samprateOut(1:numberReduce);
end





function displayAvailableTimes(time,endtime,nsamp,samprate)

strtime = '';
for p=1:size(time,1)
    exactstr1 = epoch2str(time(p),'%G %H:%M:%S');
    exactstr2 = epoch2str(endtime(p),'%G %H:%M:%S');
    strtime = sprintf('%s %s <-> %s ?? ',strtime,exactstr1,exactstr2);
end
fprintf('%s \n',strtime);

