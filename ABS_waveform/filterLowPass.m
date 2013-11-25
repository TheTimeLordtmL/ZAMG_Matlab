function CurTraceFilt = filterLowPass(CurTrace,currSps,setting)

curNyquist = currSps / 2;
[b,a] = butter(setting.filter.numpolesdisplace, setting.filter.lowpassoffdisplace/curNyquist, 'low');
CurTraceFilt = filtfilt(b, a, CurTrace); 