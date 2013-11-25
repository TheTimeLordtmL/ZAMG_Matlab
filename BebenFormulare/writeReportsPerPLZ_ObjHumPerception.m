function writeReportsPerPLZ_ObjHumPerception(setting,HistPLzDist,HistName,infoSelectEvent,StackrepMatrix)
%Write reports grouped by PLZ with the Object Human Matrix sums to a text file

setting.reportsPerPLZEObjHumPerception.filenameout = sprintf('%s-%s',setting.textfile.prefix,setting.reportsPerPLZEObjHumPerception.filenameout);
fprintf('...writing %g locations (reports grouped by PLZ) to file %s \n',size(HistPLzDist,1),setting.reportsPerPLZEObjHumPerception.filenameout);
fileout = fullfile(pwd,setting.textfile.folder,setting.reportsPerPLZEObjHumPerception.filenameout);
fid = fopen(fileout,'w');
fprintf(fid, '%s ',infoSelectEvent{1});
fprintf(fid, '%s ',infoSelectEvent{2});
fprintf(fid, '%s ',infoSelectEvent{3});
fprintf(fid, '%s ',infoSelectEvent{4});
fprintf(fid, 'Database: %s \n',setting.db.events);
fprintf(fid, ' Database accessed on  %s \n',datestr(now,'dd-mmm-yyyy HH:MM:SS'));
fprintf(fid, ' \n');
fprintf(fid, '   #     #EQ-reports  PLZ   Location             Dist. (km) Obj.   H     I     J     K     L     M     N     O     P    Human  Q     R     S     T     U     V     W     X     Y     Z   dm dmgrad Stock 0     3     6     11   20   Knal   Grol   Ruc   Sch   Zit\n');

if size(HistName,1) == size(StackrepMatrix,1)
   for k=1:size(HistPLzDist,1)    
       fprintf(fid,'%4g %6g Meldungen %g %-24s  %3.0fkm     %5.0f %5.0f %5.0f %5.0f %5.0f %5.0f %5.0f %5.0f %5.0f       %5.0f %5.0f %5.0f %5.0f %5.0f %5.0f %5.0f %5.0f %5.0f %5.0f %5.0f %5.0f   %5.0f %5.0f %5.0f %5.0f %5.0f  %5.0f %5.0f %5.0f %5.0f %5.0f\n',k,HistPLzDist(k,2),HistPLzDist(k,1),HistName{k},HistPLzDist(k,3),...
           StackrepMatrix(k,1),StackrepMatrix(k,2),StackrepMatrix(k,3),StackrepMatrix(k,4),StackrepMatrix(k,5),StackrepMatrix(k,6),StackrepMatrix(k,7),StackrepMatrix(k,8),StackrepMatrix(k,9),...
           StackrepMatrix(k,10),StackrepMatrix(k,11),StackrepMatrix(k,12),StackrepMatrix(k,13),StackrepMatrix(k,14),StackrepMatrix(k,15),StackrepMatrix(k,16),StackrepMatrix(k,17),StackrepMatrix(k,18),...
           StackrepMatrix(k,19),StackrepMatrix(k,20),StackrepMatrix(k,21),StackrepMatrix(k,22),StackrepMatrix(k,23),StackrepMatrix(k,24),StackrepMatrix(k,25),StackrepMatrix(k,26),StackrepMatrix(k,27),...
           StackrepMatrix(k,28),StackrepMatrix(k,29),StackrepMatrix(k,30),StackrepMatrix(k,31));
   end      
else
   fprintf('[warning] size of variables HistName and StackrepMatrix are different (%s)\n',setting.reportsPerPLZEObjHumPerception.filenameout); 
end

fclose(fid);  fclose('all');
%disp(' ');
