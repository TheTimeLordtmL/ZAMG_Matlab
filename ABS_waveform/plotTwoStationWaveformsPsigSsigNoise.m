function  plotTwoStationWaveformsPsigSsigNoise(psig1,ssig1,noise1,psig2,ssig2,noise2,data1,data2,setting)
%plot waveform data for two events and each channel

%psig1,ssig1,noise1,psig2,ssig2,noise2
%data1,data2

% get the titelstring
if setting.waveforms.useDisplacement == 1
    titlestr = sprintf('Waveforms for the two events, unit is %s \n','displacement');
else
    if setting.intitialunit == 'V'
        titlestr = sprintf('Waveforms for the two events, unit is %s \n','velocity');
    end
    if setting.intitialunit == 'A'
        titlestr = sprintf('Waveforms for the two events, unit is %s \n','acceleration');
    end
end

%plot the two waveform data with the psig, ssig, noise
for p=1:1
    figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height],'Name',titlestr);
    subplot(2,1,1); hold on;
    datay1 = data1{p}; pw1 = psig1{p};  sw1 = ssig1{p}; no1 = noise1{p};
    plot([1:size(datay1,1)],datay1(:),'Color','blue','LineWidth',setting.waveforms.plotSizeLineSpectraNoise);
    plot([setting.waveforms.timecuts.psamples1:setting.waveforms.timecuts.psamples1+size(pw1,1)-1],pw1(:),'Color','red','LineWidth',setting.waveforms.plotSizeLineSpectraSignal);
    plot([1:size(no1,1)],no1(:),'Color','green','LineWidth',setting.waveforms.plotSizeLineSpectraSignal);
    plot([setting.waveforms.timecuts.ssamples1:setting.waveforms.timecuts.ssamples1+size(sw1,1)-1],sw1(:),'Color','black','LineWidth',setting.waveforms.plotSizeLineSpectraSignal);
    plot([setting.waveforms.timecuts.psamples1 setting.waveforms.timecuts.psamples1],[min(datay1) max(datay1)],':k');
    plot([setting.waveforms.timecuts.ssamples1 setting.waveforms.timecuts.ssamples1],[min(datay1) max(datay1)],':k');
    clear datay1 pw1 sw1 no1;
    ylabelstr = sprintf('amplitude (%s) from %s',setting.unit.value,setting.intitialunit);
    ylabel(ylabelstr);    xlabel('samples');
    legendstr = sprintf('evid=%10.0f,  %s (%s)',setting.waveforms.evid1,setting.station1,setting.comp1{p});
    legend(legendstr,1);
    
    subplot(2,1,2); hold on;
    datay2 = data2{p}; pw2 = psig2{p};  sw2 = ssig2{p}; no2 = noise2{p};
    plot([1:size(datay2,1)],datay2(:),'Color','blue','LineWidth',setting.waveforms.plotSizeLineSpectraNoise);
    plot([setting.waveforms.timecuts.psamples2:setting.waveforms.timecuts.psamples2+size(pw2,1)-1],pw2(:),'Color','red','LineWidth',setting.waveforms.plotSizeLineSpectraSignal);
    plot([1:size(no2,1)],no2(:),'Color','green','LineWidth',setting.waveforms.plotSizeLineSpectraSignal);
    plot([setting.waveforms.timecuts.ssamples2:setting.waveforms.timecuts.ssamples2+size(sw2,1)-1],sw2(:),'Color','black','LineWidth',setting.waveforms.plotSizeLineSpectraSignal);
    plot([setting.waveforms.timecuts.psamples2 setting.waveforms.timecuts.psamples2],[min(datay2) max(datay2)],':k');
    plot([setting.waveforms.timecuts.ssamples2 setting.waveforms.timecuts.ssamples2],[min(datay2) max(datay2)],':k');
    clear datay2 pw2 sw2 no2;
    ylabelstr = sprintf('amplitude (%s) from %s',setting.unit.value,setting.intitialunit);
    ylabel(ylabelstr);    xlabel('samples');
    legendstr = sprintf('evid=%10.0f,  %s (%s)',setting.waveforms.evid2,setting.station2,setting.comp2{p});
    legend(legendstr,1);
end