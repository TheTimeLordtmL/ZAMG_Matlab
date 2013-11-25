function [accel] = getAccelMcGuire(setting,distkm,depth,ml)
%use inull and the distace to estimate the local
% intensity using the equation 
alpha = setting.showSignificantEQs.alpha;

%setzte Tiefe für depth <= 0 auf 1 km 
ind = find(depth<=0);
depth(ind) = depth(ind).*0 + 1;

%acceleration (m/s²) after McGuire 1974
tmp1 = 0.28.*ml;
tmp2 = 1.3*log10(distkm+25);
exp1 = (0.67+tmp1-tmp2);
accel = 10.^exp1;

