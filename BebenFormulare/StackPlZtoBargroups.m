function [barX,barY] = StackPlZtoBargroups(HistPLzDist)
% input = plz | numberstack | distance 
% out = distance | numberstack
barX = [];  barY = [];

distround = round(HistPLzDist(:,3));
distunique = unique(distround);

barX = zeros(numel(distunique),1); barY = barX;
for k=1:numel(distunique)
   curr_dist = distunique(k);
   ind = find(distround(:)==curr_dist);
   currstacks = HistPLzDist(ind,2);
   barX(k) = curr_dist; 
   barY(k) = sum(currstacks); 
   ind = []; currstacks = [];
end