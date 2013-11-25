
function [n] = getNfromcurrP(mmax,currp,countvertical)
% aktuelle spalte für plot

n = 1;
for p=1:mmax
    n = p;
    if countvertical*p >= currp
        break;
    end
end