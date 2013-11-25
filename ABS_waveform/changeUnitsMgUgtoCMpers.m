function [stations] = changeUnitsMgUgtoCMpers(stations,setting)
%use the DB entries units1 and units2 to change units 
% to cm/s2.  possible units: mg, ug

for k=1:numel(stations.val1(:))
    currunitstr = stations.units1{k};
    val = stations.val1(k);
    valnew = getUnitValInCMpers(currunitstr,val);
    stations.val1cm(k) = valnew;
end

for k=1:numel(stations.val2(:))
    currunitstr = stations.units2{k};
    val = stations.val2(k);
    valnew = getUnitValInCMpers(currunitstr,val);
    stations.val2cm(k) = valnew;
end



function valcm = getUnitValInCMpers(unitstr,val)
valcm = 0;

switch unitstr
    case 'mg'
        valcm = val*981/1000;
    case 'ug'
        valcm = val*981/1000000;
    otherwise
        fprintf('units %s unkown !!',unitstr);
end




