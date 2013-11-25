function [accel] = getAccelYan(setting,distkm,depth,ml)
%use the relation from Jia, 2011 (EGU Poster)

%3D Distanz
dist3d = sqrt(distkm.^2+depth.^2);

%acceleration (g) 
tmp1 = -3.55+0.879.*ml-2.15.*log10(dist3d);
accel = 10.^tmp1;

%acceleration (m/s²)
accel = accel * 9.81;