function CurTraceFilt = filterLowCutOff(CurTrace,currSps,setting)

curNyquist = currSps / 2;
[b,a] = butter(setting.filter.numpolesdisplace, setting.filter.lowcutoffdisplace/curNyquist, 'high');
CurTraceFilt = filtfilt(b, a, CurTrace); 