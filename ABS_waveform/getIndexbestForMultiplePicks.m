
function [indexbest] = getIndexbestForMultiplePicks(timeflt,evidn,oridn,phase,authtmp,arid,chan,timeres,deltim,setting)

indexbest = -1;

for k=1:numel(timeflt)
    %check if the channel can be used to constrain the onset time
    for m=1:numel(setting.comp)
        currkomp = setting.comp{m};
        currchan = chan{k};
        if strcmp(currchan,currkomp)==1
            indexbest = k;
            m = numel(setting.comp);
            k = numel(timeflt);
            return;
        end
    end
end

if indexbest == -1
    % look for other criteria: minimal deltime!!
    minval = 999;
    minindex = -1;
    found = 0;
    for k=1:numel(timeflt)
        if deltim(k) > 0 && deltim(k) < minval
            minval = deltim(k);
            minindex = k;
            found = 1;
        end
    end
    
    if found==1
        indexbest = minindex;
        return;
    end
end

if indexbest == -1
   % look for other criteria: minimal timeres!!
   [maxval,indmax] = min(abs(timeres));
   if numel(maxval)==1
       indexbest = indmax;
       return;
   end
end

if indexbest == -1
   %take the first row
   indexbest = 1;
end

