function NormalHistplotEQmitandere(setting)
if setting.DB.readfromDB==1
    switch setting.DB.userectangle
        case 1  % near Austria - AEC
          [setting,data,datastruct] = getAllEventsFromDBAustria(setting,'normal'); 
        case 2  % user specified - zagsunxx
          [setting,data,datastruct] = getAllEventsFromDBWorld(setting,'normal');   
        otherwise  % no geographic filter
          [setting,data,datastruct] = getAllEventsFromDBWorld(setting,'normal');   
    end
else  
  [setting,data,datastruct] = readTextFile(setting);
end
[setting] = printStatistik(data,setting);

%Filter the data: revome 'km','sm'
if setting.filter.UseTheFilter==0
    fprintf('Note that this algorithm needs the specification of two filters!\n');
end
   
setting.filter.WhichData = setting.filter1.WhichData;
[data1,excludtype,setting] = filterDataEtypeExclude(data,datastruct,setting,'normal');
setting.filter.NumberEtypeExclude1 = setting.filter.NumberEtypeExclude;
setting.filter.excludedDataStr1 = setting.filter.excludedDataStr;

setting.filter.WhichData = setting.filter2.WhichData;
[data2,excludtype,setting] = filterDataEtypeExclude(data,datastruct,setting,'normal');
setting.filter.NumberEtypeExclude2 = setting.filter.NumberEtypeExclude;
setting.filter.excludedDataStr2 = setting.filter.excludedDataStr;

[datastack,setting] = prepareDataStack2Classes(data1,data2,setting);
%[setting] = printStatistikMagStack(datastack,setting);
plotStacked2Classes(datastack,setting);
if setting.plotInfoSubplot==1
   plotInfoOnHistoSubplot(setting);
end
disp('a');