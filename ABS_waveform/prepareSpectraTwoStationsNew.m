function [specvec1,specvec2,zCompFrequ1,zCompFrequ2,horzCompFrequ1,horzCompFrequ2,zNoise1,zNoise2,horzNoise1,horzNoise2] = prepareSpectraTwoStationsNew(psig1,ssig1,noise1,psig2,ssig2,noise2,setting)
% take threee-components data to create spectra for Z- (p-wave) and a mean for the
% horizontal ones (S-wave)
% if specified reduce the spectra by the noise
%psig1,ssig1,noise1,psig2,ssig2,noise2,setting

zCompFrequ1 = [];  zCompFrequ2 = [];    specvec1 = [];     specvec2 = [];
nCompFrequ1 = [];  nCompFrequ2 = []; eCompFrequ1 = [];  eCompFrequ2 = [];
horzCompFrequ1 = [];  horzCompFrequ2 = [];  horzNoise1 = [];  horzNoise2 = []; zNoise1 = [];  zNoise2 = [];
  
% prepare the Z-Komponent
if numel(psig1)>=1 && numel(psig2)>=1
    specvec1 = psig1{1}.frequ;
    specvec2 = psig2{1}.frequ;
    if numel(noise1)>=1 && numel(noise2)>=1
        zNoise1 = noise1{1}.fft;  zNoise2 = noise2{1}.fft;
    end
    if setting.waveforms.plotSignalSpectraReducedByNoise == 1
        if numel(noise1)>=1 && numel(noise2)>=1
            zCompFrequ1 = psig1{1}.fft - noise1{1}.fft ;
            zCompFrequ2 = psig2{1}.fft - noise2{1}.fft ;  
        else
            zCompFrequ1 = psig1{1}.fft;
            zCompFrequ2 = psig2{1}.fft;
            fprintf('[Warning:] Noise was not reduced from spectra1!\n');
        end
    end
    if setting.waveforms.plotSignalSpectraReducedByNoise == 0
        zCompFrequ1 = psig1{1}.fft;
        zCompFrequ2 = psig2{1}.fft;
    end
else
    specvec1 = [];
    specvec2 = [];
end


% prepare the N & E-Komponent
if numel(ssig1)>=3 && numel(ssig2)>=3
    if isempty(specvec1)
        specvec1 = ssig1{2}.frequ;
    end
    if isempty(specvec2)
        specvec2 = ssig2{2}.frequ;
    end
    if setting.waveforms.plotSignalSpectraReducedByNoise == 1
        if numel(noise1)>=3 && numel(noise2)>=3
            nCompFrequ1 = ssig1{2}.fft - noise1{2}.fft ;
            nCompFrequ2 = ssig2{2}.fft - noise2{2}.fft ;
            eCompFrequ1 = ssig1{3}.fft - noise1{3}.fft ;
            eCompFrequ2 = ssig2{3}.fft - noise2{3}.fft ;
        else
            nCompFrequ1 = ssig1{2}.fft;
            nCompFrequ2 = ssig2{2}.fft;
            eCompFrequ1 = ssig1{3}.fft;
            eCompFrequ2 = ssig2{3}.fft;
            fprintf('[Warning:] Noise was not reduced from spectra2!\n');
        end
    end
    if setting.waveforms.plotSignalSpectraReducedByNoise == 0
        nCompFrequ1 = ssig1{2}.fft;
        nCompFrequ2 = ssig2{2}.fft;
        eCompFrequ1 = ssig1{3}.fft;
        eCompFrequ2 = ssig2{3}.fft;        
    end
    
    % get the mean for the horizontal components
    horzCompFrequ1 = (nCompFrequ1+eCompFrequ1)/2;  
    horzCompFrequ2 = (nCompFrequ2+eCompFrequ2)/2;
    horzNoise1 = (noise1{2}.fft+noise1{3}.fft)/2; 
    horzNoise2 = (noise2{2}.fft+noise2{3}.fft)/2;
end

