
function [mmax,n,m] = getMNsizeforSubpots(numdata,currp,nmax)
mmax=1; n=1;

[mmax] = getMaxMfromData(numdata,nmax);
[n] = getNfromcurrP(mmax,currp,nmax);
[m] = getMfromcurrP(mmax,currp,nmax);