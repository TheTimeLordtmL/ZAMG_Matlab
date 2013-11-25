function exportSingleData2ASCII(dataV,dataA,setting)

filenameout = sprintf('evid%.0f_%s.asc',setting.evid,setting.station);
fprintf('...writing %g lines of %s-data (vel/acc) to file %s \n',numel(dataV{1}),setting.intitialunit,filenameout);
fileout = fullfile(pwd,filenameout);
if setting.exportASCII.filter==1
    switch setting.filter.type
        case 'LP'       %low pass
            strFilter = sprintf('On   (%g poles, low pass at %5.2fHZ)',setting.filter.numpolesdisplace,setting.filter.lowpassoffdisplace);
        case 'HP'       %high pass
            strFilter = sprintf('On   (%g poles, low cut at %5.2fHZ)',setting.filter.numpolesdisplace,setting.filter.lowcutoffdisplace);
        case 'BP'       %band pass
            %emtyp
    end
else
    strFilter = 'Off';
end

[lat,long,elev] = getLatLongForStationfromDB(setting,setting.station);
[latev,longev,depthev] = getLatLongForEventfromDB(setting,setting.evid);

fid = fopen(fileout,'w');

fprintf(fid, 'Event: %s     evid: %.0f    Location: Lat=%6.4f   Long=%7.4f  Depth=%3.0f km \n',setting.nameevent,setting.evid,latev,longev,depthev);
fprintf(fid, 'Station: %s     Channels: %s, %s, %s   Installation: Lat=%6.4f   Long=%7.4f  Elev=%4.0f m\n',setting.station,setting.comp{1},setting.comp{2},setting.comp{3},lat,long,elev*1000);
fprintf(fid, 'Sample-rate (Hz): %g, %g, %g    Filter: %s\n',setting.samplerate{1},setting.samplerate{2},setting.samplerate{3},strFilter);
fprintf(fid, ' Time_Begin: %s     \n',setting.time.start);
fprintf(fid, ' Time_End:   %s     \n',setting.time.end);
fprintf(fid, ' DB %s accessed on %s     \n',setting.db.events,datestr(now(),'dd-mmm-yyyy HH:MM:SS'));
fprintf(fid, ' Network: Österreichischer Erdbebendienst, ZAMG, Hohe Warte 38, 1190 Wien   \n');

fprintf(fid, '             #       sps_since_t0       %s(%s)          %s(%s)         %s(%s)    \n',setting.comp{1},setting.unit.value,setting.comp{2},setting.unit.value,setting.comp{3},setting.unit.value);

%assign V or A Values to curr-variables
if setting.intitialunit=='V'
    curr1 = dataV{1};    curr2 = dataV{2};    curr3 = dataV{3};
end
if setting.intitialunit=='A'
    curr1 = dataA{1};    curr2 = dataA{2};    curr3 = dataA{3};
end

%apply filter if necessary
if setting.exportASCII.filter==1
    switch setting.filter.type
        case 'LP'       %low pass
            curr1 = filterLowPass(curr1,setting.samplerate{1},setting);
            curr2 = filterLowPass(curr2,setting.samplerate{2},setting);
            curr3 = filterLowPass(curr3,setting.samplerate{3},setting);
        case 'HP'       %high pass
            curr1 = filterLowCutOff(curr1,setting.samplerate{1},setting);
            curr2 = filterLowCutOff(curr2,setting.samplerate{2},setting);
            curr3 = filterLowCutOff(curr3,setting.samplerate{3},setting);
        case 'BP'       %band pass
            %emtyp
    end
end

% prepare sps sample list with absolute reference to EQ t0 time.
spsList = setting.absDataBValues.from:setting.absDataBValues.to-1;
if numel(spsList)~=numel(curr1)
    fprintf('warning: sps liste ungleich lang wie daten (spsList=%g, curr1=%g) \n',numel(spsList),numel(curr1));
    spsList = 1:numel(curr1);
end


%write the data
for k=1:numel(curr1)
    fprintf(fid,'%14g  %14g   %16.8f  %16.8f  %16.8f    \n',k,spsList(k),curr1(k),curr2(k),curr3(k));
end



fclose(fid);  fclose('all');

fprintf('file written sucessfully with FILTER=%g and samples from %g to %g   \n',setting.exportASCII.filter,setting.absDataBValues.from,setting.absDataBValues.to);
