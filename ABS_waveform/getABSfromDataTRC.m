function ABS = getABSfromDataTRC(dataV,dataA,setting)

if setting.intitialunit == 'V'
    for p=1:numel(setting.comp)
        curTrace = dataV{p};
        switch setting.filter.type
            case 'LP'       %low pass
                TraceFilt{p} = filterLowPass(curTrace,setting.samplerate{p},setting);
            case 'HP'       %high pass
                TraceFilt{p} = filterLowCutOff(curTrace,setting.samplerate{p},setting);
            case 'BP'       %band pass
                %emtyp
        end
    end
    ABS{1} = sqrt(dataV{1}.^2.+ dataV{2}.^2.+ dataV{3}.^2);
    ABS{2} = sqrt(TraceFilt{1}.^2.+ TraceFilt{2}.^2.+ TraceFilt{3}.^2);
end
if setting.intitialunit == 'A'
    for p=1:numel(setting.comp)
        curTrace = dataA{p};
        switch setting.filter.type
            case 'LP'       %low pass
                TraceFilt{p} = filterLowPass(curTrace,setting.samplerate{p},setting);
            case 'HP'       %high pass
                TraceFilt{p} = filterLowCutOff(curTrace,setting.samplerate{p},setting);
            case 'BP'       %band pass
                %emtyp
        end
    end
    ABS{1} = sqrt(dataA{1}.^2.+ dataA{2}.^2.+ dataA{3}.^2);
    ABS{2} = sqrt(TraceFilt{1}.^2.+ TraceFilt{2}.^2.+ TraceFilt{3}.^2);
end