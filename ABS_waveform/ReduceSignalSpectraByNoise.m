function [pspectra1out,pspectra2out,sspectra1out,sspectra2out] = ReduceSignalSpectraByNoise(pspectra1,pspectra2,sspectra1,sspectra2,noisespectra1,noisespectra2,setting)

pspectra1out = pspectra1 - noisespectra1;
pspectra2out = pspectra2 - noisespectra2;
sspectra1out = sspectra1 - noisespectra1;
sspectra2out = sspectra2 - noisespectra2;
 
