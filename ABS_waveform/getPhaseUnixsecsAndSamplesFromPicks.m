function [settingout] = getPhaseUnixsecsAndSamplesFromPicks(setting)

%exactstr1 = epoch2str(setting.waveforms.S1,'%G %H:%M:%S');
%exactstr1 = epoch2str(setting.waveforms.P1,'%G %H:%M:%S');
%fprintf('time ev1: start %s   end %s \n  P1=%s   S1=%s\n',setting.time.start1,setting.time.end1,epoch2str(setting.waveforms.P1,'%G %H:%M:%S'),epoch2str(setting.waveforms.S1,'%G %H:%M:%S'));
%fprintf('time ev2: start %s   end %s \n  P2=%s   S2=%s\n',setting.time.start2,setting.time.end2,epoch2str(setting.waveforms.P2,'%G %H:%M:%S'),epoch2str(setting.waveforms.S2,'%G %H:%M:%S'));
[error1] = outputWarningsOn1970Time(setting.waveforms.P1,'P1');
[error2] = outputWarningsOn1970Time(setting.waveforms.P2,'P2');
[error3] = outputWarningsOn1970Time(setting.waveforms.S1,'S1');
[error4] = outputWarningsOn1970Time(setting.waveforms.S2,'S2');

settingout = setting;
settingout.waveforms.timecuts.punixsecs1 = setting.waveforms.P1;
settingout.waveforms.timecuts.punixsecs2 = setting.waveforms.P2;
settingout.waveforms.timecuts.sunixsecs1 = setting.waveforms.S1;
settingout.waveforms.timecuts.sunixsecs2 = setting.waveforms.S2;
settingout.waveforms.timecuts.startdataunixsecs1 = str2epoch(setting.time.start1);
settingout.waveforms.timecuts.startdataunixsecs2 = str2epoch(setting.time.start2);

sps = setting.samplerate{1};
settingout.waveforms.timecuts.psamples1 = round((settingout.waveforms.timecuts.punixsecs1 - settingout.waveforms.timecuts.startdataunixsecs1)*sps);
settingout.waveforms.timecuts.psamples2 = round((settingout.waveforms.timecuts.punixsecs2 - settingout.waveforms.timecuts.startdataunixsecs2)*sps);
settingout.waveforms.timecuts.ssamples1 = round((settingout.waveforms.timecuts.sunixsecs1 - settingout.waveforms.timecuts.startdataunixsecs1)*sps);
settingout.waveforms.timecuts.ssamples2 = round((settingout.waveforms.timecuts.sunixsecs2 - settingout.waveforms.timecuts.startdataunixsecs2)*sps);
fprintf('[Summary Phases:] getPhaseUnixsecsAndSamplesFromPicks.m \n');
fprintf('Phases %s: (P1)%s    (S1)%s    P-S(%3.1f)   (t0)%s\n',setting.station1,epoch2str(setting.waveforms.P1,'%G %H:%M:%S'),epoch2str(setting.waveforms.S1,'%G %H:%M:%S'),setting.waveforms.S1-setting.waveforms.P1,epoch2str(setting.waveforms.t01,'%G %H:%M:%S'));
fprintf('Phases %s: (P2)%s    (S2)%s    P-S(%3.1f)   (t0)%s\n',setting.station2,epoch2str(setting.waveforms.P2,'%G %H:%M:%S'),epoch2str(setting.waveforms.S2,'%G %H:%M:%S'),setting.waveforms.S2-setting.waveforms.P2,epoch2str(setting.waveforms.t02,'%G %H:%M:%S'));

fprintf('[Onsets] Samples P1=%g   P2=%g, S1=%g   S2=%g  \n',settingout.waveforms.timecuts.psamples1,settingout.waveforms.timecuts.psamples2,settingout.waveforms.timecuts.ssamples1,settingout.waveforms.timecuts.ssamples2);



function [error] = outputWarningsOn1970Time(timeunixs,errstr)
error = 0;
if timeunixs == 0
    error = 1;
    fprintf('[warning] This time might be obscured: %s - %s  \n',errstr,epoch2str(timeunixs,'%G %H:%M:%S'));
end
