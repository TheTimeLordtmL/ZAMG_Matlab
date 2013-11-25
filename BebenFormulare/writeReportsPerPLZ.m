function writeReportsPerPLZ(setting,HistPLzDist,HistName,infoSelectEvent)
% // Write reports grouped by PLZ to a text file
% output of [HistName,HistPLzDist]:
% out= plz | numberstack | distance | azimuth | lat | lon


setting.reportsPerPLZ.filenameout = sprintf('%s-%s',setting.textfile.prefix,setting.reportsPerPLZ.filenameout);
fprintf('...writing %g reports grouped by PLZ to file %s \n',size(HistPLzDist,1),setting.reportsPerPLZ.filenameout);
fileout = fullfile(pwd,setting.textfile.folder,setting.reportsPerPLZ.filenameout);
fid = fopen(fileout,'w');
fprintf(fid, '%s ',infoSelectEvent{1});
fprintf(fid, '%s ',infoSelectEvent{2});
fprintf(fid, '%s ',infoSelectEvent{3});
fprintf(fid, '%s ',infoSelectEvent{4});
fprintf(fid, 'Database: %s \n',setting.db.events);
fprintf(fid, ' Database accessed on  %s \n',datestr(now,'dd-mmm-yyyy HH:MM:SS'));
fprintf(fid, ' \n');
fprintf(fid, '  #     #EQ-reports PLZ    Location                     Dist.fromEpiz.(km)  Azimuth(deg)    Latitude(deg)    Longitude(deg)\n');

for k=1:size(HistPLzDist,1)    
    fprintf(fid,'%3g %6g Meldungen %g   %-35s  %3.0fkm             %3.0f         %8.4f        %8.4f\n',k,HistPLzDist(k,2),HistPLzDist(k,1),HistName{k},HistPLzDist(k,3),HistPLzDist(k,4),HistPLzDist(k,5),HistPLzDist(k,6));
end              
fprintf(fid,'The sum of the reports after stacking is %g.\n',sum(HistPLzDist(:,2)));
fclose(fid);  fclose('all');