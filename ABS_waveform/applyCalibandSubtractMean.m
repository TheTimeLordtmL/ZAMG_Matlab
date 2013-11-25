function [dataVout,dataAout,setting] = applyCalibandSubtractMean(dataV,dataA,setting)

% remove mean and apply calib
if setting.intitialunit == 'V'
    dataAout = dataA;
    for p=1:numel(setting.comp)
        tmp = dataV{p}./setting.unit.factor;   % to provide nm/s > cm/s.*setting.calib{p};
        dataVout{p} = tmp - mean(tmp);
    end
end

if setting.intitialunit == 'A'
    dataVout = dataV;
    for p=1:numel(setting.comp)
        tmp = dataA{p}./setting.unit.factor;   % to provide nm/s² > cm/s² ???  .*setting.calib{p};
        dataAout{p} = tmp - mean(tmp);
    end
end
