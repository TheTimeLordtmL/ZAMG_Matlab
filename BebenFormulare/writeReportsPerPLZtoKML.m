function writeReportsPerPLZtoKML(setting,HistPLzDist,HistName,infoSelectEvent)
% // Write reports grouped by PLZ to a KML-File
% output of [HistName,HistPLzDist]:
% out= plz | numberstack | distance | azimuth | lat | lon
% / infoSelectEvent:
% /   {1}..Selected event [1] is on 2012-02-01  {2}..Magnitude: 3.2ml
% /   {3}..Location: Pitten 48.3332 16.4531  {4}..Reports: 234   evid: 522124    orid: 105475
% /   {5}..date  {6}..magnitude  {7}..location  {8}..curr_timespan  
% /   {9}..timeflt {10}..latitude  {11}..longitude

filenameout = sprintf('%s-%s',setting.textfile.prefix,setting.kml.reportsPerPLZ);
fprintf('...writing %g reports grouped by PLZ to file %s \n',size(HistPLzDist,1),filenameout);
fileout = fullfile(pwd,setting.textfile.folder,filenameout);

% // file header
fid = fopen(fileout,'w');
fprintf(fid, '<?xml version="1.0" encoding="UTF-8"?> \n');
fprintf(fid, '<kml xmlns="http://www.opengis.net/kml/2.2"> \n');
fprintf(fid, '<Document> \n');
fprintf(fid, '<name>%s-M%g</name> \n',infoSelectEvent{5},infoSelectEvent{6});
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
fprintf(fid, '<View><longitude>%6.3f</longitude><latitude>%6.3f</latitude><range>3800000</range><tilt>0</tilt><heading>0</heading></View> \n',infoSelectEvent{11},infoSelectEvent{10});

% // plot the stacked PlZ locations
for k=1:size(HistPLzDist,1)    
   fprintf(fid, '<Placemark> \n');
   fprintf(fid, '<description><![CDATA[%g Reports aus %g %s <br/>dist=%5.0fkm, azi=%7.3f <br/>lat=%7.4f lon=%7.4f]]></description>\n',HistPLzDist(k,2),HistPLzDist(k,1),HistName{k},HistPLzDist(k,3),HistPLzDist(k,4),HistPLzDist(k,5),HistPLzDist(k,6));    
   fprintf(fid, '<name></name> \n');  
   %fprintf(fid,'[%3g] %6g Meldungen aus %g   %-35s  %3.0fkm             %3.0f         %8.4f        %8.4f\n',k,HistPLzDist(k,2),HistPLzDist(k,1),HistName{k},HistPLzDist(k,3),HistPLzDist(k,4),HistPLzDist(k,5),HistPLzDist(k,6));
   fprintf(fid, '<LookAt><latitude>%7.4f</latitude><longitude>%7.4f</longitude><range>75000</range></LookAt> \n',HistPLzDist(k,5),HistPLzDist(k,6));  
   symsize = setting.kml.symbolsizereport.k * HistPLzDist(k,2)  + setting.kml.symbolsizereport.d;
   fprintf(fid, '<styleUrl>#symbol1</styleUrl><Style><geomScale>%3.1f</geomScale></Style> \n',symsize);
   fprintf(fid, '<Point><coordinates>%7.4f,%7.4f,0</coordinates></Point>',HistPLzDist(k,6),HistPLzDist(k,5));    
   fprintf(fid, '</Placemark> \n');  
end       
fprintf(fid, '</Folder> \n');

% // plot the epicentre
fprintf(fid, '<Folder> \n');
fprintf(fid, '<name>Epicentre</name><description>Projekt HAREIRA</description><visibility>1</visibility> \n');
fprintf(fid, '<View><longitude>%6.3f</longitude><latitude>%6.3f</latitude><range>3800000</range><tilt>0</tilt><heading>0</heading></View> \n',infoSelectEvent{11},infoSelectEvent{10});

fprintf(fid, '<Placemark> \n');
fprintf(fid, '<description><![CDATA[%s<br/>%s<br/>%s<br/>%s]]></description>\n',infoSelectEvent{1},infoSelectEvent{2},infoSelectEvent{3},infoSelectEvent{4});    
fprintf(fid, '<name></name> \n');  
fprintf(fid, '<LookAt><latitude>%7.4f</latitude><longitude>%7.4f</longitude><range>75000</range></LookAt> \n',infoSelectEvent{10},infoSelectEvent{11});  
symsize = setting.kml.symbolsizeepicentre.k * infoSelectEvent{6} + setting.kml.symbolsizeepicentre.d;
fprintf(fid, '<styleUrl>#symbol2</styleUrl><Style><geomScale>%3.1f</geomScale></Style> \n',symsize);
fprintf(fid, '<Point><coordinates>%7.4f,%7.4f,0</coordinates></Point>',infoSelectEvent{11},infoSelectEvent{10});    
fprintf(fid, '</Placemark> \n'); 

fprintf(fid, '</Folder> \n');
fprintf(fid, '</Document> \n');
fprintf(fid, '</kml> \n');

fclose(fid);  fclose('all');