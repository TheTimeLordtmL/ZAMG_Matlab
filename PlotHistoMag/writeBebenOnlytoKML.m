function writeBebenOnlytoKML(setting,datastructhist)
% // Write reports grouped by PLZ to a KML-File
% output of [HistName,HistPLzDist]:
% out= plz | numberstack | distance | azimuth | lat | lon
% / infoSelectEvent:
% /   {1}..Selected event [1] is on 2012-02-01  {2}..Magnitude: 3.2ml
% /   {3}..Location: Pitten 48.3332 16.4531  {4}..Reports: 234   evid: 522124    orid: 105475
% /   {5}..date  {6}..magnitude  {7}..location  {8}..curr_timespan  
% /   {9}..timeflt {10}..latitude  {11}..longitude

magval = setting.eqlist.minmag;

switch setting.eqlist.symbolrangeKML
    case 0
        %no scaling
        filenameout = sprintf('%s-%s','beben','liste_noscale.kml');
    case 1
        filenameout = sprintf('%s-%s','beben','liste_magscale.kml');
    case 2
        filenameout = sprintf('%s-%s','beben','liste_depscale.kml');
end
fprintf('...writing beben only to file %s \n',filenameout);
fileout = fullfile(pwd,setting.textfile.folder,filenameout);

% // file header
fid = fopen(fileout,'w');
fprintf(fid, '<?xml version="1.0" encoding="UTF-8"?> \n');
fprintf(fid, '<kml xmlns="http://www.opengis.net/kml/2.2"> \n');
fprintf(fid, '<Document> \n');
fprintf(fid, '<name>%s-M%g</name> \n','Bebenliste',99999);
fprintf(fid, '  <Style id="symbol1"> \n');
fprintf(fid, '  <IconStyle> \n');
fprintf(fid, '    <Icon><href>%s</href></Icon></IconStyle> \n',setting.kml.symbol{1});
fprintf(fid, '    <LineStyle><width>%g</width></LineStyle> \n',setting.kml.linestyle{1});
fprintf(fid, '  </Style> \n \n');

fprintf(fid, '  <Style id="symbol2"> \n');
fprintf(fid, '  <IconStyle> \n');
fprintf(fid, '    <Icon><href>%s</href></Icon></IconStyle> \n',setting.kml.symbol{2});
fprintf(fid, '    <LineStyle><width>%g</width></LineStyle> \n',setting.kml.linestyle{2});
fprintf(fid, '  </Style> \n \n');

fprintf(fid, '<Folder> \n');
fprintf(fid, '<name>Reports</name><description>Projekt HAREIRA</description><visibility>1</visibility> \n');
fprintf(fid, '<View><longitude>%6.3f</longitude><latitude>%6.3f</latitude><range>3800000</range><tilt>0</tilt><heading>0</heading></View> \n',15.0,47.5);

% // plot the stacked PlZ locations
for k=1:size(datastructhist,2) 
   curr_datestr = datastructhist(k).datestr;
   curr_mag = datastructhist(k).netmag;
   curr_evname = datastructhist(k).evname;
   curr_lat = datastructhist(k).origin.lat;
   curr_lon = datastructhist(k).origin.lon; 
   curr_orid = datastructhist(k).orid;
   curr_depth = datastructhist(k).origin.depth;
   curr_etype = datastructhist(k).etype;   
   if curr_mag >= magval
       fprintf(fid, '<Placemark> \n');
       switch setting.eqlist.format
           case 1
               fprintf(fid, '<description><![CDATA[Ort: %s <br/>Ml=%4.1f Date: %s <br/>lat=%7.4f lon=%7.4f  orid %16.0f]]></description>\n',curr_evname{1},curr_mag,curr_datestr{1},curr_lat,curr_lon,curr_orid);
           case 2
               fprintf(fid, '<description><![CDATA[Ort: %s <br/>Ml=%4.1f Date: %s <br/>lat=%7.4f lon=%7.4f  depth=%4.1f  orid %16.0f <br/> etype=%2s ]]></description>\n',curr_evname{1},curr_mag,curr_datestr{1},curr_lat,curr_lon,curr_depth,curr_orid,curr_etype{1});
       end
       fprintf(fid, '<name></name> \n');
       fprintf(fid, '<LookAt><latitude>%7.4f</latitude><longitude>%7.4f</longitude><range>75000</range></LookAt> \n',curr_lat,curr_lon);
       switch setting.eqlist.symbolrangeKML
           case 0
               %no scaling
               symsize = setting.eqlist.symbolsize;
           case 1
               symsize = setting.kml.symbolsizeepicentre.k * curr_mag  + setting.kml.symbolsizeepicentre.d;
           case 2
               symsize = setting.kml.symbolsizedepth.k * curr_depth  + setting.kml.symbolsizedepth.d;
       end
       fprintf(fid, '<styleUrl>#symbol1</styleUrl><Style><geomScale>%3.1f</geomScale></Style> \n',symsize);
       fprintf(fid, '<Point><coordinates>%7.4f,%7.4f,0</coordinates></Point>',curr_lon,curr_lat);
       fprintf(fid, '</Placemark> \n');
   end
end
fprintf(fid, '</Folder> \n');


fprintf(fid, '</Document> \n');
fprintf(fid, '</kml> \n');

fclose(fid);  fclose('all');