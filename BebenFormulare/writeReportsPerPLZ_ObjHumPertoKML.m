function writeReportsPerPLZ_ObjHumPertoKML(setting,HistPLzDist,HistName,infoSelectEvent,StackrepMatrix)
% // Write reports grouped by PLZ to a KML-File
% output of [HistName,HistPLzDist]:
% out= plz | numberstack | distance | azimuth | lat | lon
% / infoSelectEvent:
% /   {1}..Selected event [1] is on 2012-02-01  {2}..Magnitude: 3.2ml
% /   {3}..Location: Pitten 48.3332 16.4531  {4}..Reports: 234   evid: 522124    orid: 105475
% /   {5}..date  {6}..magnitude  {7}..location  {8}..curr_timespan  
% /   {9}..timeflt {10}..latitude  {11}..longitude
%
% legstringall = {'H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','00','03','06','11','20','k','g','r','s','z'};
%  Obj.   H     I     J     K     L     M     N     O     P    Human  Q     R     S     T     U     V     W     X     Y     Z  dm dg Stock 0     3     6     11   20   Knal   Grol   Ruc   Sch   Zit\n');
%       (k,1),(k,2),(k,3),(k,4),(k,5),(k,6),(k,7),(k,8),(k,9),     (k,10)(k,11)(k,12),(k,13)(k,14)(k,15)(k,16)(k,17)(k,18)(k,19)(k,20)(k,21)  (k,22)(k,23)(k,24)(k,25),(k,26),(k,27)(k,28),(k,29),(k,30),(k,31));

filenameout = sprintf('%s-%s',setting.textfile.prefix,setting.kml.reportsPerPLZ_ObjHumPer);
fprintf('...writing %g locations (reports grouped by PLZ) to file %s \n',size(HistPLzDist,1),filenameout);
fileout = fullfile(pwd,setting.textfile.folder,filenameout);

% // file header
fid = fopen(fileout,'w');
fprintf(fid, '<?xml version="1.0" encoding="UTF-8"?> \n');
fprintf(fid, '<kml xmlns="http://www.opengis.net/kml/2.2"> \n');
fprintf(fid, '<Document> \n');
fprintf(fid, '<name>%s-M%g_ObjHumPer</name> \n',infoSelectEvent{5},infoSelectEvent{6});
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
fprintf(fid, '<name>Reports_additional</name><description>Projekt HAREIRA2</description><visibility>1</visibility> \n');
fprintf(fid, '<View><longitude>%6.3f</longitude><latitude>%6.3f</latitude><range>3800000</range><tilt>0</tilt><heading>0</heading></View> \n',infoSelectEvent{11},infoSelectEvent{10});

% // plot the stacked PlZ locations
for k=1:size(HistPLzDist,1)    
   fprintf(fid, '<Placemark> \n');
   fprintf(fid, '<description><![CDATA[%g Reports aus %g %s <br/>dist=%5.0fkm, azi=%7.3f <br/>lat=%7.4f lon=%7.4f<br/>Trembling-: %g  Trembling+: %g  Awake: %g  Frightened: %g<br/>SmallOnjFall: %g  GlasswaBreak: %g  FurnitureShif: %g  HeavyObjFall: %g  <br/>Knall: %g   Grollen: %g   Ruck: %g   Schwank: %g   Zittern: %g     Damages:  %g   DM-Grade:  %g]]></description>\n',...
       HistPLzDist(k,2),HistPLzDist(k,1),HistName{k},HistPLzDist(k,3),HistPLzDist(k,4),HistPLzDist(k,5),HistPLzDist(k,6),...
       StackrepMatrix(k,13),StackrepMatrix(k,15),StackrepMatrix(k,14),StackrepMatrix(k,17),...
       StackrepMatrix(k,6),StackrepMatrix(k,7),StackrepMatrix(k,8),StackrepMatrix(k,9),...
      StackrepMatrix(k,25),StackrepMatrix(k,26),StackrepMatrix(k,27),StackrepMatrix(k,28),StackrepMatrix(k,29),StackrepMatrix(k,20),StackrepMatrix(k,21));    
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
fprintf(fid, '<name>Epicentre_additional</name><description>Projekt HAREIRA2</description><visibility>1</visibility> \n');
fprintf(fid, '<View><longitude>%6.3f</longitude><latitude>%6.3f</latitude><range>3800000</range><tilt>0</tilt><heading>0</heading></View> \n',infoSelectEvent{11},infoSelectEvent{10});

fprintf(fid, '<Placemark> \n');
fprintf(fid, '<description><![CDATA[%s<br/>%s<br/>%s<br/>%s]]></description>\n',infoSelectEvent{1},infoSelectEvent{2},infoSelectEvent{3},infoSelectEvent{4});    
fprintf(fid, '<name></name> \n');  
fprintf(fid, '<LookAt><latitude>%7.4f</latitude><longitude>%7.4f</longitude><range>75000</range></LookAt> \n',infoSelectEvent{10},infoSelectEvent{11});  
symsize = setting.kml.symbolsizeepicentre.k * infoSelectEvent{6}  + setting.kml.symbolsizeepicentre.d;
fprintf(fid, '<styleUrl>#symbol2</styleUrl><Style><geomScale>%3.1f</geomScale></Style> \n',symsize);
fprintf(fid, '<Point><coordinates>%7.4f,%7.4f,0</coordinates></Point>',infoSelectEvent{11},infoSelectEvent{10});    
fprintf(fid, '</Placemark> \n'); 

fprintf(fid, '</Folder> \n');
fprintf(fid, '</Document> \n');
fprintf(fid, '</kml> \n');

fclose(fid);  fclose('all');