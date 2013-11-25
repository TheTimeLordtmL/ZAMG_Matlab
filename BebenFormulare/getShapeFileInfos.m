function [shapefile,shapename] = getShapeFileInfos(selectedLandgrenzen)
shapefile = '';
shapename = 'not defined';

switch selectedLandgrenzen
       case 0
           shapefile = 'Österreich.shp';
           shapename = 'Österreich';
       case 1
           shapefile = 'Tirol.shp';
           shapename = 'Tirol';
       case 2
           shapefile = 'Steiermark.shp';
           shapename = 'Steiermark';
       case 3
           shapefile = 'Kärnten.shp';
           shapename = 'Kärnten';
       case 4
           shapefile = 'Niederösterreich.shp';
           shapename = 'Niederösterreich';
       case 5
           shapefile = 'Vorarlberg.shp';
           shapename = 'Vorarlberg';
       case 6
           shapefile = 'Salzburg.shp';
           shapename = 'Salzburg';
       case 7
           shapefile = 'TirolplusOst.shp'; 
           shapename = 'Osttirol';
       case 8
           shapefile = 'Burgenland.shp'; 
           shapename = 'Burgenland';
       case 9
           shapefile = 'Wien.shp';
           shapename = 'Wien';
       case 10
           shapefile = 'Oberösterreich.shp';
           shapename = 'Oberösterreich';
       case 11
           shapefile = 'tmp_ln.shp';
           shapename = 'test';               
end