function writeReportsPerPLZ_DamagestoKML(setting,HistPLzDist,HistName,infoSelectEvent,StackrepMatrix)
%write only the reported damages to the KML format

filenameout = sprintf('%s-%s',setting.textfile.prefix,setting.kml.reportsDamages);
fprintf('...writing locations with damages grouped by PLZ to file %s \n',filenameout);
fileout = fullfile(pwd,setting.textfile.folder,filenameout);

% // file header
fid = fopen(fileout,'w');
fprintf(fid, '<?xml version="1.0" encoding="UTF-8"?> \n');
fprintf(fid, '<kml xmlns="http://www.opengis.net/kml/2.2"> \n');
fprintf(fid, '<Document> \n');
fprintf(fid, '<name>%s-M%g_Damages</name> \n',infoSelectEvent{5},infoSelectEvent{6});
fprintf(fid, '  <Style id="symbol1"> \n');
fprintf(fid, '  <IconStyle> \n');
fprintf(fid, '    <Icon><href>%s</href></Icon></IconStyle> \n',setting.kml.symbol{3});
fprintf(fid, '    <LineStyle><width>%g</width></LineStyle> \n',setting.kml.linestyle{3});
fprintf(fid, '  </Style> \n \n');

fprintf(fid, '  <Style id="symbol2"> \n');
fprintf(fid, '  <IconStyle> \n');
fprintf(fid, '    <Icon><href>%s</href></Icon></IconStyle> \n',setting.kml.symbol{2});
fprintf(fid, '    <LineStyle><width>%g</width></LineStyle> \n',setting.kml.linestyle{2});
fprintf(fid, '  </Style> \n \n');

fprintf(fid, '<Folder> \n');
fprintf(fid, '<name>Damages</name><description>Projekt HAREIRA3</description><visibility>1</visibility> \n');
fprintf(fid, '<View><longitude>%6.3f</longitude><latitude>%6.3f</latitude><range>3800000</range><tilt>0</tilt><heading>0</heading></View> \n',infoSelectEvent{11},infoSelectEvent{10});



% // plot the stacked PlZ locations
for k=1:size(HistPLzDist,1)
    if HistPLzDist(k,7) > 0
        fprintf(fid, '<Placemark> \n');
        fprintf(fid, '<description><![CDATA[%g Reports aus %g %s <br/>dist=%5.0fkm, azi=%7.3f <br/>lat=%7.4f lon=%7.4f<br/>Trembling-: %g  Trembling+: %g  Awake: %g  Frightened: %g<br/>SmallOnjFall: %g  GlasswaBreak: %g  FurnitureShif: %g  HeavyObjFall: %g  <br/>Knall: %g   Grollen: %g   Ruck: %g   Schwank: %g   Zittern: %g     Damages:  %g   DM-Grade:  %g]]></description>\n',...
            HistPLzDist(k,2),HistPLzDist(k,1),HistName{k},HistPLzDist(k,3),HistPLzDist(k,4),HistPLzDist(k,5),HistPLzDist(k,6),...
            StackrepMatrix(k,13),StackrepMatrix(k,15),StackrepMatrix(k,14),StackrepMatrix(k,17),...
            StackrepMatrix(k,6),StackrepMatrix(k,7),StackrepMatrix(k,8),StackrepMatrix(k,9),...
            StackrepMatrix(k,25),StackrepMatrix(k,26),StackrepMatrix(k,27),StackrepMatrix(k,28),StackrepMatrix(k,29),StackrepMatrix(k,20),StackrepMatrix(k,21));
        fprintf(fid, '<name></name> \n');
        %fprintf(fid,'[%3g] %6g Meldungen aus %g   %-35s  %3.0fkm             %3.0f         %8.4f        %8.4f\n',k,HistPLzDist(k,2),HistPLzDist(k,1),HistName{k},HistPLzDist(k,3),HistPLzDist(k,4),HistPLzDist(k,5),HistPLzDist(k,6));
        fprintf(fid, '<LookAt><latitude>%7.4f</latitude><longitude>%7.4f</longitude><range>75000</range></LookAt> \n',HistPLzDist(k,5),HistPLzDist(k,6));
        symsize = setting.kml.symbolsizedamages.k * HistPLzDist(k,7)  + setting.kml.symbolsizedamages.d;
        fprintf(fid, '<styleUrl>#symbol1</styleUrl><Style><geomScale>%3.1f</geomScale></Style> \n',symsize);
        fprintf(fid, '<Point><coordinates>%7.4f,%7.4f,0</coordinates></Point>',HistPLzDist(k,6),HistPLzDist(k,5));
        fprintf(fid, '</Placemark> \n');
    end
end
fprintf(fid, '</Folder> \n');


fprintf(fid, '</Document> \n');
fprintf(fid, '</kml> \n');

fclose(fid);  fclose('all');


