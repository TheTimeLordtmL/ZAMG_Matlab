function [m] = getMfromcurrP(mmax,currp,countvertical)
% aktuelle zeile f�r plot

m = mod(currp,countvertical);
if m==0
   m = countvertical;
end