
function [n] = getNfromcurrP(mmax,currp,countvertical)
% aktuelle spalte f�r plot

n = 1;
for p=1:mmax
    n = p;
    if countvertical*p >= currp
        break;
    end
end