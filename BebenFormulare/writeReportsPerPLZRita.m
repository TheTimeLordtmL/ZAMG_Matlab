function writeReportsPerPLZRita(setting,HistPLzDist,HistName,infoSelectEvent)
% // Write reports grouped by PLZ to a text file
% output of [HistName,HistPLzDist]:
% out= plz | numberstack | distance | azimuth | lat | lon


setting.reportsPerPLZ.filenameout = sprintf('%s-%s',setting.textfile.prefix,setting.reportsPerPLZRita.filenameout);
fprintf('...writing %g reports grouped by PLZ to file %s \n',size(HistPLzDist,1),setting.reportsPerPLZ.filenameout);
fileout = fullfile(pwd,setting.textfile.folder,setting.reportsPerPLZ.filenameout);
fid = fopen(fileout,'w');
fprintf(fid, ' PLZ   Ort                                   Breite(deg)    Laenge(deg)  Anzahl\n');

for k=1:size(HistPLzDist,1)    
    fprintf(fid,'%5g  %-35s  %8.4f       %8.4f       %6g \n',HistPLzDist(k,1),HistName{k},HistPLzDist(k,5),HistPLzDist(k,6),HistPLzDist(k,2));
end              
fclose(fid);  fclose('all');

