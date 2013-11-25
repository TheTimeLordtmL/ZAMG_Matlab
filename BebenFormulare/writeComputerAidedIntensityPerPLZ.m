function writeComputerAidedIntensityPerPLZ(setting,HistPLzDist,HistName,infoSelectEvent,StackrepMatrix)
% // Write writeComputerAidedIntensityPerPLZ
% generates per PLZ EMS98-intensities for Human and Object matrix
% accoring to Lenhardt et al.. 2002

str_blank =  ' ';    str_confi = '*';    str_once = '|';

[EMSKonstantVals] = getEMS98KonstantValuesEstimateIntensity();

for w=1:size(HistPLzDist,1)
    if mod(w,50)==0
        fprintf('.\n');
    else
        fprintf('.');
    end
    setting.reportsPerPLZ.filenameout = sprintf('%s-%04.0f-Plz%04g.txt',setting.textfile.prefix,HistPLzDist(w,3),HistPLzDist(w,1));
    fileout = fullfile(pwd,setting.textfile.folder,setting.reportsPerPLZ.filenameout);
    fid = fopen(fileout,'w');
    fprintf(fid, '%s ',infoSelectEvent{1});
    fprintf(fid, '%s ',infoSelectEvent{2});
    fprintf(fid, '%s ',infoSelectEvent{3});
    fprintf(fid, '%s ',infoSelectEvent{4});
    fprintf(fid, 'Database: %s \n',setting.db.events);
    fprintf(fid, ' Database accessed on  %s \n',datestr(now,'dd-mmm-yyyy HH:MM:SS'));
    fprintf(fid, ' \n');
    LocationName = HistName(w);
    fprintf(fid, ' Location: %g %s (%4.0fkm)          Total Reports: %g         Damages: %g (slight=x,middle=x,strong=x)\n',HistPLzDist(w,1),LocationName{1},HistPLzDist(w,3),HistPLzDist(w,2),StackrepMatrix(w,20));
    fprintf(fid, ' \n');   fprintf(fid, '                     Human Perception Matrix                     Object Matrix\n');
    fprintf(fid, '   EMS-98   Very few    Few      Many     Most     dev           Few    Many/Most       dev\n');
    curr_stackMatrix = StackrepMatrix(w,:);
    curr_counts = HistPLzDist(w,2);
    [human,object,humobjDev] = getEMS98ClassPercentage(curr_stackMatrix,curr_counts,str_blank,str_confi,str_once);
    humobjDev = computeDeviations(humobjDev,EMSKonstantVals);
    [cellhuman,cellobject] = getcellhumanobject(str_blank);
    [cellhuman,cellobject] = addMaximalValuetoCells(cellhuman,cellobject,humobjDev);
    
    if setting.ComputerAidedIntensity.showemptyvals == 1
        hu2vf = getEmptyValsTwoString(human.vf2R,'R',human.vf2T,'T',str_confi);
        hu3f = getEmptyValsTwoString(human.f3S,'S',human.f3T ,'T',str_confi);  
        
        hu3ma = getEmptyValsOneString(human.ma3R,'R',str_confi);
        ob3ma = getEmptyValsOneString(object.mamo3H,'H',str_confi);
        
        hu4vf = getEmptyValsOneString(human.vf4W,'W',str_confi);
        hu4f = getEmptyValsOneString(human.f4U,'U',str_confi);
        hu4s = getEmptyValsOneString(human.ma4S,'S',str_confi);
        ob4f = getEmptyValsOneString(object.f4J,'J',str_confi);
        ob4ma = getEmptyValsOneString(object.mamo4I,'I',str_confi);
        
        hu5f = getEmptyValsTwoString(human.f5W,'W',human.f5X,'X',str_confi);
        hu5ma = getEmptyValsOneString(human.ma5U,'U',str_confi);
        hu5mo = getEmptyValsTwoString(human.mo5S,'S',human.mo5V,'V',str_confi);
        ob5f = getEmptyValsOneString(object.f5L,'L',str_confi);
        ob5ma = getEmptyValsOneString(object.mamo5K,'K',str_confi);
        
        hu6f = getEmptyValsOneString(human.f6Y,'Y',str_confi);
        hu6ma = getEmptyValsTwoString(human.ma6W,'W',human.ma6X,'X',str_confi);
        hu6mo = getEmptyValsOneString(human.mo6S,'S',str_confi);
        ob6f = getEmptyValsOneString(object.f6N,'N',str_confi);
        ob6ma = getEmptyValsOneString(object.mamo6M,'M',str_confi);
        
        hu7ma = getEmptyValsTwoString(human.ma7Y,'Y',human.ma7Z,'Z',str_confi);
        hu7mo = getEmptyValsTwoString(human.mo7W,'W',human.mo7X,'X',str_confi);
        on7ma = getEmptyValsOneString(object.mamo7O,'O',str_confi);
        
        hu8ma = getEmptyValsOneString(human.ma8Z,'Z',str_confi);
        on8ma = getEmptyValsOneString(object.mamo8P,'P',str_confi);
        hu9mo = getEmptyValsOneString(human.mo9Z,'Z',str_confi);        
    else
        hu2vf = sprintf('%s%s,%s%s',human.vf2R,'R',human.vf2T,'T');
        hu3f = sprintf('%s%s,%s%s',human.f3S,'S',human.f3T ,'T');
        
        hu3ma = sprintf('%s%s',human.ma3R,'R');
        ob3ma = sprintf('%s%s',object.mamo3H,'H');
        
        hu4vf = sprintf('%s%s',human.vf4W,'W');
        hu4f = sprintf('%s%s',human.f4U,'U');
        hu4s = sprintf('%s%s',human.ma4S,'S');
        ob4f = sprintf('%s%s',object.f4J,'J');
        ob4ma = sprintf('%s%s',object.mamo4I,'I');
        
        hu5f = sprintf('%s%s,%s%s',human.f5W,'W',human.f5X,'X');
        hu5ma = sprintf('%s%s',human.ma5U,'U');
        hu5mo = sprintf('%s%s,%s%s',human.mo5S ,'S',human.mo5V,'V');
        ob5f = sprintf('%s%s',object.f5L,'L');
        ob5ma = sprintf('%s%s',object.mamo5K,'K');
        
        hu6f = sprintf('%s%s',human.f6Y,'Y');
        hu6ma = sprintf('%s%s,%s%s',human.ma6W,'W',human.ma6X,'X');
        hu6mo = sprintf('%s%s',human.mo6S,'S');
        ob6f = sprintf('%s%s',object.f6N,'N');
        ob6ma = sprintf('%s%s',object.mamo6M,'M');
        
        hu7ma = sprintf('%s%s,%s%s',human.ma7Y,'Y',human.ma7Z,'Z');
        hu7mo = sprintf('%s%s,%s%s',human.mo7W,'W',human.mo7X,'X');
        on7ma = sprintf('%s%s',object.mamo7O,'O');
        
        hu8ma = sprintf('%s%s',human.ma8Z,'Z');
        on8ma = sprintf('%s%s',object.mamo8P ,'P');
        hu9mo = sprintf('%s%s',human.mo9Z,'Z');
    end
    
    
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',1,'-','-','-','-',humobjDev(1,5),cellhuman{1},'-','-',humobjDev(1,8),cellobject{1});
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',2,hu2vf,'-','-','-',humobjDev(2,5),cellhuman{2},'-','-',humobjDev(2,8),cellobject{2});
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',3,'-',hu3f,hu3ma,'-',humobjDev(3,5),cellhuman{3},'-',ob3ma,humobjDev(3,8),cellobject{3});
    
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',4,hu4vf,hu4f,hu4s,'-',humobjDev(4,5),cellhuman{4},ob4f,ob4ma,humobjDev(4,8),cellobject{4});
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',5,'-',hu5f,hu5ma,hu5mo,humobjDev(5,5),cellhuman{5},ob5f,ob5ma,humobjDev(5,8),cellobject{5});
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',6,'-',hu6f,hu6ma,hu6mo,humobjDev(6,5),cellhuman{6} ,ob6f,ob6ma,humobjDev(6,8),cellobject{6});
    
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',7,'-','-',hu7ma,hu7mo,humobjDev(7,5),cellhuman{7},'-',on7ma,humobjDev(7,8),cellobject{7});
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',8,'-','-',hu8ma,'-',humobjDev(8,5),cellhuman{8},'-',on8ma,humobjDev(8,8),cellobject{8});
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',9,'-','-','-',hu9mo,humobjDev(9,5),cellhuman{9},'-','-',humobjDev(9,8),cellobject{9});
    
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',10,'-','-','-','-',humobjDev(10,5),cellhuman{10},'-','-',humobjDev(10,8),cellobject{10});
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',11,'-','-','-','-',humobjDev(11,5),cellhuman{11},'-','-',humobjDev(11,8),cellobject{11});
    fprintf(fid, '   %3g    %6s    %6s    %6s    %6s   %+4.2f%s             %6s    %6s   %+4.2f%s  \n',12,'-','-','-','-',humobjDev(12,5),cellhuman{12},'-','-',humobjDev(12,8),cellobject{12});
    fprintf(fid, ' \n');
    fprintf(fid, '*..this parameter has been observed.\n');
    fprintf(fid, '|..parameter has been observed only x-times.\n');
    fprintf(fid, ' \n');
    fclose(fid);  fclose('all');
    clear  curr_stackMatrix curr_counts;
end

fprintf('.\n');
fprintf('...writing Human and Object Matrix grouped by PLZ to %g file like %s \n',w,setting.reportsPerPLZ.filenameout);






function [human,object,humobjDev] = getEMS98ClassPercentage(curr_stackMatrix,curr_counts,str_blank,str_confi,str_once)
%Mx21 O.repMatrix..{'H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','dam','dg'};
%                     1   2  3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19   20   21
%Mx10 O.matrixadd..[stockwerk0-3,stk3-6,stk6-10,stk11-20,stk20+,knall,grollen,ruck,schwanken,zittern]
%                      22          23      24     25     26     27     28       29     30      31

%very few (< 1%)            % few (< 20%)
human.vf2R = str_blank;     object.f4J = str_blank;
human.vf2T = str_blank;     object.f5L = str_blank;
human.vf4W = str_blank;     object.f6N = str_blank;
%few (1% - 20%)            % many/most (> 20%)
human.f3S = str_blank;     object.mamo3H = str_blank;
human.f3T = str_blank;     object.mamo4I= str_blank;
human.f4U = str_blank;     object.mamo5K = str_blank;
human.f5W = str_blank;     object.mamo6M = str_blank;
human.f5X = str_blank;     object.mamo7O = str_blank;
human.f6Y = str_blank;     object.mamo8P = str_blank;
%many (20% - 60%)
human.ma3R = str_blank;
human.ma4S = str_blank;
human.ma5U = str_blank;
human.ma6W = str_blank;
human.ma6X = str_blank;
human.ma7Y = str_blank;
human.ma7Z = str_blank;
human.ma8Z = str_blank;
%most (> 60%)
human.mo5S = str_blank;
human.mo5V = str_blank;
human.mo6S = str_blank;
human.mo7W = str_blank;
human.mo7X = str_blank;
human.mo9Z = str_blank;

humobjDev = zeros(12,15);

%very few human (< 1%) 
currpercent = 100/curr_counts*curr_stackMatrix(11);
if currpercent <= 1
   str_curr = markOnceTwiceReports(curr_stackMatrix(11),str_confi,str_once);
   human.vf2R = str_curr; 
end
currpercent = 100/curr_counts*curr_stackMatrix(13);
if currpercent <= 1
   str_curr = markOnceTwiceReports(curr_stackMatrix(13),str_confi,str_once); 
   human.vf2T = str_curr;  
end          
humobjDev(2,1) = getpercentagefromTwoClasses(human.vf2R,human.vf2T,curr_stackMatrix(11),curr_stackMatrix(13),curr_counts,str_confi);

currpercent = 100/curr_counts*curr_stackMatrix(16);
if currpercent <= 1
   str_curr = markOnceTwiceReports(curr_stackMatrix(16),str_confi,str_once);  
   human.vf4W = str_curr;  
   humobjDev(4,1) = 100/curr_counts*curr_stackMatrix(16);
end  

% few obj (< 20%)
currpercent = 100/curr_counts*curr_stackMatrix(3);
if currpercent <= 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(3),str_confi,str_once);
    object.f4J = str_curr;
    humobjDev(4,6) = 100/curr_counts*curr_stackMatrix(3);
end
currpercent = 100/curr_counts*curr_stackMatrix(5);
if currpercent <= 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(5),str_confi,str_once);
    object.f5L   = str_curr;
    humobjDev(5,6) = 100/curr_counts*curr_stackMatrix(5);
end
currpercent = 100/curr_counts*curr_stackMatrix(7);
if currpercent <= 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(7),str_confi,str_once);
    object.f6N   = str_curr;
    humobjDev(6,6) = 100/curr_counts*curr_stackMatrix(7);
end

%few human (1% - 20%)            
currpercent = 100/curr_counts*curr_stackMatrix(12);
if currpercent > 1 || currpercent <= 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(12),str_confi,str_once);
    human.f3S  = str_curr;
end
currpercent = 100/curr_counts*curr_stackMatrix(13);
if currpercent  > 1 || currpercent <= 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(13),str_confi,str_once);
    human.f3T  = str_curr;
end
humobjDev(3,2) = getpercentagefromTwoClasses(human.f3S,human.f3T,curr_stackMatrix(12),curr_stackMatrix(13),curr_counts,str_confi);

currpercent = 100/curr_counts*curr_stackMatrix(14);
if currpercent > 1 || currpercent <= 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(14),str_confi,str_once);
    human.f4U  = str_curr;
    humobjDev(4,2) = 100/curr_counts*curr_stackMatrix(14); 
end
currpercent = 100/curr_counts*curr_stackMatrix(16);
if currpercent > 1 || currpercent <= 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(16),str_confi,str_once);
    human.f5W = str_curr;
end
currpercent = 100/curr_counts*curr_stackMatrix(17);
if currpercent > 1 || currpercent <= 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(17),str_confi,str_once);
    human.f5X   = str_curr;
end
humobjDev(5,2) = getpercentagefromTwoClasses(human.f5W,human.f5X,curr_stackMatrix(16),curr_stackMatrix(17),curr_counts,str_confi);

currpercent = 100/curr_counts*curr_stackMatrix(18);
if currpercent > 1 || currpercent <= 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(18),str_confi,str_once);
    human.f6Y  = str_curr;
    humobjDev(6,2) = 100/curr_counts*curr_stackMatrix(18);
end

% many/most obj (> 20%)
currpercent = 100/curr_counts*curr_stackMatrix(1);
if currpercent > 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(1),str_confi,str_once);
    object.mamo3H = str_curr;
    humobjDev(3,7) = 100/curr_counts*curr_stackMatrix(1);
end
currpercent = 100/curr_counts*curr_stackMatrix(2);
if currpercent > 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(2),str_confi,str_once);
    object.mamo4I = str_curr;
    humobjDev(4,7) = 100/curr_counts*curr_stackMatrix(2);
end
currpercent = 100/curr_counts*curr_stackMatrix(4);
if currpercent > 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(4),str_confi,str_once);
    object.mamo5K  = str_curr;
    humobjDev(5,7) = 100/curr_counts*curr_stackMatrix(4);
end
currpercent = 100/curr_counts*curr_stackMatrix(6);
if currpercent > 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(6),str_confi,str_once);
    object.mamo6M  = str_curr;
    humobjDev(6,7) = 100/curr_counts*curr_stackMatrix(6);
end
currpercent = 100/curr_counts*curr_stackMatrix(8);
if currpercent > 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(8),str_confi,str_once);
    object.mamo7O = str_curr;
    humobjDev(7,7) = 100/curr_counts*curr_stackMatrix(8);
end
currpercent = 100/curr_counts*curr_stackMatrix(9);
if currpercent > 20
    str_curr = markOnceTwiceReports(curr_stackMatrix(9),str_confi,str_once);
    object.mamo8P  = str_curr;
    humobjDev(8,7) = 100/curr_counts*curr_stackMatrix(9);
end

%many human (20% - 60%)
currpercent = 100/curr_counts*curr_stackMatrix(11);
if currpercent > 20 && currpercent <= 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(11),str_confi,str_once);
    human.ma3R  = str_curr;
    humobjDev(3,3) = 100/curr_counts*curr_stackMatrix(11);
end
currpercent = 100/curr_counts*curr_stackMatrix(12);
if currpercent > 20 && currpercent <= 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(12),str_confi,str_once);
    human.ma4S = str_curr;
    humobjDev(4,3) = 100/curr_counts*curr_stackMatrix(12);
end
currpercent = 100/curr_counts*curr_stackMatrix(14);
if currpercent > 20 && currpercent <= 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(14),str_confi,str_once);
    human.ma5U = str_curr;
    humobjDev(5,3) = 100/curr_counts*curr_stackMatrix(14);
end

currpercent = 100/curr_counts*curr_stackMatrix(16);
if currpercent > 20 && currpercent <= 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(16),str_confi,str_once);
    human.ma6W = str_curr;
end
currpercent = 100/curr_counts*curr_stackMatrix(17);
if currpercent > 20 && currpercent <= 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(17),str_confi,str_once);
    human.ma6X  = str_curr;
end
humobjDev(6,3) = getpercentagefromTwoClasses(human.ma6W,human.ma6X,curr_stackMatrix(16),curr_stackMatrix(17),curr_counts,str_confi);

currpercent = 100/curr_counts*curr_stackMatrix(18);
if currpercent > 20 && currpercent <= 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(18),str_confi,str_once);
    human.ma7Y  = str_curr;
end
currpercent = 100/curr_counts*curr_stackMatrix(19);
if currpercent > 20 && currpercent <= 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(19),str_confi,str_once);
    human.ma7Z = str_curr;
end
humobjDev(7,3) = getpercentagefromTwoClasses(human.ma7Y,human.ma7Z,curr_stackMatrix(18),curr_stackMatrix(19),curr_counts,str_confi);

currpercent = 100/curr_counts*curr_stackMatrix(19);
if currpercent > 20 && currpercent <= 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(19),str_confi,str_once);
    human.ma8Z = str_curr;
    humobjDev(8,3) = 100/curr_counts*curr_stackMatrix(19);
end

%most human (> 60%)
currpercent = 100/curr_counts*curr_stackMatrix(12);
if currpercent > 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(12),str_confi,str_once);
    human.mo5S = str_curr;
end
currpercent = 100/curr_counts*curr_stackMatrix(15);
if currpercent > 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(15),str_confi,str_once);
    human.mo5V = str_curr;
end
humobjDev(5,4) = getpercentagefromTwoClasses(human.mo5S,human.mo5V,curr_stackMatrix(12),curr_stackMatrix(15),curr_counts,str_confi);

currpercent = 100/curr_counts*curr_stackMatrix(12);
if currpercent > 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(12),str_confi,str_once);
    human.mo6S = str_curr;
    humobjDev(6,4) = 100/curr_counts*curr_stackMatrix(12);
end

currpercent = 100/curr_counts*curr_stackMatrix(16);
if currpercent > 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(16),str_confi,str_once);
    human.mo7W = str_curr;
end
currpercent = 100/curr_counts*curr_stackMatrix(17);
if currpercent > 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(17),str_confi,str_once);
    human.mo7X = str_curr;
end
humobjDev(7,4) = getpercentagefromTwoClasses(human.mo7W,human.mo7X,curr_stackMatrix(16),curr_stackMatrix(17),curr_counts,str_confi);

currpercent = 100/curr_counts*curr_stackMatrix(19);
if currpercent > 60
    str_curr = markOnceTwiceReports(curr_stackMatrix(19),str_confi,str_once);
    human.mo9Z = str_curr;
    humobjDev(9,4) = 100/curr_counts*curr_stackMatrix(19);
end
 





function str_curr = markOnceTwiceReports(count_currstackparam,str_confi,str_once)

str_curr = str_confi;

if count_currstackparam==1
    str_curr = sprintf('%s%s',str_confi,str_once);
end
if count_currstackparam==2
    str_curr = sprintf('%s%s%s',str_confi,str_once,str_once);
end
if count_currstackparam==3
    str_curr = sprintf('%s%s%s%s',str_confi,str_once,str_once,str_once);
end





function percentout = getpercentagefromTwoClasses(val1str,val2str,val1,val2,maxcountsForpercentclass,str_confi)
%check if two classes exists and output the according percentage
percentout = 0;

if strcmp(val1str,str_confi)==1 && strcmp(val2str,str_confi)==1
    percentout = 100/(2*maxcountsForpercentclass)*(val1+val2);
else
    if strcmp(val1str,str_confi)
       percentout = 100/maxcountsForpercentclass*val1; 
    end
   if strcmp(val2str,str_confi)
       percentout = 100/maxcountsForpercentclass*val2;
   end
end




function humobjDevout = computeDeviations(humobjDev,EMSKonstantVals)
%verwende lenhardt et al.,2002 mit einschränkungen
% wenn alle werte in human oder object =0 dann Werte Dev=+1
% damage categorie wird noch nicht verwendet.
humobjDevout = humobjDev;

tmp = max(humobjDev);
tmp = max(tmp);
if tmp > 100
   fprintf('\n[warning] humobjDev matrix contain vals greater than 100%% (%6.2f)\n',tmp); 
end
clear tmp;

w1 = 1;    w2 = 1;     w3 = 1;

for p=1:12
    k0 = EMSKonstantVals(p,1); k1 = EMSKonstantVals(p,2); k2 = EMSKonstantVals(p,3); k3 = EMSKonstantVals(p,4);
    k4 = EMSKonstantVals(p,5); k5 = EMSKonstantVals(p,6); k00 = EMSKonstantVals(p,7); k11 = EMSKonstantVals(p,8);
    k22 = EMSKonstantVals(p,9); k33 = EMSKonstantVals(p,10); 
    [k0,k1,k2,k3,k4,k5] = getCurrentKvaluesHuman(k0,k1,k2,k3,k4,k5,humobjDev(p,1),humobjDev(p,2),humobjDev(p,3),humobjDev(p,4));
   hupe1 = k1 * abs(humobjDev(p,1)-0.5)/0.5;
   hupe2 = k2 * abs(humobjDev(p,2)-10.5)/9.5;
   hupe3 = k3 * abs(humobjDev(p,3)-40)/20; 
   hupe4 = k4 * abs(humobjDev(p,4)-80)/20;
   if (humobjDev(p,1) + humobjDev(p,2) + humobjDev(p,3) + humobjDev(p,4))==0 
       humobjDevout(p,5) = 1;
   else
       %humobjDevout(p,5) = (w1/k0)*(hupe1+hupe2+hupe3+hupe4+k5);
       humobjDevout(p,5) = (w1/k0)*(k1+k2+k3+k4+k5);
   end
   
   [k00,k11,k22,k33] = getCurrentKvaluesObject(k00,k11,k22,k33,humobjDev(p,6),humobjDev(p,7));
   obje1 = k11 * abs(humobjDev(p,6)-10)/10;
   obje2 = k22 * abs(humobjDev(p,7)-60)/40;
   if (humobjDev(p,6) + humobjDev(p,7))==0
       humobjDevout(p,8) = 1;
   else
       %humobjDevout(p,8) = (w2/k00)*(obje1+obje2+k33);
       humobjDevout(p,8) = (w2/k00)*(k11+k22+k33);
   end
end
%    figure;
%    plot(humobjDevout(:,5));
%    hold on
%    plot(humobjDevout(:,8),'r');
% disp(' ');





function [cellhuman,cellobject] = getcellhumanobject(str_blank)

cellhuman{1} = str_blank;  cellhuman{2} = str_blank;   cellhuman{3} = str_blank;    cellhuman{4} = str_blank;    cellhuman{5} = str_blank;  cellhuman{11} = str_blank;
cellhuman{6} = str_blank;  cellhuman{7} = str_blank;   cellhuman{8} = str_blank;    cellhuman{9} = str_blank;    cellhuman{10} = str_blank; cellhuman{12} = str_blank;
cellobject = cellhuman;



function [cellhuman,cellobject] = addMaximalValuetoCells(cellhuman,cellobject,humobjDev)
%mark the minimum values for human and object

minval = min(humobjDev(:,5));    ind = find(humobjDev(:,5)==minval);
if numel(ind)>1
    for p=1: numel(ind)
        currind = ind(p);
        cellhuman{currind} = '<';
    end
else
    cellhuman{ind} = '<';
end

minval = min(humobjDev(:,8));    ind = find(humobjDev(:,8)==minval);
if numel(ind)>1
    for p=1: numel(ind)
        currind = ind(p);
        cellobject{currind} = '<';
    end
else
    cellobject{ind} = '<';
end




function strout = getEmptyValsTwoString(val1,str01,val2,str02,str_confi)
strout = '-';
val = 0;

tmp = strfind(val1,str_confi);
if isempty(tmp) 
    val1 = '';
    str01 = '-';
    val = val + 1;
end
clear tmp;

tmp = strfind(val2,str_confi);
if isempty(tmp) 
    val2 = '';
    str02 = '-';
    val = val + 3;
end


switch val
    case 0
        strout = sprintf('%s%s,%s%s',val1,str01,val2,str02);
    case 1
        strout = sprintf('%s%s',val2,str02);
    case 3
        strout = sprintf('%s%s',val1,str01);
    case 4
        strout = '-';
end




function strout = getEmptyValsOneString(val1,str01,str_confi)
strout = '-';

tmp = strfind(val1,str_confi);
if isempty(tmp) 
    val1 = '';
    str01 = '-';
end

strout = sprintf('%s%s',val1,str01);




function  [k0,k1,k2,k3,k4,k5] = getCurrentKvaluesHuman(k0,k1,k2,k3,k4,k5,val1,val2,val3,val4)
% rresize the k-values in the case that not all
% quantities are filled

%approach Hausmann 2013
%use weights 1 1.2 2 4
k1=-1;   k2=-1.2;   k3=-2;   k4=-4;

if k1==1 && val1==0
    k1 = 0;
end
if k2==1 && val2==0
    k2 = 0;
end
if k3==1 && val3==0
    k3 = 0;
end
if k4==1 && val4==0
    k4 = 0;
end
%k0 = k1*1 + k2*1.1053 + k3*2 + k4*4 + k5*1;
k0 = -k1*1 + -k2*1.1053 + -k3*2 + -k4*4 + k5*1;





function [k00,k11,k22,k33] = getCurrentKvaluesObject(k00,k11,k22,k33,val11,val22)
% resize the k-values in the case that not all
% quantities are filled

k11=-1;  k22=-1.5;

if k11==1 && val11==0
    k11 = 0;
end
if k22==1 && val22==0
    k22 = 0;
end
%k00 = k11*1 + k22*1.5+k33*1;
k00 = -k11*1 + -k22*1.5+k33*1;

