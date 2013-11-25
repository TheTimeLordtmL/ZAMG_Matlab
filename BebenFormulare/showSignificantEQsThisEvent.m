function [B,L] = showSignificantEQsThisEvent(FeltEQ,setting,flag)
% show all significant EQ's sorted by their intensity
% within 60km
deltaB = setting.showSignificantEQs.deltaB;
deltaL = setting.showSignificantEQs.deltaL;
minMag = setting.showSignificantEQs.minMag;
showNevents = setting.showSignificantEQs.showNevents;
sortNevents = setting.showSignificantEQs.sortNevents;

switch flag
    case'auto'
       indexnum = setting.curreventid; 
       B = FeltEQ.lat(indexnum);
       L = FeltEQ.lon(indexnum);
       mag = FeltEQ.ml(indexnum);
       evname = FeltEQ.evname(indexnum);  evname = evname{1};
       fprintf('Event: %s (M %4.1f)   latorig=%8.4f   lonorig=%8.4f \n',evname,mag,B,L);
       [EQlist] = getSignificantEQ(B,L,deltaB,deltaL,minMag,setting);
    case 'user'
       [L,B] = getUserInputsSigEQ();
       fprintf('Event: %s (M %s)   latorig=%8.4f   lonorig=%8.4f \n','unknown','?',B,L);
       [EQlist] = getSignificantEQ(B,L,deltaB,deltaL,minMag,setting);
    case 'cities'
       [L,B] = getUserInputsSigEQCities(setting); 
       [EQlist] = getSignificantEQ(B,L,deltaB,deltaL,minMag,setting);
    case 'allEventscities'
       [L,B] = getUserInputsSigEQCities(setting);  
       [EQlist] = getSignificantEvents(B,L,deltaB,deltaL,minMag,setting);
end

fprintf('deltaB=%8.4f   deltaL=%8.4f  minimal Magnitue=%4.1f \n',deltaB,deltaL,minMag);
fprintf('show the %g strongest, sorted by %s \n',showNevents,sortNevents);

[EQlistsort] = sortAndCutEQlist(EQlist,showNevents,sortNevents);  clear EQlist;

%replace evname outside from Austria (as long as the antelope-db bug exists)
EQlistsort = replaceEvnameOutsideAustria(EQlistsort,setting);

%show the list
showSortedAndCutList(EQlistsort,setting);

%write the list to file
writeSignificantEQs(EQlistsort,setting);

%plot the list with bundesland and towns
displaySignificantEQs(EQlistsort,B,L,setting);

disp('s');




function showSortedAndCutList(EQlistsort,setting)
% print sorted and cut list on display

switch setting.showSignificantEQs.sortNevents
    case 'acc_McGuire'
        accelstr = 'AccMcG m/s';
    case 'acc_Yan'
        accelstr = 'AccYan m/s';
    otherwise
        accelstr = 'AccYan m/s';
end

%        [ 1] 2012-03-05 22:56:58  3.3   6.3  2.2 -10.0  0.111        Straze nad Myjavou ( -),        :seismo [ 48.5582,  17.1104,   3.0]    66 km,    1027181,   52433123
fprintf(' #Nr       Date     Time  Mag    I0 Iloc MMacr %s           Location name  dam/quest          Author  latitude  longitude  depth  distance       orid        evid \n',accelstr);
for p=1:numel(EQlistsort.timeflt)
   evname = EQlistsort.evname(p);   evtype = EQlistsort.etype(p);
   auth = EQlistsort.auth(p); timestr = EQlistsort.timestr(p);
   damage = EQlistsort.damaging(p);  questionable = EQlistsort.questionable(p);
   damagquest = sprintf('%s/%s',damage{1},questionable{1});
   fprintf('[%2g] %s  %3.1f  %4.1f %4.1f %4.1f  %5.3f %25s (%2s,%3s),%20s [%8.4f, %8.4f, %5.1f] %5.0f km, %10.0f, %10.0f\n',p,timestr{1},EQlistsort.ml(p),EQlistsort.inull(p),EQlistsort.ilocal(p),EQlistsort.mmacro(p),EQlistsort.accel(p),evname{1},evtype{1},damagquest,auth{1},EQlistsort.lat(p),EQlistsort.lon(p),EQlistsort.depth(p),EQlistsort.distancekm(p),EQlistsort.orid(p),EQlistsort.evid(p));
end

switch setting.showSignificantEQs.sortNevents
    case 'localintensity'
       strSort = 'Local Intensity';
    case 'intensity'
       strSort = 'Intensity';
    case 'magnitude'
       strSort = 'Magnitude';
    case 'acc_McGuire'
        strSort = 'Acceleration (McGuire)';
    case 'acc_Yan'
        strSort = 'Acceleration (YanJia2012)';        
end
fprintf('Sorted by %s \n',strSort);
disp(' ');






function [Listout] = sortAndCutEQlist(EQlist,showNevents,sortNevents)
% sorts the array EQlist after intensity or magnitude
% outputs also only data set size up to a specified
% value (showNevents)
List = []; Listout = [];

switch sortNevents
    case 'intensity'
        [sorted,ind] = sort(EQlist.inull(:),'descend');
    case 'magnitude'
        [sorted,ind] = sort(EQlist.ml(:),'descend');
    case 'localintensity'
        [sorted,ind] = sort(EQlist.ilocal(:),'descend');
    case 'acc_McGuire'
        [sorted,ind] = sort(EQlist.accel(:),'descend'); 
    case 'acc_Yan'
        [sorted,ind] = sort(EQlist.accel(:),'descend');         
end

 List.timeflt = EQlist.timeflt(ind);  
 List.lat = EQlist.lat(ind);
 List.lon = EQlist.lon(ind);
 List.depth = EQlist.depth(ind);
 List.ml = EQlist.ml(ind);
 List.inull = EQlist.inull(ind); 
 List.mmacro = EQlist.mmacro(ind);
 List.ilocal = EQlist.ilocal(ind);
 List.accel = EQlist.accel(ind);
 List.etype = EQlist.etype(ind);
 List.magtype = EQlist.magtype(ind);
 List.evname = EQlist.evname(ind);
 List.auth = EQlist.auth(ind);
 List.timestr = EQlist.timestr(ind);
 List.orid = EQlist.orid(ind);
 List.evid = EQlist.evid(ind);
 List.damaging = EQlist.damaging(ind);
 List.questionable = EQlist.questionable(ind);
 List.distancekm = EQlist.distancekm(ind);
 
 if numel(ind) < showNevents
    % Liste gewollt ist kürzer als Daten verfügbar 
    fprintf('It is not possible to limit the list (n=%g) to %g rows! \n',showNevents,numel(ind));
    Listout = List; 
 else
    % Kann Liste kürzen
    Listout.timeflt = List.timeflt(1:showNevents);  
    Listout.lat = List.lat(1:showNevents);
    Listout.lon = List.lon(1:showNevents);
    Listout.depth = List.depth(1:showNevents);
    Listout.ml = List.ml(1:showNevents);
    Listout.inull = List.inull(1:showNevents); 
    Listout.mmacro = List.mmacro(1:showNevents);
    Listout.ilocal = List.ilocal(1:showNevents);
    Listout.accel = List.accel(1:showNevents);
    Listout.etype = List.etype(1:showNevents);
    Listout.magtype = List.magtype(1:showNevents);
    Listout.evname = List.evname(1:showNevents);
    Listout.auth = List.auth(1:showNevents);
    Listout.timestr = List.timestr(1:showNevents);
    Listout.orid = List.orid(1:showNevents);
    Listout.evid = List.evid(1:showNevents); 
    Listout.distancekm = List.distancekm(1:showNevents);
    Listout.damaging = List.damaging(1:showNevents);
    Listout.questionable = List.questionable(1:showNevents); 
    fprintf('The event list was cut from %g to %g rows (showNevents). \n',numel(ind),showNevents);
 end

 
 
 
function [L,B] = getUserInputsSigEQ()

  inp = input('Please enter the latitude B [e.g. 48.1233]\n','s');
  if isnumeric(str2num(inp))
    B = str2num(inp);
  else
    B = 0; fprintf('Value for B not valid!\n (%s)',inp);  
  end

  inp = input('Please enter the longitude L [e.g. 16.7233]\n','s');
  if isnumeric(str2num(inp))
    L = str2num(inp);
  else
    L = 0; fprintf('Value for L not valid! (%s)\n',inp);  
  end


  
function [L,B] = getUserInputsSigEQCities(setting)
shapefilenumber = [];
shapefile = []; shapename = [];

%user input for bundesland
inp = input('Please enter the number for: \n Tirol [1], Steiermark [2], Kärnten [3], Niederösterreich [4]\n Vorarlberg [5], Salzburg [6], Osttirol [7], Burgenland [8], Wien[9], Oberösterreich[10]\n','s');
if isnumeric(str2num(inp))
   shapefilenumber = str2num(inp);
else
   shapefilenumber = 0; fprintf('Value for Bundesland not valid!\n (%s)',inp);  
end

%get the cities from the db
x_lim = [9 18];    y_lim = [46 49.2];
BekannteCities = getBekannteCities(x_lim,y_lim,setting);

%filter the cities according to the stated bundesland
[shapefile,shapename] = getShapeFileInfos(shapefilenumber);
shapefile = fullfile(pwd,'shp',shapefile);
[BekannteCitiesFiltered] = filterBekannteCitiesWithinPolygonShp(BekannteCities,shapefile);


%user input for city
strliste = ''; 
for k=1:numel(BekannteCitiesFiltered.lat)
    curr_name = BekannteCitiesFiltered.name(k);
    strliste = sprintf('%s [%2g] %-20s ',strliste,k,curr_name{1});
    if mod(k,4)==0
       fprintf('%s \n',strliste); 
       strliste = ''; 
    end
end
fprintf('%s \n',strliste); 

inp = input('Please enter a number for the city: \n','s');
if isnumeric(str2num(inp))
  readind = str2num(inp);
  L = BekannteCitiesFiltered.lon(readind);   B = BekannteCitiesFiltered.lat(readind);
else
  L = 0; B = 0;
  fprintf('Value for L not valid! (%s)\n',inp);  
end





