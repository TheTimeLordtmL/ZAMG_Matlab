function CurTraceFilt = filterBandpass(CurTrace,currSps,setting)

curNyquist = currSps / 2;
[b,a] = butter(setting.filter.numpolesdisplace,[setting.filter.Lbound setting.filter.Hbound]/curNyquist, 'bandpass');
CurTraceFilt = filtfilt(b, a, CurTrace); 