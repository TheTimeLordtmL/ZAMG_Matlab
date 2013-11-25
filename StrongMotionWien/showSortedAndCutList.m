function showSortedAndCutList(EQlistsort,data,setting)
% print sorted and cut list on display


%        [ 1] 2012-03-05 22:56:58  3.3   6.3  2.2 -10.0  0.111        Straze nad Myjavou ( -),        :seismo [ 48.5582,  17.1104,   3.0]    66 km,    1027181,   52433123
fprintf(' #Nr       Date     Time  Mag    I0  MMacr Acc. m/s           Location name               Author  latitude  longitude  depth  distance      \n');
for p=1:numel(EQlistsort)
   evname = EQlistsort(p).evname;   evtype = EQlistsort(p).etype;
   auth = EQlistsort(p).auth; timestr = EQlistsort(p).timestr;  
   fprintf('[%2g] %s  %3.1f  %4.1f %4.1f  %5.3f %25s (%2s),%22s [%8.4f, %8.4f, %5.1f] \n',p,timestr,EQlistsort(p).ml,EQlistsort(p).inull,evname,evtype,auth,EQlistsort(p).lat,EQlistsort(p).lon,EQlistsort(p).depth);
   fprintf('    BGWA %4.1f°mod   %4.1fcm/s²mod   %4.1fcm/s²modYan  %4.1fcm/s²obs %5.0fkm \n',EQlistsort(p).ilocSponheuer.BGWA,EQlistsort(p).accelMcGuire.BGWA*100,EQlistsort(p).accelYan.BGWA*100,data(p,2),EQlistsort(p).distanceTo.BGWA);
   fprintf('    UMWA %4.1f°mod   %4.1fcm/s²mod   %4.1fcm/s²modYan  %4.1fcm/s²obs %5.0fkm \n',EQlistsort(p).ilocSponheuer.UMWA,EQlistsort(p).accelMcGuire.UMWA*100,EQlistsort(p).accelYan.UMWA*100,data(p,3),EQlistsort(p).distanceTo.UMWA);
   fprintf('    WIWA %4.1f°mod   %4.1fcm/s²mod   %4.1fcm/s²modYan  %4.1fcm/s²obs %5.0fkm \n',EQlistsort(p).ilocSponheuer.WIWA,EQlistsort(p).accelMcGuire.WIWA*100,EQlistsort(p).accelYan.WIWA*100,data(p,4),EQlistsort(p).distanceTo.WIWA);
   fprintf('    KMWA %4.1f°mod   %4.1fcm/s²mod   %4.1fcm/s²modYan  %4.1fcm/s²obs %5.0fkm \n',EQlistsort(p).ilocSponheuer.KMWA,EQlistsort(p).accelMcGuire.KMWA*100,EQlistsort(p).accelYan.KMWA*100,data(p,5),EQlistsort(p).distanceTo.KMWA);
   fprintf('    SNWA %4.1f°mod   %4.1fcm/s²mod   %4.1fcm/s²modYan  %4.1fcm/s²obs %5.0fkm \n',EQlistsort(p).ilocSponheuer.SNWA,EQlistsort(p).accelMcGuire.SNWA*100,EQlistsort(p).accelYan.SNWA*100,data(p,6),EQlistsort(p).distanceTo.SNWA);
end



