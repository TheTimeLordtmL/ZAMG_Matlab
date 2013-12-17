function [cellstrEnd,cellstrBegin] = getBeginEndTimeFromPicks(evtime,evtimestr,setting)
% settingTRC.time.start = '_2013-09-20 02:06:35_';
% settingTRC.time.end ='_2013-09-20 02:07:40_';   

for p=1:size(evtime,1)
    % compute Datenum format from the time strings (DB used, Textfile used)
    exactstr1 = epoch2str(evtime(p) - setting.waveforms.tmin,'%G %H:%M:%S');
    exactstr2 = epoch2str(evtime(p) - setting.waveforms.tmin + setting.waveforms.timewindow,'%G %H:%M:%S');
    cellstrBegin{p} = sprintf('_%s_',exactstr1);
    cellstrEnd{p} =  sprintf('_%s_',exactstr2);
end