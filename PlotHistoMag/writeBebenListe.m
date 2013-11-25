function writeBebenListe(setting,datastructhist)
% // Write reports grouped by PLZ to a text file
% output of [HistName,HistPLzDist]:
% out= plz | numberstack | distance | azimuth | lat | lon

magval = setting.eqlist.minmag;

setting.reportsPerPLZ.filenameout = sprintf('%s-%s','beben','liste.txt');
fprintf('...writing earthquake list to file %s \n',setting.reportsPerPLZ.filenameout);
fileout = fullfile(pwd,setting.textfile.folder,setting.reportsPerPLZ.filenameout);
fid = fopen(fileout,'w');
%                               170768        5/19/2006  14:00:22.899  St. Veit an der                                  3.5   46.8085  14.3702
switch setting.eqlist.format
    case 1
        fprintf(fid, '          orid          Date       Time       Location                                            Ml    lat      lon  \n');
    case 2
        fprintf(fid, '          orid          Date       Time       Location                                            Ml    lat      lon     depth etype\n');        
    case 3
        fprintf(fid, '          orid          Date       Time       Location                                            I0    lat      lon     depth etype\n');   
    case 4
        fprintf(fid, '          orid          Date       Time          I0    lat      lon     depth etype\n');   
end

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
    if curr_mag >= magval
        switch setting.eqlist.format
            case 1
                fprintf(fid,'%16.0f %+30s  %-45s  %5.1f  %8.4f %8.4f\n',curr_orid,curr_datestr{1},curr_evname{1},curr_mag,curr_lat,curr_lon);
            case 2
                fprintf(fid,'%16.0f %+30s  %-45s  %5.1f  %8.4f %8.4f %6.1f %+2s\n',curr_orid,curr_datestr{1},curr_evname{1},curr_mag,curr_lat,curr_lon,curr_depth,curr_etype{1});
            case 3
                fprintf(fid,'%16.0f %+30s  %-45s  %5.1f  %8.4f %8.4f %6.1f %+2s\n',curr_orid,curr_datestr{1},curr_evname{1},curr_inull,curr_lat,curr_lon,curr_depth,curr_etype{1});
            case 4
                fprintf(fid,'%16.0f %+30s  %5.1f  %8.4f %8.4f %6.1f %+2s\n',curr_orid,curr_datestr{1},curr_inull,curr_lat,curr_lon,curr_depth,curr_etype{1});
            case 5
                fprintf(fid,'not defined yet \n');
        end
    end
end
fclose(fid);  fclose('all');
