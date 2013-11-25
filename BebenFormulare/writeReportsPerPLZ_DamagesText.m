function writeReportsPerPLZ_DamagesText(setting,infoSelectEvent,DamageTexts)
% // write the damage text to txt file
% vorbeben,nachbeben,schaden_dinge,wirkung_dinge,schaden_gebauede_txt,lddate,leichte_schaeden
%    1       2          3               4               5               6        7  
% maessige_schaeden,starke_schaeden,sehr_starke_schaeden,fid,plz,dist,loc
%        8                  9               10           11   12   13  14
setting.reportsPerPLZ.filenameout = sprintf('%s-%s',setting.textfile.prefix,setting.reportsDamageText.filenameout);
fprintf('...writing %g damage texts from reports to file %s \n',size(DamageTexts,1),setting.reportsPerPLZ.filenameout);
fileout = fullfile(pwd,setting.textfile.folder,setting.reportsPerPLZ.filenameout);
fid = fopen(fileout,'w');
fprintf(fid, 'lei/mae/st/sst  Dist PLZ   Ort                    Schadengebauede    \n');

for k=1:size(DamageTexts,1)    
    f13 = DamageTexts{k,13};
    f12 = str2double(cell2mat(DamageTexts{k,12}));
    if isempty(f12)
       f12 = 0; 
    end
    f14 = DamageTexts{k,14};
    f05 = DamageTexts{k,5};
    f11 = DamageTexts{k,11};
    f06 = DamageTexts{k,6};
    f04 = DamageTexts{k,4};
    f03 = DamageTexts{k,3};
    f01 = DamageTexts{k,1};
    f02 = DamageTexts{k,2};
    [s01,s02,s03,s04] = getAusmassSchaeden(DamageTexts,k);
    fprintf(fid,'%s %s %s %s  %6.0fkm %5.0f  %s: %s %s %s %s %s \n',s01,s02,s03,s04,f13,f12,f14{1},f05{1},f04{1},f03{1},f01{1},f02{1});
    fprintf(fid,'                                                                                                                   %s (fid=%g) \n',f06,f11);
    clear f01 f02 f03 f04 f05 f06 f07 f08 f09 f10 f11 f12 f13 f14; 
end              
fclose(fid);  fclose('all');







function   [s01,s02,s03,s04] = getAusmassSchaeden(DamageTexts,ind)
s01='-';s02='-';s03='-';s04='-';
stryes = 'x';

leicht = DamageTexts{ind,7};
maessig = DamageTexts{ind,8};
stark = DamageTexts{ind,9};
sehrstark = DamageTexts{ind,10};

if strcmp(leicht,'y');
   s01=stryes; 
end
if strcmp(maessig,'y');
   s02=stryes; 
end
if strcmp(stark,'y');
   s03=stryes; 
end
if strcmp(sehrstark,'y');
   s04=stryes; 
end





