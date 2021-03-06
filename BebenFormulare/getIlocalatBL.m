
function [ilocal,accel] = getIlocalatBL(distkm,inull,depth,ml,setting)
%use inull and the distace to estimate the local
% intensity using the equation 
alpha = setting.showSignificantEQs.alpha;

%setzte Tiefe f�r depth <= 0 auf 1 km 
ind = find(depth<=0);
depth(ind) = depth(ind).*0 + 1;

%setzte Tiefe f�r depth > maxdepth auf mittlere Tiefe km 
ind = find(depth>=setting.logNJahr.Tiefemax);
depth(ind) = depth(ind).*0 + setting.logNJahr.Tiefemittel;

% // Acelleration (m/s�)
switch setting.showSignificantEQs.sortNevents
    case 'acc_McGuire'
        [accel] = getAccelMcGuire(setting,distkm,depth,ml);
    case 'acc_Yan'
        [accel] = getAccelYan(setting,distkm,depth,ml);
    otherwise
        [accel] = getAccelYan(setting,distkm,depth,ml); 
end

% // Ilocal(�) 
% after Sponheuer 1960
tmp1 = []; tmp2 = [];
tmp1 = 3.*log10(distkm./depth);
tmp2 = 1.3*alpha.*(distkm-depth);
ilocal = inull-tmp1-tmp2;

%when epicenter=city then iloc=inull
%�berholdistanz wenn Tiefe=Entfernung!!!
ind = find(distkm<=depth);
if ~isempty(ind)
  ilocal(ind) = inull(ind);
end

