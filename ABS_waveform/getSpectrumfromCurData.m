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
Y = fft(curData(:));
frequ = (sps*(0:d_nr-1) / d_nr)';
fft_abs = 2*(deltaT) / T * abs(Y);


% normalize the spectrum
%     normFft = fft_abs / max(fft_abs);

leftFft = ceil(d_nr/2);

SigSpec.frequ = frequ(2:leftFft);
SigSpec.fft = fft_abs(2:leftFft);
MaxAmp = max(abs(curData));