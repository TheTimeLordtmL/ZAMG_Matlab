function writeEQReports(setting,Reports,FeltEQ)
%Write reports grouped by PLZ to a text file

%setting.reportsEQfound.filenameout = sprintf('%s-%s',setting.reportsEQfound.filenameout);
fprintf('...writing %g EQ list (+report sum) to file %s \n',size(Reports,2),setting.reportsEQfound.filenameout);
fileout = fullfile(pwd,setting.textfile.folder,setting.reportsEQfound.filenameout);  
fid = fopen(fileout,'w');

if size(Reports,2)==1
    %only one EQ
    strevent = FeltEQ.timestr; 
    strevent = strevent{1}; 
    currmagtype = FeltEQ.magtype;
    curr_evname = FeltEQ.evname;    curr_evname = char(curr_evname{1});    
    fprintf(fid,'[%g] %s (%3.1f%s) %-16s reports= %g    %5.0f \n',1,strevent,FeltEQ.ml,currmagtype{1},curr_evname,Reports.formcounts,Reports.distmax);
else
    %more than one EQ
  for p=1:size(Reports,2)
    strevent = FeltEQ.timestr(p); 
    strevent = strevent{1}; 
    currmagtype = FeltEQ.magtype(p);
    curr_evname = FeltEQ.evname(p);    curr_evname = char(curr_evname{1});    
    fprintf(fid,'[%g] %s (%3.1f%s) %-16s reports= %g    %5.0f \n',p,strevent,FeltEQ.ml(p),currmagtype{1},curr_evname,Reports(p).formcounts,Reports(p).distmax);           
  end
end
fclose(fid);  fclose('all');