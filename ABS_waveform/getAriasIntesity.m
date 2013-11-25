function [Arias] = getAriasIntesity(dataA,setting)
%(ARIAS, 1970) with “a(t)” as the ground acceleration, “g” as the acceleration 
% due to gravity and “Td” the duration of signal above a certain threshold,
% usually 90 % of the signal’s energy. Known as the Arias Intensity (AI) the
% time-integral of the square of the ground acceleration describes the square
% root of the energy per mass with units of m/s.
%data{1} data{2} data{3}
AriasData = [];  AriasVal = [];

% compute Arias Intensity
for p=1:numel(setting.comp)
    currEnergy = dataA{p}.*dataA{p};
    contData = currEnergy;
    contTime = 1:numel(contData);
    AriasData{p} = cumtrapz(contTime - contTime(1), contData);
    AriasData{p} = detrend(AriasData{p}).*(pi()/(2*setting.Arias.gravity));
end

% find the 90% value
for p=1:numel(setting.comp)
   cur_min = min(AriasData{p});
   cur_max = max(AriasData{p});
   cur_xvec = 1:numel(AriasData{p});
   diff = (cur_max-cur_min);
   AriasVal{p}.val = (diff/100*setting.Arias.signalduration)+cur_min;
   tmp = abs(AriasData{p} - AriasVal{p}.val);
   tmpsort = sortrows([tmp cur_xvec'],1);
   if size(tmpsort,1) >= 20
       tmpsort2 = sortrows(tmpsort(1:20,:),2);
   else
       tmpsort2 = sortrows(tmpsort,2);
   end
   cur_xind = tmpsort2(1,2); 
   %plot(AriasData{p}); hold on; plot([1 14000],[AriasVal{p}.val AriasVal{p}.val]);
   %plot([cur_xind cur_xind],[-0.5 1.3]);
   AriasVal{p}.xvec = cur_xvec(cur_xind);
   AriasVal{p}.cur_max = cur_max;
   AriasVal{p}.cur_min = cur_min;
end

%prepare output 
Arias{1} =  AriasData;
Arias{2} =  AriasVal;









