function   [Reports,setting] = getEqAdditionalReportTexts(ReportsIn,setting,indexnum)

%[Reports,setting] = getDataFromForSchleife(ReportsIn,setting,indexnum);
[Reports,setting] = getDataFromGanzerAbfrage(ReportsIn,setting,indexnum);




function [Reports,setting] = getDataFromGanzerAbfrage(ReportsIn,setting,indexnum)
%additional texts from 'webform'

Reports =  ReportsIn;
fidlist = Reports(indexnum).fid;
infoEvent = setting.infoSelectEvent;

minfid = min(fidlist); %timestart = infoEvent{9} - infoEvent{8}*60*60;
maxfid = max(fidlist); %timeend =  infoEvent{9} + infoEvent{8}*60*60;

% // open db and get the data between min and maxFID
db = dbopen(setting.db.formular,'r');
dbextr = dblookup(db,'',setting.db.formulartable2,'','');
str_querry1 = sprintf('fid >= %g && fid <= %g && verspuert!=''n''',minfid,maxfid);
dbformextr = dbsubset(dbextr,str_querry1);
n = dbnrecs(dbformextr);
    

if n>0
   fprintf('..saving %g additional report infos from %s. \n',n,setting.db.formulartable2);
   if setting.save.individualforms==1
      [art_erschuetterung,stockwerk,beben_geraeusche,fid] = dbgetv(dbformextr,'art_der_erschuetterung','stockwerk','beben_geraeusche','fid');   
   end
end
dbclose(db); 

% // sort FID according to fidlist and assign the records.
for k=1:numel(fidlist)
    currfid = fidlist(k);
    found = 0;  foundfid = 0;
    for m=1:numel(fid)
        if currfid==fid(m)
          foundfid = m; 
          found = 1;
          break;
        end
    end
    if found==1
       %querry all basic parameters or strings
      art_erschuetterung_all{k} = cell2mat(art_erschuetterung(foundfid)); %r..ruck s..schwanken z..zittern
      stockwerk_all{k} = cell2mat(stockwerk(foundfid));
      beben_geraeusche_all{k} = cell2mat(beben_geraeusche(foundfid));       %k..knall g..grollen a..anders  
      matrix_erschuetterung = geterschuetterungMatrix(cell2mat(art_erschuetterung(foundfid)));
      matrix_geraeusche = getgeraeuscheMatrix(cell2mat(beben_geraeusche(foundfid)));
      matrix_stockwerk = getstockwerkMatrix(cell2mat(stockwerk(foundfid)));
      %[stockwerk0-3,stk3-6,stk6-10,stk11-20,stk20+,knall,grollen,ruck,schwanken,zittern]
      matrix_all(k,:) = [matrix_stockwerk matrix_geraeusche matrix_erschuetterung];       
    else 
      art_erschuetterung_all{k} = '?';   %r..ruck s..schwanken z..zittern
      stockwerk_all{k} = '?'; 
      beben_geraeusche_all{k} = '?'; 
      %[stockwerk0-3,stk3-6,stk6-10,stk11-20,stk20+,knall,grollen,ruck,schwanken,zittern]
      matrix_all(k,:) = [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];       
    end
end
Reports(indexnum).erschuetterung.art = art_erschuetterung_all;   %r..ruck s..schwanken z..zittern
Reports(indexnum).geraeusche.art = beben_geraeusche_all;       %k..knall g..grollen a..anders  
Reports(indexnum).stockwerk = stockwerk_all;
%[stockwerk0-3,stk3-6,stk6-10,stk11-20,stk20+,knall,grollen,ruck,schwanken,zittern]
Reports(indexnum).matrix_add = matrix_all; 




function [Reports,setting] = getDataFromForSchleife(ReportsIn,setting,indexnum)
%additional texts from 'webform'

Reports =  ReportsIn;
fidlist = Reports(indexnum).fid;

for k=1:numel(fidlist)
 fidval = fidlist(k);   
%open db and first subset
 db = dbopen(setting.db.formular,'r');
 dbextr = dblookup(db,'',setting.db.formulartable2,'','');
 str_querry1 = sprintf('fid == %g',fidval);
 dbformextr = dbsubset(dbextr,str_querry1);
 n = dbnrecs(dbformextr);
 if n>0
    if setting.save.individualforms==1
      %querry all basic parameters or strings
     [art_erschuetterung,stockwerk,beben_geraeusche] = dbgetv(dbformextr,'art_der_erschuetterung','stockwerk','beben_geraeusche');
      art_erschuetterung_all{k} = art_erschuetterung; %r..ruck s..schwanken z..zittern
      stockwerk_all{k} = stockwerk;
      beben_geraeusche_all{k} = beben_geraeusche;       %k..knall g..grollen a..anders  
      matrix_erschuetterung = geterschuetterungMatrix(art_erschuetterung);
      matrix_geraeusche = getgeraeuscheMatrix(beben_geraeusche);
      matrix_stockwerk = getstockwerkMatrix(stockwerk);
      %[stockwerk0-3,stk3-6,stk6-10,stk11-20,stk20+,knall,grollen,ruck,schwanken,zittern]
      matrix_all(k,:) = [matrix_stockwerk matrix_geraeusche matrix_erschuetterung];    
    else
      art_erschuetterung_all{k} = '?';   %r..ruck s..schwanken z..zittern
      stockwerk_all{k} = '?'; 
      beben_geraeusche_all{k} = '?'; 
      %[stockwerk0-3,stk3-6,stk6-10,stk11-20,stk20+,knall,grollen,ruck,schwanken,zittern]
      matrix_all(k,:) = [NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];
    end
    
    
 end
 dbclose(db);
end

Reports(indexnum).erschuetterung.art = art_erschuetterung_all;   %r..ruck s..schwanken z..zittern
Reports(indexnum).geraeusche.art = beben_geraeusche_all;       %k..knall g..grollen a..anders  
Reports(indexnum).stockwerk = stockwerk_all;
%[stockwerk0-3,stk3-6,stk6-10,stk11-20,stk20+,knall,grollen,ruck,schwanken,zittern]
Reports(indexnum).matrix_add = matrix_all; 







 
function  value = getstockwerkMatrix(stockwerk)
%stockwerk 
%    0-3
%    3-6
%    6-10
%   11-20
%      20+
value = [0 0 0 0 0];
val1 = 0; val2 = 0; val3 = 0; val4 = 0; val5 = 0;

if isnumeric(str2num(stockwerk))
   valuestock = str2num(stockwerk);  
   if valuestock < 3
       val1 = 1;
   end
   if valuestock < 6 & valuestock >=3
       val2 = 1;
   end
   if valuestock < 11 & valuestock >=6
       val3 = 1;
   end   
   if valuestock < 20 & valuestock >=11
       val4 = 1;
   end 
   if valuestock >= 20
       val5 = 1;
   end    
value = [val1 val2 val3 val4 val5];
end




function value = getgeraeuscheMatrix(beben_geraeusche)
val_k = 0;
val_g = 0;
value = [0 0];

if beben_geraeusche=='k'
   val_k = 1;
else
   val_k = 0; 
end
if beben_geraeusche=='g'
   val_g = 1;
else
   val_g = 0; 
end
if beben_geraeusche=='?' | beben_geraeusche==' ' | beben_geraeusche=='-'
   val_g = 0; 
   val_k = 0; 
end
value = [val_k val_g];



function value = geterschuetterungMatrix(art_erschuetterung)

val_r = 0;
val_s = 0;
val_z = 0;

value = [0 0 0];

if art_erschuetterung=='r'
   val_r = 1;
else
   val_r = 0; 
end
if art_erschuetterung=='s'
   val_s = 1;
else
   val_s = 0; 
end
if art_erschuetterung=='z'
   val_z = 1;
else
   val_z = 0; 
end
if art_erschuetterung=='?' | art_erschuetterung==' ' | art_erschuetterung=='-'
   val_r = 0; 
   val_s = 0; 
   val_z = 0;
end
value = [val_r val_s val_z];



