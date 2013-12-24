function [dataV,dataA,setting,error] = getTracesfromAntelope(setting)
dataV = [];   dataA = [];  data = [];

%// get db querry strings
strstation = sprintf('%s',setting.station); 
fprintf('..start getting traces from Antelope DB for station %s  \n',strstation);

if numel(setting.comp) == 1
   strcomponents = sprintf('%s',setting.comp{1}); 
else
   strcomponents = '';
   for k=1:numel(setting.comp)
       if k==1
          strcomponents = sprintf('(chan==''%s''',setting.comp{1});  %beginn
       else
          strcomponents = sprintf('%s || chan==''%s''',strcomponents,setting.comp{k});  
       end
       if k==numel(setting.comp)
          strcomponents = sprintf('%s)',strcomponents);  %abschluss
       end
   end
end

% %// open the db and make a selection
% db = dbopen(setting.db.events,'r');
% dbextr = dblookup(db,'','origin','','');
% str_querry1 = sprintf('time >= %s && time <= %s',setting.time.start,setting.time.end);
% dbtimextr = dbsubset(dbextr,str_querry1);
% 
% %join with assoc and select station
% dbassoc = dblookup(dbtimextr,'','assoc','','');
% dbj1 = dbjoin(dbtimextr,dbassoc);
% str_querry2 = sprintf('sta==''%s''',strstation);
% dbstaextr = dbsubset(dbj1,str_querry2);
% 
% %join with arrival and select cha
% dbarrival = dblookup(dbtimextr,'','arrival','','');
% dbj2 = dbjoin(dbstaextr,dbarrival);
% str_querry3 = sprintf('chan==''%s''',strcomponents);
% dbchaextr = dbsubset(dbj2,str_querry3);

% %// open the db and make a selection
for z=1:numel(setting.comp)
  db = dbopen(setting.db.events,'r');
  dbextr = dblookup(db,'','wfdisc','','');
  curr_component = setting.comp{z};   %'HNZ';
  strcomponents = sprintf('chan==''%s''',curr_component);
  str_querry1 = sprintf('time <= %s && endtime >= %s && sta==''%s'' && %s',setting.time.start,setting.time.end,strstation,strcomponents);
  %str_querry1 = sprintf('time <= %s && endtime >= %s && sta==''%s''',setting.time.start,setting.time.end,strstation);
  dbtimextr = dbsubset(dbextr,str_querry1);
  n = dbnrecs(dbtimextr);
  if n > 0
      format long;
     [time,endtime,nsamp,samprate] = dbgetv(dbtimextr,'time','endtime','nsamp','samprate');
     setting.samplerate{z} = samprate;
        %[time,sta,chan] = dbgetv(dbtimextr,'time','sta','chan');
        %db = dblookup_table(dbtimextr,'wfdisc');
        %[trcdata] = trgetwf(dbtimextr,time,endtime);
     dbtimextr.record = 0; 
     tr = trload_css(dbtimextr,str2epoch(setting.time.start),str2epoch(setting.time.end));
     trapply_calib(tr);
     data{z} = trextract_data(tr);
     trdestroy(tr);
     fprintf('..%s  %s found with %4.0f samprate and %g nsamp \n',strstation,curr_component,samprate,nsamp);
     %subplot(3,1,z);
     %plot(data);
     %legend();
  else
     fprintf('..%s  %s not found. Need to change the channel? Time frame ',strstation,curr_component); 
  end
  dbclose(db);
  
  if n == 0
      % suggest suitable periods from database
      suggestAvailableTimeFrameWaveforms(setting,strstation,curr_component);
  end  
  
end


if setting.intitialunit == 'V'
    if isempty(data)
        error = 1;
    else
        for z=1:numel(setting.comp)
            dataV{z} = data{z};
        end
        error = 0;
    end
end
if setting.intitialunit == 'A'
    if isempty(data)
        error = 1;
    else
        for z=1:numel(setting.comp)
            dataA{z} = data{z};
        end
        error = 0;
    end
end


