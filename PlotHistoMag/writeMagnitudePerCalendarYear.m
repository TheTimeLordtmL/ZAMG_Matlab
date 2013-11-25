function writeMagnitudePerCalendarYear(structhist,structseisgraph,structlast20year,setting)
% write historical data, period1900-2000, last20years to file
% at the end the script plots a list of M>5 events
% 

maglimit = setting.magPerCalendarYear.maglimitFileMax;
strfile1 = 'Magnitude per Calendar Year for Historic Data 1000-1900';   
strfile2 = 'Magnitude per Calendar Year for Instrumental Period 1900-2000';
strfile3 = 'Magnitude per Calendar Year for the last 20 Years';
strfile4 = sprintf('Significant Earthquakes with magnitude greater than %g.',maglimit);

setting.reportsPerPLZ.filenameout = sprintf('%s-%s',setting.magPerCalendarYear.strregion,setting.magPerCalendarYear.file);
fprintf('...writing maximum Magnitude per Calendar Year to %s \n',setting.reportsPerPLZ.filenameout);
fileout = fullfile(pwd,setting.textfile.folder,setting.reportsPerPLZ.filenameout);
fid = fopen(fileout,'w');
fprintf(fid,'%s \n',setting.title);
fprintf(fid,'   \n');


% // write Historical Data
if setting.magPerCalendarYear.plothierachy >= 1
    fprintf(fid,'%s   \n',strfile1);
    fprintf(fid, '    Date       Time       Mag  etype Location                    lat         long    depth    orid\n');
    for k=1:numel(structhist)
        date = structhist(k).datestr;
        mag = structhist(k).netmag;
        etype = structhist(k).etype;
        orid = structhist(k).orid;
        b = structhist(k).origin.lat;
        d = structhist(k).origin.depth;
        l = structhist(k).origin.lon;
        evname = structhist(k).evname;
        magstring = getmagstring(mag);
        fprintf(fid,'%25s M%3.1f (%2s) %-25s  %8.4f    %8.4f   %3.0fkm    %12g   %-20s\n',date{1},mag,etype{1},evname{1},b,l,d,orid,magstring);
    end
    clear date mag etype orid b d l;
    fprintf(fid, '    \n');
end

% // write 1900-2000 Data
if setting.magPerCalendarYear.plothierachy >= 2
    fprintf(fid,'%s   \n',strfile2);
    fprintf(fid, '    Date       Time       Mag  etype Location                    lat         long    depth    orid\n');
    for k=1:numel(structseisgraph)
        date = structseisgraph(k).datestr;
        mag = structseisgraph(k).netmag;
        etype = structseisgraph(k).etype;
        orid = structseisgraph(k).orid;
        b = structseisgraph(k).origin.lat;
        d = structseisgraph(k).origin.depth;
        l = structseisgraph(k).origin.lon;
        evname = structseisgraph(k).evname;
        magstring = getmagstring(mag);
        fprintf(fid,'%25s M%3.1f (%2s) %-25s  %8.4f    %8.4f   %3.0fkm    %12g   %-20s\n',date{1},mag,etype{1},evname{1},b,l,d,orid,magstring);
    end
    clear date mag etype orid b d l;
    fprintf(fid, '    \n');
end

% // write last 20 years
if setting.magPerCalendarYear.plothierachy >= 3
    fprintf(fid,'%s   \n',strfile3);
    fprintf(fid, '    Date       Time       Mag  etype Location                    lat         long    depth    orid\n');
    for k=1:numel(structlast20year)
        date = structlast20year(k).datestr;
        mag = structlast20year(k).netmag;
        etype = structlast20year(k).etype;
        orid = structlast20year(k).orid;
        b = structlast20year(k).origin.lat;
        d = structlast20year(k).origin.depth;
        l = structlast20year(k).origin.lon;
        evname = structlast20year(k).evname;
        magstring = getmagstring(mag);
        fprintf(fid,'%25s M%3.1f (%2s) %-25s  %8.4f    %8.4f   %3.0fkm    %12g   %-20s\n',date{1},mag,etype{1},evname{1},b,l,d,orid,magstring);
    end
end


clear date mag etype orid b d l;
fprintf(fid, '    \n'); fprintf(fid, '    \n');
fprintf(fid, '    \n'); fprintf(fid, '    \n');


% // plot all events m>5 (or maglimit)
if setting.magPerCalendarYear.plothierachy >= 1
    fprintf(fid,'%s   \n',strfile4);
    fprintf(fid, '    Date       Time       Mag  etype Location                    lat         long    depth    orid\n');
    for k=1:numel(structhist)
        mag = structhist(k).netmag;
        if mag >= maglimit
            date = structhist(k).datestr;
            etype = structhist(k).etype;
            orid = structhist(k).orid;
            b = structhist(k).origin.lat;
            d = structhist(k).origin.depth;
            l = structhist(k).origin.lon;
            evname = structhist(k).evname;
            fprintf(fid,'%25s M%3.1f (%2s) %-25s  %8.4f    %8.4f   %3.0fkm    %12g   \n',date{1},mag,etype{1},evname{1},b,l,d,orid);
        end
    end
    clear date mag etype orid b d l;
end

if setting.magPerCalendarYear.plothierachy >= 2
    for k=1:numel(structseisgraph)
        mag = structseisgraph(k).netmag;
        if mag >= maglimit
            date = structseisgraph(k).datestr;
            etype = structseisgraph(k).etype;
            orid = structseisgraph(k).orid;
            b = structseisgraph(k).origin.lat;
            d = structseisgraph(k).origin.depth;
            l = structseisgraph(k).origin.lon;
            evname = structseisgraph(k).evname;
            fprintf(fid,'%25s M%3.1f (%2s) %-25s  %8.4f    %8.4f   %3.0fkm    %12g   \n',date{1},mag,etype{1},evname{1},b,l,d,orid);
        end
    end
    clear date mag etype orid b d l;
end

if setting.magPerCalendarYear.plothierachy >= 3
    for k=1:numel(structlast20year)
        mag = structlast20year(k).netmag;
        if mag >= maglimit
            date = structlast20year(k).datestr;
            etype = structlast20year(k).etype;
            orid = structlast20year(k).orid;
            b = structlast20year(k).origin.lat;
            d = structlast20year(k).origin.depth;
            l = structlast20year(k).origin.lon;
            evname = structlast20year(k).evname;
            fprintf(fid,'%25s M%3.1f (%2s) %-25s  %8.4f    %8.4f   %3.0fkm    %12g   \n',date{1},mag,etype{1},evname{1},b,l,d,orid);
        end
    end
end

fclose(fid);  fclose('all');





function magstring = getmagstring(mag)
magstring = ' ';
valiter = round(log(mag)*10);

for p=1:valiter
%     if mod(p,3)==0
%         magstring = sprintf('%s-',magstring);
%     else
%         if mod(p,5)==0
%            magstring = sprintf('%s=',magstring); 
%         else
            magstring = sprintf('%s|',magstring);
%         end
%     end
end









