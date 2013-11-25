function displaySignificantEQs(EQlistsort,B,L,setting)
%display the significant EQ's and the selected event
% with bundesländer grenzen etc.

figure; hold on;

%plot boundary in back ground
bound_oo = fullfile(pwd,'shp','Oberösterreich.shp');  [shape_oo] = shaperead(bound_oo);
bound_ti = fullfile(pwd,'shp','Tirol.shp');  [shape_ti] = shaperead(bound_ti);
bound_st = fullfile(pwd,'shp','Steiermark.shp');  [shape_st] = shaperead(bound_st);
bound_kt = fullfile(pwd,'shp','Kärnten.shp');  [shape_kt] = shaperead(bound_kt);
bound_sb = fullfile(pwd,'shp','Salzburg.shp');  [shape_sb] = shaperead(bound_sb);
bound_no = fullfile(pwd,'shp','Niederösterreich.shp');  [shape_no] = shaperead(bound_no);
bound_vo = fullfile(pwd,'shp','Vorarlberg.shp');  [shape_vo] = shaperead(bound_vo);
bound_bl = fullfile(pwd,'shp','Burgenland.shp');  [shape_bl] = shaperead(bound_bl);

for k=1:size(shape_oo,1)
  plot(shape_oo(k).X(:),shape_oo(k).Y(:),'-k','Linewidth',0.5);
end
for k=1:size(shape_ti,1)
  plot(shape_ti(k).X(:),shape_ti(k).Y(:),'-k','Linewidth',0.5);
end
for k=1:size(shape_st,1)
  plot(shape_st(k).X(:),shape_st(k).Y(:),'-k','Linewidth',0.5);
end
for k=1:size(shape_kt,1)
  plot(shape_kt(k).X(:),shape_kt(k).Y(:),'-k','Linewidth',0.5);
end
for k=1:size(shape_sb,1)
  plot(shape_sb(k).X(:),shape_sb(k).Y(:),'-k','Linewidth',0.5);
end
for k=1:size(shape_no,1)
  plot(shape_no(k).X(:),shape_no(k).Y(:),'-k','Linewidth',0.5);
end
for k=1:size(shape_vo,1)
  plot(shape_vo(k).X(:),shape_vo(k).Y(:),'-k','Linewidth',0.5);
end
for k=1:size(shape_bl,1)
  plot(shape_bl(k).X(:),shape_bl(k).Y(:),'-k','Linewidth',0.5);
end



%plot the main current event
plot(L,B,'pr','Markersize',16);

%plot the historic ones
for p=1:numel(EQlistsort.timeflt)
   curry = EQlistsort.lat(p);
   currx = EQlistsort.lon(p);
   tmp= rand();   currx = currx + tmp*0.0051;   %add noise since hist. data have same locations
   tmp= rand();   curry = curry + tmp*0.0035;
   currmag = EQlistsort.ml(p);
   currinull = EQlistsort.inull(p);
   msize = getCurrMarkersise(currmag,currinull,setting);
   plot(currx,curry,'ob','Markersize',msize,'MarkerFaceColor','g'); 
   %timestring = EQlistsort.timestr(p);
   text(currx,curry,sprintf('%2g',p),'Fontsize',18);
end

%plot the cities
[x_lim,y_lim] = getAusschnittKarte(EQlistsort,B,L);
BekannteCities = getBekannteCities(x_lim,y_lim,setting);
for p=1:numel(BekannteCities.lat)
   curry = BekannteCities.lat(p);
   currx = BekannteCities.lon(p); 
   name = BekannteCities.name(p);
   plot(currx,curry,'ok','Markersize',2); 
   text(currx,curry,name{1},'Fontsize',14);
end

xlim(x_lim);
ylim(y_lim);
disp(' ');



function [x_lim,y_lim] = getAusschnittKarte(EQlistsort,B,L)
%use coordinates to estimate a proper ausschnitt
% for the map
randfak = 0.4;

Lvec = [EQlistsort.lon(:);L];
Bvec = [EQlistsort.lat(:);B];

x_lim = [min(Lvec) max(Lvec)];
y_lim = [min(Bvec) max(Bvec)];

distL = x_lim(2)-x_lim(1);
distB = y_lim(2)-y_lim(1);

if distL > distB
   distL = distL + randfak;
   distB = (distL + randfak)*0.6745;    %skaliere wegen abbildung ellipsoid
else
   distB = distB + randfak;
   distL = (distB + randfak)*1.4826;    %skaliere wegen abbildung ellipsoid 
end

distLmean = x_lim(2) - (x_lim(2)-x_lim(1))/2;
distBmean = y_lim(2) - (y_lim(2)-y_lim(1))/2;

x_lim = [distLmean-distL/2 distLmean+distL/2];
y_lim = [distBmean-distB/2 distBmean+distB/2];
%plot(x_lim,y_lim,'-or');
disp('d');




function msize = getCurrMarkersise(currmag,currinull,setting)
%get the marker size for plotting magnitude or intesity

switch setting.showSignificantEQs.sortNevents
    case 'localintensity'
       msize = 10*currinull-20;
       if msize <= 0
           msize = 5;
       end        
    case 'intensity'
       msize = 10*currinull-20;
       if msize <= 0
           msize = 5;
       end
    case 'magnitude'
       msize = 15*currmag-20;   
    case 'acc_McGuire'
       msize = 28.6*currmag+18.57;   
    case 'acc_Yan'
       msize = 28.6*currmag+18.57;          
end




