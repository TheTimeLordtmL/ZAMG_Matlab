function [anzahlEtype] = getEtypeHistogramData(nvector,celletypeunique)
%use vector with etype classes (1,2,3,..) corresponding to the etype cell
%array celletypeunique('-','ke') to count the number of etypes per class (e.g. 1000 '-', and 27 'ke')


for k=1:numel(celletypeunique)
    anzahlEtype(k) = numel(find(nvector==k));
end

if sum(anzahlEtype)~=numel(nvector)
    fprintf('[warning] some thing went wrong in getEtypeHistogramData.m\n');
end