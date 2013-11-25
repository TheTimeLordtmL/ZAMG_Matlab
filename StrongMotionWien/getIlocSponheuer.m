
function [ilocal] = getIlocSponheuer(setting,distkm,inull,depth)
%use inull and the distace to estimate the local
% intensity using the equation 
alpha = setting.showSignificantEQs.alpha;

%setzte Tiefe für depth <= 0 auf 1 km 
ind = find(depth<=0);
depth(ind) = depth(ind).*0 + 1;

%ilocal(°) after Sponheuer 1960
tmp1 = []; tmp2 = [];
tmp1 = 3.*log10(distkm./depth);
tmp2 = 1.3*alpha.*(distkm-depth);
ilocal = inull-tmp1-tmp2;

%when epicenter=city then iloc=inull
%überholdistanz wenn Tiefe=Entfernung!!!
ind = find(distkm<=depth);
if ~isempty(ind)
  ilocal(ind) = inull(ind);
end
