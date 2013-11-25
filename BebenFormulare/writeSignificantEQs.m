function writeSignificantEQs(EQlistsort,setting)
%Write significant EQs to a text file

switch setting.showSignificantEQs.sortNevents
    case 'acc_McGuire'
        accelstr = 'AccMcGuire';
    case 'acc_Yan'
        accelstr = 'AccYanJia';
    otherwise
        accelstr = 'AccYanJia';
end

%setting.sigEQsEvent.filenameout = sprintf('%s-%s',setting.textfile.prefix,setting.sigEQsEvent.filenameout);
fprintf('...writing %g significant EQs to file %s \n',numel(EQlistsort.timeflt),setting.sigEQsEvent.filenameout);
fileout = fullfile(pwd,setting.textfile.folder,setting.sigEQsEvent.filenameout);
fid = fopen(fileout,'w');
fprintf(fid, 'Database: %s \n',setting.db.aec);
fprintf(fid, ' Database accessed on  %s \n',datestr(now,'dd-mmm-yyyy HH:MM:SS'));
fprintf(fid, ' \n');
fprintf(fid, 'nr,datetime,ml,i0,iloc,mmacro,%s,evname,etype,damage,questionable,auth,b,l,d,dist,orid,evid \n',accelstr);
for p=1:numel(EQlistsort.timeflt)
   evname = EQlistsort.evname(p);   evtype = EQlistsort.etype(p);
   auth = EQlistsort.auth(p); timestr = EQlistsort.timestr(p);
   damage = EQlistsort.damaging(p);  questionable = EQlistsort.questionable(p);
   damagquest = sprintf('%s/%s',damage{1},questionable{1});   
   fprintf(fid,'%2g, %s, %3.1f, %4.1f, %4.1f, %4.1f, %9.5f, %25s, %2s, %3s, %20s, %8.4f, %8.4f, %5.1f, %5.1f, %g, %g\n',p,timestr{1},EQlistsort.ml(p),EQlistsort.inull(p),EQlistsort.ilocal(p),EQlistsort.mmacro(p),EQlistsort.accel(p),evname{1},evtype{1},damagquest,auth{1},EQlistsort.lat(p),EQlistsort.lon(p),EQlistsort.depth(p),EQlistsort.distancekm(p),EQlistsort.orid(p),EQlistsort.evid(p));
end
           

fclose(fid);  fclose('all');