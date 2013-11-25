function test()
figure;
%find parameters col,row for subplots
nmax = 6;       % dimension zeilen
[mmax,n,m] = getMNsizeforSubpots(18,1,nmax);  
indMatrix = cell(nmax,mmax);
kalt = 0; 
for i=1:nmax
    for o=1:mmax
        kalt = (i-1)*nmax + o*2;
        indMatrix{i,o} = [kalt-1 kalt];
    end
end


for p=1:18
    %n.. aktuelle spalte  m..aktuelle zeile   mmax..max.spaltenanzahl  nmax..dimension zeilen
    [mmax,n,m] = getMNsizeforSubpots(18,p,nmax); 
     axesplt(p) = subplot(nmax,nmax,indMatrix{m,n});
     plot([1:100]/p);
     fprintf('%2g  %g  %g  %g\n',p,nmax,n,p);
end
disp(' ');



 
 
 