function Auto = getAutokorrelation(dataV,dataA,setting)
% compute the autocorrelation
AutoData = [];  AutoMaxVal = [];

if setting.intitialunit == 'V'
    for p=1:numel(setting.comp)
        dataTRC{p} = dataV{p};
    end
end
if setting.intitialunit == 'A'
    for p=1:numel(setting.comp)
        dataTRC{p} = dataA{p};
    end
end

% //compute autocorrelation of Pshape
maxval = 0;
for p=1:numel(setting.comp)
    ACF{p} = xcorr( dataTRC{p});
    if abs(min(ACF{p})) > maxval
       maxval = abs(min(ACF{p})); 
    end
    if abs(max(ACF{p})) > maxval
       maxval = abs(max(ACF{p})); 
    end
end

% //normalize to 100 percent
for p=1:numel(setting.comp)
  AutoData{p} = 100/maxval*ACF{p};
end
AutoMaxVal = maxval;

%prepare output 
Auto{1} =  AutoData;
Auto{2} =  AutoMaxVal;









