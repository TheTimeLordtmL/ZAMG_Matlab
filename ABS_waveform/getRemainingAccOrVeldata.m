function [dataVout,dataAout,dataDout,setting] = getRemainingAccOrVeldata(dataV,dataA,setting)
% dataVout..velocity
% dataAout..acceleration
% dataDout..displacement

if setting.intitialunit == 'V'
    for p=1:numel(setting.comp)
        dataDout{p} = getDisplacementfromVelocity(dataV{p});
        if setting.exportDataASCII==1
             if  setting.exportASCII.filter==1
                 switch setting.filter.type
                     case 'LP'       %low pass
                         dataDout{p} = filterLowPass(dataDout{p},setting.samplerate{p},setting);
                     case 'HP'       %high pass
                         dataDout{p} = filterLowCutOff(dataDout{p},setting.samplerate{p},setting);
                     case 'BP'       %band pass
                         %emtyp
                 end
                 dataAout{p} = getAccelerationfromVelocity(dataV{p});
                 switch setting.filter.type
                     case 'LP'       %low pass
                         dataAout{p} = filterLowPass(dataAout{p},setting.samplerate{p},setting);
                     case 'HP'       %high pass
                         dataAout {p} = filterLowCutOff(dataAout{p},setting.samplerate{p},setting);
                     case 'BP'       %band pass
                         %emtyp
                 end
                %dataDout{p} = getDisplacementfromVelocity(dataAout{p});   %test differentation
             else
                %dataDout{p} = filterLowCutOff(dataDout{p},setting.samplerate{p},setting);
                dataAout{p} = getAccelerationfromVelocity(dataV{p});
             end
        else
            switch setting.filter.type
                case 'LP'       %low pass
                    dataDout{p} = filterLowPass(dataDout{p},setting.samplerate{p},setting);
                case 'HP'       %high pass
                    dataDout{p} = filterLowCutOff(dataDout{p},setting.samplerate{p},setting);
                case 'BP'       %band pass
                    %emtyp
            end
            dataAout{p} = getAccelerationfromVelocity(dataV{p});
            switch setting.filter.type
                case 'LP'       %low pass
                    dataAout{p} = filterLowPass(dataAout{p},setting.samplerate{p},setting);
                case 'HP'       %high pass
                    dataAout{p} = filterLowCutOff(dataAout{p},setting.samplerate{p},setting);
                case 'BP'       %band pass
                    %emtyp
            end
        end
    end
    dataVout = dataV;
end
if setting.intitialunit == 'A'
    for p=1:numel(setting.comp)
        if setting.exportDataASCII==1
            if  setting.exportASCII.filter==1
                dataVout{p} = getDisplacementfromVelocity(dataA{p});
                switch setting.filter.type
                    case 'LP'       %low pass
                        dataVout{p} = filterLowPass(dataVout{p},setting.samplerate{p},setting);
                    case 'HP'       %high pass
                        dataVout{p}  = filterLowCutOff(dataVout{p},setting.samplerate{p},setting);
                    case 'BP'       %band pass
                        %emtyp
                end
                dataDout{p} = getDisplacementfromVelocity(dataVout{p});
                switch setting.filter.type
                    case 'LP'       %low pass
                        dataDout{p} = filterLowPass(dataDout{p},setting.samplerate{p},setting);
                    case 'HP'       %high pass
                        dataDout{p} = filterLowCutOff(dataDout{p},setting.samplerate{p},setting);
                    case 'BP'       %band pass
                        %emtyp
                end
            else
                dataVout{p} = getDisplacementfromVelocity(dataA{p});
                dataDout{p} = getDisplacementfromVelocity(dataVout{p});
            end
        else
            dataVout{p} = getDisplacementfromVelocity(dataA{p});
            switch setting.filter.type
                case 'LP'       %low pass
                    dataVout{p} = filterLowPass(dataVout{p},setting.samplerate{p},setting);
                case 'HP'       %high pass
                    dataVout{p} = filterLowCutOff(dataVout{p},setting.samplerate{p},setting);
                case 'BP'       %band pass
                    %emtyp
            end
            dataDout{p} = getDisplacementfromVelocity(dataVout{p});
            switch setting.filter.type
                case 'LP'       %low pass
                    dataDout{p} = filterLowPass(dataDout{p},setting.samplerate{p},setting);
                case 'HP'       %high pass
                    dataDout{p} = filterLowCutOff(dataDout{p},setting.samplerate{p},setting);
                case 'BP'       %band pass
                    %emtyp
            end
        end
    end
    dataAout = dataA;
end