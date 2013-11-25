function writeEQFrequency(Ilocal,EQ3listLocal,setting)
%Write significant EQ frequencies to a text file

setting.logNJahr.filenameout = sprintf('%s-%s',setting.textfile.prefix,setting.logNJahr.filenameout);
fprintf('...writing significant EQs to file %s \n',setting.logNJahr.filenameout);
fileout = fullfile(pwd,setting.textfile.folder,setting.logNJahr.filenameout);
fid = fopen(fileout,'w');
fprintf(fid, 'Database: %s \n',setting.db.aec);
fprintf(fid, ' Database accessed on  %s \n',datestr(now,'dd-mmm-yyyy HH:MM:SS'));
fprintf(fid, ' \n');
fprintf(fid, 'log(N/Jahre) = +%5.3f  +%5.3f Iloc \n',Ilocal.b0,Ilocal.b1);
p = 0;
for j=3:7
   p = p + 1;
   prnstring1 = sprintf('Intensität: %3.0g   Wiederkehrperiode %5.0f Jahre \n',j,1/(10^(Ilocal.b0 + Ilocal.b1 * j)));
   prnstring2 = printLastThreeEQs(EQ3listLocal{p},setting);
   fprintf(fid, '%s',prnstring1);
   for k=1:numel(prnstring2)  
     fprintf(fid, '%s',prnstring2{k});
   end   
   fprintf(fid, ' ');
end


fclose(fid);  fclose('all');