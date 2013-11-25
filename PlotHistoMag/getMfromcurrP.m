function [m] = getMfromcurrP(mmax,currp,countvertical)
% aktuelle zeile für plot

m = mod(currp,countvertical);
if m==0
   m = countvertical;
end