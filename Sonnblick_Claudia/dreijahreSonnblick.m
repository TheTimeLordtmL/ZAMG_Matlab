% Darstellung der Temperatur eines Bohrlochs pro Tiefe und Tag
%plottet Temperatur-Jahresgänge über ein hydrologisches Jahr!
% Laden der Daten
clear all;
%format long g
setting.absPath = '/home/hausmann/Matlab/Sonnblick_Claudia';
setting.file ='BL1_Tageswerte_20101001-20110910.txt';
setting.filepath = fullfile(setting.absPath,setting.file);

fid = fopen(setting.filepath,'r');   
%A_data = textscan(fid, '%s %f %f', 'CollectOutput', 0);
%Datum = T_Tag_Tiefe_neu(:,1);
%
p = 0;
while(~feof(fid))
    tline = fgetl(fid);
    if(isempty(tline))
        continue;
    end
    tmp1 = textscan(tline, '%s %s %f %f');
    curdate = tmp1{1};    curdate = curdate{1};
    curtime = tmp1{2};    curtime = curtime{1};
    curdepth = tmp1{3};
    curtemp = tmp1{4};
    %fprintf('%s %f %f\n',curdate,curdepth,curtemp);
    p = p + 1;
    TT(p) = curtemp;
    Tiefe(p) = curdepth;
    datum(p) = datenum(curdate,'dd.mm.yy'); 
end
fclose(fid);

% for i = 1:length(A_data{1,3})
%     TT(i) = A_data{1,3}(i);
%     Tiefe(i) = A_data{1,2}(i);
%     datum(i) = A_data{1,1}(i);
% end
%datum(1)=datum(2);

% if f==1
% 	TT=tt;
% 	Tiefe=tiefe;
% 	datum=Datum;
% else TT=[TT,tt];
% 	Tiefe=[Tiefe,tiefe];
% 	datum=[datum,Datum];
% end
% end %Ende f-schleife!



Tiefe=flipud(Tiefe);
TT=flipud(TT);
Tiefe1 = reshape(Tiefe, 25, length(Tiefe)/25);
Tiefe1 = Tiefe1(1:2:25,:);
Tiefe2 = flipud(Tiefe1.*(-1));
Datum1 = reshape(datum, 25, length(Tiefe)/25);
%Datum1 = reshape(datenum(datum), 25, length(Tiefe)/25);
Datum1 = Datum1(1:2:25,:);
TTneu = reshape(TT, 25, length(Tiefe)/25);
TTneu = flipud(TTneu(1:2:25,:));
% Abbildung erzeugen
figure
%hold on; 
%box on;
%contourf(Datum1(:,367:end), Tiefe1(:,367:end), TTneu(:,367:end), 24);
contourf(Datum1, Tiefe2, TTneu, 24);

set(gca,'ydir','reverse');

h = colorbar;
title(h, '�C');
set(gca,'YTick',[0:2:20],'YMinorTick', 'off');
set(gca, 'XTick',[734412 734443 734473 734504 734535 734563 734594 734624 734655 734685 734716 734747],'XMinorTick', 'on', 'TickDir', 'out');
%1.oct-1.sep

%set(gca,'YTickLabel',{'-20';'-18';'-16';'Four';'-16';'-16';'-16';'-16';'-16';'-16'})
%set(gca, 'xtick',[datum(1):30:datum(numel(datum))],'XMinorTick', 'on', 'TickDir', 'out')
datetick('x','mmmyy','keepticks');
set(gca,'XMinorTick', 'on','TickDir', 'in');

%ylabel('Depth [m]')
ylabel('Tiefe [m]');
%title('Borehole temperatures at Sonnblick 2008 to 2010')


