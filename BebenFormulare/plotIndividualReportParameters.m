function plotIndividualReportParameters(Reports,FeltEQ,setting,HistPLzDist,HistName,infoSelectEvent)
% plot all parameters that were found in the database
% which were extrtacted from the reports. The code sorts all
% parameters and output (initially) those which are used
% abundantely.
indexnum = setting.curreventid; 
OneEQReports = Reports(indexnum);
orilat = FeltEQ.lat(indexnum);   orilon = FeltEQ.lon(indexnum);
displaySumStacked(OneEQReports);

[OneEQReports,setting] = getEqAdditionalReportTexts(OneEQReports,setting,1);  %additional texts from 'webform' using FID
[DamageTexts] = getEqDamageTexts(OneEQReports,orilat,orilon,setting,1);  %from 'webform' using FID
if ~isempty(DamageTexts)
   writeReportsPerPLZ_DamagesText(setting,infoSelectEvent,DamageTexts);
end

% // Stack the data from the matrix to plz regions
[PLZ,PLZstack,PLzDist,StackrepMatrix] = StackrepMatrix2PLZ(OneEQReports);

% // Find the report parameters by their number sum)
sumMatrix = sum(StackrepMatrix,1);
legstringall = {'H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','dam','dg','00','03','06','11','20','k','g','r','s','z'};
[a,inds] = sort(sumMatrix,'descend');  clear a;
figcaption = getFigureCaptionEvent(FeltEQ,Reports,indexnum);
indtmp = find(StackrepMatrix(:,20)>0);

% // Start Plotting ..
if setting.plot.showPlot == 1
    figure('Name',figcaption,'Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height]);
    interval = 5; markersize = 8; linewidth = 2;
    %plot the reports/plz
    subplot(5,1,1); hold on;
    plot(PLzDist,PLZstack,'--ko','MarkerSize',markersize,'MarkerEdgeColor','k','MarkerFaceColor','w','LineWidth',linewidth);
    legend('reports/plz-region',1);  xlim(setting.plot.individual.xlim); set(gca,'fontsize',setting.fontsizeaxis);
    xlabel('Distanz (km)','fontsize',setting.fontsize);  ylabel('Meldungen','fontsize',setting.fontsize);
    
    
    %plot the reports/plz & damage
    %subplot(3,1,2); hold on;
    %plot(PLzDist,StackrepMatrix(:,20),'o','MarkerSize',markersize-4,'MarkerEdgeColor','k','MarkerFaceColor','w');
    if isempty(indtmp)
        %legend('no damage',1);
    else
        %set(gca,'Box','off','Color','white','XTick',[],'YTick',[]);
        set(gca,'YMinorTick','off','TickDir','out');
        set(gca,'YAxisLocation','left','XMinorTick', 'off', 'TickDir','out');
        h1 = gca;
        h2 = axes('Position',get(h1,'Position'));
        plot(PLzDist(indtmp),StackrepMatrix(indtmp,size(StackrepMatrix,2)),'p','MarkerSize',markersize+2,'MarkerEdgeColor','k','Parent',h2);
        set(h2,'YAxisLocation','right','Color','none','XTickLabel',[],'XTick',[]);
        set(h2,'Box','off');
        set(h2,'XLim',get(h1,'XLim'),'Layer','top','fontsize',setting.fontsizeaxis);
        ylabel(h2,'Damages','fontsize',setting.fontsizeaxis);
        set(h2,'XLim',setting.plot.individual.xlim);
        set(h2,'YLim',[0 max(StackrepMatrix(indtmp,20))]);
        %legend({'no damage','damage'},2);
    end
    
    %plot the first 5 parameters
    subplot(5,1,2:3); hold on;
    currindarray = inds(1:interval);
    k = 0;
    for p=1:interval
        k = k + 1;
        currindex = currindarray(k);
        currx = PLzDist;
        curry = StackrepMatrix(:,currindex);
        [col0,line0,symb0] = getcurrmarkers(k);
        plot(currx,curry,sprintf('%s%s',line0,symb0),'MarkerSize',markersize,'MarkerEdgeColor','k','MarkerFaceColor',col0,'Color',col0);
    end
    legstr = legstringall(currindarray);  legend(legstr,numel(legstr));  xlim(setting.plot.individual.xlim);
    xlabel('Distanz (km)','fontsize',setting.fontsize); ylabel('Anzahl der Parameter','fontsize',setting.fontsize);
    set(gca,'fontsize',setting.fontsizeaxis);
    
    %plot the parameters 6 to 10
    subplot(5,1,4:5); hold on;
    k = 0;
    currindarray = inds((1*interval+1):(2*interval));
    for p=(1*interval+1):(2*interval)
        k = k + 1;
        currindex = currindarray(k);
        currx = PLzDist;
        curry = StackrepMatrix(:,currindex);
        [col0,line0,symb0] = getcurrmarkers(k);
        plot(currx,curry,sprintf('%s%s',line0,symb0),'MarkerSize',markersize,'MarkerEdgeColor','k','MarkerFaceColor',col0,'Color',col0);
    end
    legstr = legstringall(currindarray);  legend(legstr,numel(legstr));  xlim(setting.plot.individual.xlim);
    xlabel('Distanz (km)','fontsize',setting.fontsize); ylabel('Anzahl der Parameter','fontsize',setting.fontsize);
    set(gca,'fontsize',setting.fontsizeaxis);
end

displayEMS98code(setting,sumMatrix,legstringall,OneEQReports); disp(' ');
writeEMS98code(setting,sumMatrix,legstringall,OneEQReports,figcaption,infoSelectEvent);
if ~isempty(HistPLzDist) && ~isempty(HistName)
   writeReportsPerPLZ_ObjHumPerception(setting,HistPLzDist,HistName,infoSelectEvent,StackrepMatrix);
   writeReportsPerPLZ_ObjHumPertoKML(setting,HistPLzDist,HistName,infoSelectEvent,StackrepMatrix);
   if ~isempty(indtmp)
      writeReportsPerPLZ_DamagestoKML(setting,HistPLzDist,HistName,infoSelectEvent,StackrepMatrix);
   end
   if setting.ComputerAidedIntensity.write == 1
       writeComputerAidedIntensityPerPLZ(setting,HistPLzDist,HistName,infoSelectEvent,StackrepMatrix);
   end
end
fprintf(' // All files were written to the folder %s \n ',fullfile(pwd,setting.textfile.folder));
disp('-');



function displayEMS98code(setting,sumMatrix,legstringal,OneEQReports)
%outputs the description of the code classes H,I..XYZ
% for objects and human perception

for k=1:numel(setting.ems98.code)
    currstr = setting.ems98.code{k}; currnumberstack = 0;
    for g=1:numel(legstringal)
        currlegstr = legstringal{g};
        if strcmp(currlegstr,currstr)==1
           currnumberstack = sumMatrix(g);
           g = numel(legstringal);
        end
    end
    fprintf('[%s] %6g Stück (%4.0f%%): %s \n',currstr,currnumberstack,100/OneEQReports.formcounts*currnumberstack,setting.ems98.descript{k});
end








function displaySumStacked(OneEQReports)

fprintf('\n ..search for number of reports per PLZ to show the parameters - here the sum:\n');
fprintf('     H       I       J       K       L       M       N       O       P \n');
fprintf('%6g  %6g  %6g  %6g  %6g  %6g  %6g  %6g %6g\n',sum(OneEQReports.repMatrix(:,1)),sum(OneEQReports.repMatrix(:,2)),sum(OneEQReports.repMatrix(:,3))...
    ,sum(OneEQReports.repMatrix(:,4)),sum(OneEQReports.repMatrix(:,5)),sum(OneEQReports.repMatrix(:,6)),sum(OneEQReports.repMatrix(:,7)),sum(OneEQReports.repMatrix(:,8)),sum(OneEQReports.repMatrix(:,9)));
fprintf('------------------------------------------------------------------------------\n');
fprintf('     Q       R       S       T       U       V       W       X       Y      Z \n');
fprintf('%6g  %6g  %6g  %6g  %6g  %6g  %6g  %6g  %6g  %6g\n',sum(OneEQReports.repMatrix(:,10))...
    ,sum(OneEQReports.repMatrix(:,11)),sum(OneEQReports.repMatrix(:,12)),sum(OneEQReports.repMatrix(:,13)),sum(OneEQReports.repMatrix(:,14)),sum(OneEQReports.repMatrix(:,15))...
    ,sum(OneEQReports.repMatrix(:,16)),sum(OneEQReports.repMatrix(:,17)),sum(OneEQReports.repMatrix(:,18)),sum(OneEQReports.repMatrix(:,19)));
disp(' ');

