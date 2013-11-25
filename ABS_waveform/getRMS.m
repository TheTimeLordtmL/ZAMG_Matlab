function RMSv = getRMS(dataV,dataA,setting)
if setting.intitialunit == 'V'
    for p=1:numel(setting.comp)
        currdata = dataV{p};
        tmpsq = currdata.*currdata;
        RMSv{p} = sqrt(sum(tmpsq)/numel(currdata));
    end
end
if setting.intitialunit == 'A'
    for p=1:numel(setting.comp)
        currdata = dataA{p};
        tmpsq = currdata.*currdata;
        RMSv{p} = sqrt(sum(tmpsq)/numel(currdata));        
    end     
end