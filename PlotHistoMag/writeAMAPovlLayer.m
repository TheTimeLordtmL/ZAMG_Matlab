function writeAMAPovlLayer(setting,datastructhist)
% // Write EQ List to AMAP overlay format *.ovl
% settings are defined in getSettings.m

magval = setting.eqlist.minmag;

setting.reportsPerPLZ.filenameout = sprintf('%s-%s','beben','AMAP.ovl');
fprintf('...writing earthquake list to file %s (Austrian Map, BEV)\n',setting.reportsPerPLZ.filenameout);
fileout = fullfile(pwd,setting.textfile.folder,setting.reportsPerPLZ.filenameout);
fid = fopen(fileout,'w');
%                               170768        5/19/2006  14:00:22.899  St. Veit an der                                  3.5   46.8085  14.3702
symbcount = 0;
for k=1:size(datastructhist,2)
    curr_datestr = datastructhist(k).datestr;
    curr_mag = datastructhist(k).netmag;
    curr_evname = datastructhist(k).evname;
    curr_lat = datastructhist(k).origin.lat;
    curr_lon = datastructhist(k).origin.lon;
    curr_orid = datastructhist(k).orid;
    curr_depth = datastructhist(k).origin.depth;
    curr_etype = datastructhist(k).etype;
    curr_inull = datastructhist(k).inull;
    curr_evid = datastructhist(k).evid;
    lat(k) = curr_lat;
    lon(k) = curr_lon;
    
    %make the first circle symbol 
    symbcount = symbcount + 1;
    fprintf(fid,'[Symbol %-g]\n',symbcount);
    fprintf(fid,'Typ=%g\n',setting.eqlist.amap.typ);
    fprintf(fid,'Group=%g\n',setting.eqlist.amap.group);
    fprintf(fid,'Width=%g\n',setting.eqlist.amap.width);
    fprintf(fid,'Height=%g\n',setting.eqlist.amap.height );
    fprintf(fid,'Dir=%g\n',setting.eqlist.amap.dir);
    fprintf(fid,'Col=%g\n',setting.eqlist.amap.col);
    fprintf(fid,'Zoom=%g\n',setting.eqlist.amap.zoom);
    fprintf(fid,'Size=%g\n',setting.eqlist.amap.size);
    fprintf(fid,'Area=%g\n',setting.eqlist.amap.area);
    fprintf(fid,'XKoord=%-9.5f\n',curr_lon);
    fprintf(fid,'YKoord=%-8.5f\n',curr_lat);
       
    if setting.eqlist.amap.plottwocircles == 1
        %make the second circle symbol
        symbcount = symbcount + 1;
        fprintf(fid,'[Symbol %-g]\n',symbcount);
        fprintf(fid,'Typ=%g\n',setting.eqlist.amap.typ);
        fprintf(fid,'Group=%g\n',setting.eqlist.amap.group+1);
        fprintf(fid,'Width=%g\n',setting.eqlist.amap.width2);
        fprintf(fid,'Height=%g\n',setting.eqlist.amap.height2 );
        fprintf(fid,'Dir=%g\n',setting.eqlist.amap.dir);
        fprintf(fid,'Col=%g\n',setting.eqlist.amap.col2);
        fprintf(fid,'Zoom=%g\n',setting.eqlist.amap.zoom);
        fprintf(fid,'Size=%g\n',setting.eqlist.amap.size);
        fprintf(fid,'Area=%g\n',setting.eqlist.amap.area);
        fprintf(fid,'XKoord=%-9.5f\n',curr_lon);
        fprintf(fid,'YKoord=%-8.5f\n',curr_lat);
    end
    
    if setting.eqlist.amap.writeLabels == 1
    %write the text/label
     symbcount = symbcount + 1;
        fprintf(fid,'[Symbol %-g]\n',symbcount);
        fprintf(fid,'Typ=%g\n',2);
        fprintf(fid,'Group=%g\n',setting.eqlist.amap.group+2);
        fprintf(fid,'Col=%g\n',setting.eqlist.amap.coltxt);
        fprintf(fid,'Area=%g\n',1);
        fprintf(fid,'Zoom=%g\n',1);
        fprintf(fid,'Size=%g\n',setting.eqlist.amap.sizetxt);
        fprintf(fid,'Font=%g\n',1);  %1..arial?
        fprintf(fid,'Dir=%g\n',100);
        fprintf(fid,'XKoord=%-9.5f\n',curr_lon);
        fprintf(fid,'YKoord=%-8.5f\n',curr_lat);
        fprintf(fid,'Text=%-g\n',k);    %order should not be changed, as the list should be compared to.
    end
end

%write overlay section
fprintf(fid,'[Overlay]\n');
fprintf(fid,'Symbols=%-g\n',symbcount);

%write maplage section
fprintf(fid,'[MapLage]\n');
fprintf(fid,'MapName=%s\n',setting.title);
fprintf(fid,'DimmFc=%g\n',setting.eqlist.amap.DimmF);
fprintf(fid,'ZoomFc=%g\n',setting.eqlist.amap.ZoomFc);
fprintf(fid,'CenterLat=%-9.5f\n',mean(lat));
fprintf(fid,'CenterLong=%-8.5f\n',mean(lon));
fprintf(fid,'RefOn=%g\n',setting.eqlist.amap.RefOn);


fclose(fid);  fclose('all');


