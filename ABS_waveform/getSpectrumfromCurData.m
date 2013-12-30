function [SigSpec,MaxAmp] = getSpectrumfromCurData(curData,sps)

curData = curData(~isnan(curData));
if isnan(curData)
   fprintf('   CurTrace Data are NaN''s \n'); 
end
% Remove the mean value.
curData = curData - mean(curData);

d_nr = size(curData(:), 1);
deltaT = 1/sps;
T = (numel(curData)-1) * deltaT;
NFFT = 2^nextpow2(d_nr);
Y = fft(curData(:),NFFT)/d_nr;
frequ = sps/2*linspace(0,1,NFFT/2+1);
fft_abs = 2*abs(Y(1:NFFT/2+1));
SigSpec.frequ = frequ(2:numel(frequ)-1);
SigSpec.fft = fft_abs(2:numel(frequ)-1);

% normalize the spectrum
%     normFft = fft_abs / max(fft_abs);

% //OLD FFT
%Y = fft(curData(:));
%frequ = (sps*(0:d_nr-1) / d_nr)';
%fft_abs = 2*(deltaT) / T * abs(Y);
%leftFft = ceil(d_nr/2);
%SigSpec.frequ = frequ(2:leftFft);
%SigSpec.fft = fft_abs(2:leftFft);

MaxAmp = max(abs(curData));