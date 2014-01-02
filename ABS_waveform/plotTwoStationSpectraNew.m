function plotTwoStationSpectraNew(specvec1,specvec2,pspectra1,pspectra2,sspectra1,sspectra2,znoisespectra1,znoisespectra2,horznoisespectra1,horznoisespectra2,setting)
% inputs: p- und s spectra as well as noise for the two events

%plotTwoStationSpectraNew(specvec1,specvec2,pspectra1,pspectra2,sspectra1,sspectra2,noisespectra1,noisespectra2,setting)
% specvec1 = [1:50];
% specvec2 = [1:50];
% pspectra1 = [1:50].^3.8';
% pspectra2 = [1:50].^3.2';
% sspectra1 = [1:50].^3.5';
% sspectra2 = [1:50].^3.05';
% noisespectra1 = abs(randn(50,1))*100;
% noisespectra2 = abs(randn(50,1))*100+3*noisespectra1;

% DEFINE COLOR
colsig1 = [0 0 0.4];              colsig2 = [0.79 0.02 0.02];
colnoise1 = [0.13 0.33 0.53];   colnoise2 = [0.67 0.67 0.43];

%THIS IS DONE EARLIER
%if setting.waveforms.plotSignalSpectraReducedByNoise == 1
%    [pspectra1,pspectra2,sspectra1,sspectra2] = ReduceSignalSpectraByNoise(pspectra1,pspectra2,sspectra1,sspectra2,noisespectra1,noisespectra2,setting);
%end

% // fix amplitude spectra max and get Y-axes Limit
[limYMin1,limYMax1,limYMin2,limYMax2] = getAmplitudeSpectraYlimits(specvec1,specvec2,pspectra1,pspectra2,sspectra1,sspectra2,znoisespectra1,znoisespectra2,horznoisespectra1,horznoisespectra2,setting);
    
% // show the plot
figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height],'Name','P- and S-wave amplitude spectra');

%// plot P-wave spectra
subplot(1,2,1); hold on;
if setting.waveforms.plotNoiseSpectra == 1
    loglog(specvec1(:),znoisespectra1(:),'Color',colnoise1,'LineWidth',setting.waveforms.plotSizeLineSpectraNoise);
    loglog(specvec2(:),znoisespectra2(:),'Color',colnoise2,'LineWidth',setting.waveforms.plotSizeLineSpectraNoise);
    tmplabel{1} = sprintf('Noise1   (evid %10.0f)',setting.waveforms.evid1);
    tmplabel{2} = sprintf('Noise2   (evid %10.0f)',setting.waveforms.evid2);
    tmplabel{3} = sprintf('%s1 (Z) %s',setting.station1,setting.time.start1);
    tmplabel{4} = sprintf('%s2 (Z) %s',setting.station2,setting.time.start2);
else
    tmplabel{1} = sprintf('%s1 (Z) %s',setting.station1,setting.time.start1);
    tmplabel{2} = sprintf('%s2 (Z) %s',setting.station2,setting.time.start2);
end
loglog(specvec1(:),pspectra1(:),'Color',colsig1,'LineWidth',setting.waveforms.plotSizeLineSpectraSignal);
loglog(specvec2(:),pspectra2(:),'Color',colsig2,'LineWidth',setting.waveforms.plotSizeLineSpectraSignal);

grid on;
% set X and Y Limits
if setting.waveforms.useManualXlimit==1 && setting.waveforms.fixPSamplSpectra == 1
    xlim(setting.waveforms.manualXlimit);
else
    xlim([min(specvec1) max(specvec1)]);
end
if setting.waveforms.useManualYlimit==1 && setting.waveforms.fixPSamplSpectra == 1
    ylim(setting.waveforms.manualYlimit);
else
    ylim([limYMin1 limYMax1]);
end
ylabel('P-wave spectral amplitude');    xlabel('frequency (Hz)');
set(gca,'XScale','log');   set(gca,'YScale','log');
legend(tmplabel,numel(tmplabel));

% // plot S.wave spectra 
subplot(1,2,2); hold on;
if setting.waveforms.plotNoiseSpectra == 1
    loglog(specvec1(:),horznoisespectra1(:),'Color',colnoise1,'LineWidth',setting.waveforms.plotSizeLineSpectraNoise);
    loglog(specvec2(:),horznoisespectra2(:),'Color',colnoise2,'LineWidth',setting.waveforms.plotSizeLineSpectraNoise);
    tmplabel{3} = sprintf('%s1 (N&E) %s',setting.station1,setting.time.start1);
    tmplabel{4} = sprintf('%s2 (N&E) %s',setting.station2,setting.time.start2);
else
    tmplabel{1} = sprintf('%s1 (N&E) %s',setting.station1,setting.time.start1);
    tmplabel{2} = sprintf('%s2 (N&E) %s',setting.station2,setting.time.start2);
end
loglog(specvec1(:),sspectra1(:),'Color',colsig1,'LineWidth',setting.waveforms.plotSizeLineSpectraSignal);
loglog(specvec2(:),sspectra2(:),'Color',colsig2,'LineWidth',setting.waveforms.plotSizeLineSpectraSignal);
grid on;
% set X and Y Limits
if setting.waveforms.useManualXlimit==1 && setting.waveforms.fixPSamplSpectra == 1
    xlim(setting.waveforms.manualXlimit);
else
    xlim([min(specvec2) max(specvec2)]);
end
if setting.waveforms.useManualYlimit==1 && setting.waveforms.fixPSamplSpectra == 1
    ylim(setting.waveforms.manualYlimit);
else
    ylim([limYMin2 limYMax2]);
end
ylabel('S-wave spectral amplitude');    xlabel('frequency (Hz)');
set(gca,'XScale','log');   set(gca,'YScale','log');
legend(tmplabel,numel(tmplabel));



function [limYMin1out,limYMax1out,limYMin2out,limYMax2out] = getAmplitudeSpectraYlimits(specvec1,specvec2,pspectra1,pspectra2,sspectra1,sspectra2,znoisespectra1,znoisespectra2,horznoisespectra1,horznoisespectra2,setting)
if setting.waveforms.fixPSamplSpectra == 1
    % set limit from P- and S-spectra
    if setting.waveforms.plotNoiseSpectra == 1
        datasum1 = [pspectra1;pspectra2;sspectra1;sspectra2;znoisespectra1;znoisespectra2;horznoisespectra1;horznoisespectra2];
        datasum2 = datasum1;
    else
        datasum1 = [pspectra1;pspectra2;sspectra1;sspectra2];
        datasum2 = datasum1;
    end
else
    % set limit for P- and S-spectra individually
    if setting.waveforms.plotNoiseSpectra == 1
        datasum1 = [pspectra1;sspectra1;znoisespectra1;horznoisespectra1];
        datasum2 = [pspectra2;sspectra2;znoisespectra2;horznoisespectra2];
    else
        datasum1 = [pspectra1;sspectra1];
        datasum2 = [pspectra2;sspectra2];
    end
end
limYMin1 = min(datasum1);
limYMax1 = max(datasum1);
limYMin2 = min(datasum2);
limYMax2 = max(datasum2);

%build array with 10 to power x
maxpowerx = 40;
for k=1:maxpowerx
   arrpower(k) = 10^(k-20); 
end

%assign min/max value to nearest 10^x for loglog plot
limYMax1out = arrpower(maxpowerx);
for p=1:maxpowerx
   if arrpower(p) >= limYMax1
       limYMax1out = arrpower(p);
       break;
   end
end

limYMax2out = arrpower(maxpowerx);
for p=1:maxpowerx
   if arrpower(p) >= limYMax2
       limYMax2out = arrpower(p);
       break;
   end
end


limYMin1out = arrpower(1);
for p=maxpowerx:-1:1
   if arrpower(p) <= limYMin1
       limYMin1out = arrpower(p);
       break;
   end
end

limYMin2out = arrpower(1);
for p=maxpowerx:-1:1
   if arrpower(p) <= limYMin2
       limYMin2out = arrpower(p);
       break;
   end
end

clear arrpower;

%min and max values are the same?
if limYMin1out==limYMax1out
    limYMin1out = limYMin1out*0.9;
    limYMax1out = limYMax1out*1.1;
end
if limYMin2out==limYMax2out
    limYMin2out = limYMin2out*0.9;
    limYMax2out = limYMax2out*1.1;
end


