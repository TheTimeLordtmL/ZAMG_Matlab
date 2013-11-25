function writeEMS98code(setting,sumMatrix,legstringal,OneEQReports,figcaption,infoSelectEvent)
%Write the description of the code classes H,I..XYZ
% for objects and human perception for an event
% to a text file

setting.ems98.filenameout = sprintf('%s-%s',setting.textfile.prefix,setting.ems98.filenameout);
fprintf('...writing Object and Human perception to file %s \n',setting.ems98.filenameout);
fileout = fullfile(pwd,setting.textfile.folder,setting.ems98.filenameout);
fid = fopen(fileout,'w');
if iscell(infoSelectEvent)
 fprintf(fid, '%s ',infoSelectEvent{1});
 fprintf(fid, '%s ',infoSelectEvent{2});
 fprintf(fid, '%s ',infoSelectEvent{3});
 fprintf(fid, '%s ',infoSelectEvent{4});
end
fprintf(fid, 'Database: %s \n',setting.db.events);
fprintf(fid, ' Database accessed on  %s \n',datestr(now,'dd-mmm-yyyy HH:MM:SS'));
fprintf(fid, ' \n');
fprintf(fid, 'code  EQ-reports (  %%  ) Obj/Human   Description \n');
              
for k=1:numel(setting.ems98.code)
    currstr = setting.ems98.code{k}; currnumberstack = 0;
    for g=1:numel(legstringal)
        currlegstr = legstringal{g};
        if strcmp(currlegstr,currstr)==1
           currnumberstack = sumMatrix(g);
           g = numel(legstringal);
        end
    end
    fprintf(fid,'[%s] %6g Stück (%4.0f%%): %s \n',currstr,currnumberstack,100/OneEQReports.formcounts*currnumberstack,setting.ems98.descript{k});
end

fclose(fid);  fclose('all');