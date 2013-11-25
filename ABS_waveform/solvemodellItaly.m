function [cparam] = solvemodellItaly(setting,statHL,statHN,statHH)

[latev,longev,depthev,ml,mb] = getLatLongForEventfromDB(setting,setting.evid);
[lat,long,elev] = getLatLongForStationfromDB(setting,setting.station);
d = vdist(lat,long,latev,longev);  %distance km
R = sqrt(d*d + depthev*depthev);

x = [statHL',statHN',statHH']';

ei = ones(numel(x),1);
M = ml;

A = [ei,ei*M',ei*M*M',log10(ei*R)];
N = A'*A;

y = A\x;


