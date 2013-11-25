function StrongMotionEventsWien()

setting = getSettings();

%file input
[setting,data] = readTextFile(setting);

%query db and get events
for k=1:setting.file.counts
    curr_evid = data(k,1);
    [EQ,setting] = getEQparameters(setting,curr_evid);
    FeltEQ(k).timeflt = EQ.timeflt;
    FeltEQ(k).lat = EQ.lat;
    FeltEQ(k).lon = EQ.lon;
    FeltEQ(k).ml = EQ.ml;
    FeltEQ(k).etype = EQ.etype;
    FeltEQ(k).magtype = EQ.magtype;
    FeltEQ(k).evname = EQ.evname;
    FeltEQ(k).auth = EQ.auth;
    FeltEQ(k).orid = EQ.orid;
    FeltEQ(k).evid = EQ.evid;
    FeltEQ(k).mmacro = EQ.mmacro;
    FeltEQ(k).inull = EQ.inull;
    FeltEQ(k).depth = EQ.depth;
    FeltEQ(k).timestr = EQ.timestr;   
    FeltEQ(k).distanceTo.BGWA = getDistancekm(setting,EQ.lat,EQ.lon,'BGWA');
    FeltEQ(k).distanceTo.UMWA = getDistancekm(setting,EQ.lat,EQ.lon,'UMWA');
    FeltEQ(k).distanceTo.WIWA = getDistancekm(setting,EQ.lat,EQ.lon,'WIWA');
    FeltEQ(k).distanceTo.KMWA = getDistancekm(setting,EQ.lat,EQ.lon,'KMWA');  
    FeltEQ(k).distanceTo.SNWA = getDistancekm(setting,EQ.lat,EQ.lon,'SNWA'); 
    FeltEQ(k).accelMcGuire.BGWA = getAccelMcGuire(setting,FeltEQ(k).distanceTo.BGWA,EQ.depth,EQ.ml);
    FeltEQ(k).accelMcGuire.UMWA = getAccelMcGuire(setting,FeltEQ(k).distanceTo.UMWA,EQ.depth,EQ.ml);
    FeltEQ(k).accelMcGuire.WIWA = getAccelMcGuire(setting,FeltEQ(k).distanceTo.WIWA,EQ.depth,EQ.ml);
    FeltEQ(k).accelMcGuire.KMWA = getAccelMcGuire(setting,FeltEQ(k).distanceTo.KMWA,EQ.depth,EQ.ml);
    FeltEQ(k).accelMcGuire.SNWA = getAccelMcGuire(setting,FeltEQ(k).distanceTo.SNWA,EQ.depth,EQ.ml); 
    FeltEQ(k).accelYan.BGWA = getAccelYan(setting,FeltEQ(k).distanceTo.BGWA,EQ.depth,EQ.ml);
    FeltEQ(k).accelYan.UMWA = getAccelYan(setting,FeltEQ(k).distanceTo.UMWA,EQ.depth,EQ.ml);
    FeltEQ(k).accelYan.WIWA = getAccelYan(setting,FeltEQ(k).distanceTo.WIWA,EQ.depth,EQ.ml);
    FeltEQ(k).accelYan.KMWA = getAccelYan(setting,FeltEQ(k).distanceTo.KMWA,EQ.depth,EQ.ml);
    FeltEQ(k).accelYan.SNWA = getAccelYan(setting,FeltEQ(k).distanceTo.SNWA,EQ.depth,EQ.ml);    
    if FeltEQ(k).magtype <= setting.accmodel.magnitudelimit
      FeltEQ(k).accelprefor.BGWA = FeltEQ(k).accelYan.BGWA;
      FeltEQ(k).accelprefor.UMWA = FeltEQ(k).accelYan.UMWA;
      FeltEQ(k).accelprefor.WIWA = FeltEQ(k).accelYan.WIWA;
      FeltEQ(k).accelprefor.KMWA = FeltEQ(k).accelYan.KMWA;
      FeltEQ(k).accelprefor.SNWA = FeltEQ(k).accelYan.SNWA;           
    else
      FeltEQ(k).accelprefor.BGWA = FeltEQ(k).accelMcGuire.BGWA;
      FeltEQ(k).accelprefor.UMWA = FeltEQ(k).accelMcGuire.UMWA;
      FeltEQ(k).accelprefor.WIWA = FeltEQ(k).accelMcGuire.WIWA;
      FeltEQ(k).accelprefor.KMWA = FeltEQ(k).accelMcGuire.KMWA;
      FeltEQ(k).accelprefor.SNWA = FeltEQ(k).accelMcGuire.SNWA;        
    end
    FeltEQ(k).ilocSponheuer.BGWA = getIlocSponheuer(setting,FeltEQ(k).distanceTo.BGWA,EQ.inull,EQ.depth);
    FeltEQ(k).ilocSponheuer.UMWA = getIlocSponheuer(setting,FeltEQ(k).distanceTo.UMWA,EQ.inull,EQ.depth);
    FeltEQ(k).ilocSponheuer.WIWA = getIlocSponheuer(setting,FeltEQ(k).distanceTo.WIWA,EQ.inull,EQ.depth);
    FeltEQ(k).ilocSponheuer.KMWA = getIlocSponheuer(setting,FeltEQ(k).distanceTo.KMWA,EQ.inull,EQ.depth);
    FeltEQ(k).ilocSponheuer.SNWA = getIlocSponheuer(setting,FeltEQ(k).distanceTo.SNWA,EQ.inull,EQ.depth);
end

showSortedAndCutList(FeltEQ,data,setting);

setting = getRatioModelObservedAcceleration(FeltEQ,data,setting);

displayTotalAccelerations(FeltEQ,data,setting);

disp(' ');




function displayTotalAccelerations(EQlistsort,data,setting)
%plot total acceleration from model (McGuire) and observed vals.
% for each event
figure('Name','Strong-Motion Messnetz Wien - Acceleration','Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height]);

% // plot BGWA
subplot(5,1,1); hold on;
accobserved = data(:,2);
for p=1:numel(EQlistsort)
  %dist(p) = EQlistsort(p).distanceTo.BGWA; 
  %text(dist(p),accelmod(p),sprintf('%2g',p),'Fontsize',9);
  accelmod(p) = EQlistsort(p).accelprefor.BGWA.*100;
  if accobserved(p)==0
      accelobs(p) = NaN;
      diffModel(p) = NaN;
      accelmodcorr(p) = accelmod(p)/setting.BGWA.ratioModObsAccel;
  else
      accelobs(p) = accobserved(p); 
      plot([p;p],[0;accelobs(p)],'-r','LineWidth',2); 
      diffModel(p) = EQlistsort(p).accelprefor.BGWA.*100 / accobserved(p);
      accelmodcorr(p) = NaN;
  end
end
plot([1;numel(EQlistsort)],[setting.BGWA.trigg;setting.BGWA.trigg],'--b');
semilogy([1:numel(EQlistsort)],accelmodcorr,'rs','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',10);
semilogy([1:numel(EQlistsort)],accelobs,'rs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',12);
set(gca,'YAxisLocation','left'); set(gca,'fontsize',setting.fontsizeaxis);
ylabel('Acceleration (cm/s²)','fontsize',setting.fontsize);

setting.h1 = gca;
if setting.plot2ndPlotEQlistplot.yesno == 1
  setting.h2 = axes('Position',get(setting.h1,'Position'));
  plot([1:numel(EQlistsort)],diffModel(:),'ok','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',7,'Parent',setting.h2);
  hold on;
  set(setting.h2,'YAxisLocation','right','Color','none','XTickLabel',[],'XTick',[]); 
  set(setting.h2,'XLim',get(setting.h1,'XLim'),'Layer','top','fontsize',setting.fontsizeaxis);
  ylabel('Mod/Obs','FontSize',setting.fontsizeaxis);  
end


% // plot UMWA
subplot(5,1,2); hold on;
accobserved = data(:,3);
for p=1:numel(EQlistsort)
  accelmod(p) = EQlistsort(p).accelprefor.UMWA.*100;
  if accobserved(p)==0
      accelobs(p) = NaN;
      diffModel(p) = NaN;
      accelmodcorr(p) = accelmod(p)/setting.UMWA.ratioModObsAccel;
  else
      accelobs(p) = accobserved(p); 
      plot([p;p],[0;accelobs(p)],'-r','LineWidth',2); 
      diffModel(p) = EQlistsort(p).accelprefor.UMWA.*100 / accobserved(p);
      accelmodcorr(p) = NaN;
  end
end
plot([1;numel(EQlistsort)],[setting.UMWA.trigg;setting.UMWA.trigg],'--b');
semilogy([1:numel(EQlistsort)],accelmodcorr,'rs','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',10);
semilogy([1:numel(EQlistsort)],accelobs,'rs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',12);
set(gca,'YAxisLocation','left'); set(gca,'fontsize',setting.fontsizeaxis);
ylabel('Acceleration (cm/s²)','fontsize',setting.fontsize);

setting.h1 = gca;
if setting.plot2ndPlotEQlistplot.yesno == 1
  setting.h2 = axes('Position',get(setting.h1,'Position'));
  plot([1:numel(EQlistsort)],diffModel(:),'ok','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',7,'Parent',setting.h2);
  hold on;
  set(setting.h2,'YAxisLocation','right','Color','none','XTickLabel',[],'XTick',[]); 
  set(setting.h2,'XLim',get(setting.h1,'XLim'),'Layer','top','fontsize',setting.fontsizeaxis);
  ylabel('Mod/Obs','FontSize',setting.fontsizeaxis);  
end


% // plot WIWA
subplot(5,1,3); hold on;
accobserved = data(:,4);
for p=1:numel(EQlistsort)
  accelmod(p) = EQlistsort(p).accelprefor.WIWA.*100;
  if accobserved(p)==0
      accelobs(p) = NaN;
      diffModel(p) = NaN;
      accelmodcorr(p) = accelmod(p)/setting.WIWA.ratioModObsAccel;
  else
      accelobs(p) = accobserved(p); 
      plot([p;p],[0;accelobs(p)],'-r','LineWidth',2); 
      diffModel(p) = EQlistsort(p).accelprefor.WIWA.*100 / accobserved(p);
      accelmodcorr(p) = NaN;
  end
end
plot([1;numel(EQlistsort)],[setting.WIWA.trigg;setting.WIWA.trigg],'--b');
semilogy([1:numel(EQlistsort)],accelmodcorr,'rs','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',10);
semilogy([1:numel(EQlistsort)],accelobs,'rs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',12);
set(gca,'YAxisLocation','left'); set(gca,'fontsize',setting.fontsizeaxis);
ylabel('Acceleration (cm/s²)','fontsize',setting.fontsize);

setting.h1 = gca;
if setting.plot2ndPlotEQlistplot.yesno == 1
  setting.h2 = axes('Position',get(setting.h1,'Position'));
  plot([1:numel(EQlistsort)],diffModel(:),'ok','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',7,'Parent',setting.h2);
  hold on;
  set(setting.h2,'YAxisLocation','right','Color','none','XTickLabel',[],'XTick',[]); 
  set(setting.h2,'XLim',get(setting.h1,'XLim'),'Layer','top','fontsize',setting.fontsizeaxis);
  ylabel('Mod/Obs','FontSize',setting.fontsizeaxis);  
end



% // plot KMWA
subplot(5,1,4); hold on;
accobserved = data(:,5);
for p=1:numel(EQlistsort)
  accelmod(p) = EQlistsort(p).accelprefor.KMWA.*100;
  if accobserved(p)==0
      accelobs(p) = NaN;
      diffModel(p) = NaN;
      accelmodcorr(p) = accelmod(p)/setting.KMWA.ratioModObsAccel;
  else
      accelobs(p) = accobserved(p); 
      plot([p;p],[0;accelobs(p)],'-r','LineWidth',2); 
      diffModel(p) = EQlistsort(p).accelprefor.KMWA.*100 / accobserved(p);
      accelmodcorr(p) = NaN;
  end
end
plot([1;numel(EQlistsort)],[setting.KMWA.trigg;setting.KMWA.trigg],'--b');
semilogy([1:numel(EQlistsort)],accelmodcorr,'rs','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',10);
semilogy([1:numel(EQlistsort)],accelobs,'rs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',12);
set(gca,'YAxisLocation','left'); set(gca,'fontsize',setting.fontsizeaxis);
ylabel('Acceleration (cm/s²)','fontsize',setting.fontsize);

setting.h1 = gca;
if setting.plot2ndPlotEQlistplot.yesno == 1
  setting.h2 = axes('Position',get(setting.h1,'Position'));
  plot([1:numel(EQlistsort)],diffModel(:),'ok','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',7,'Parent',setting.h2);
  hold on;
  set(setting.h2,'YAxisLocation','right','Color','none','XTickLabel',[],'XTick',[]); 
  set(setting.h2,'XLim',get(setting.h1,'XLim'),'Layer','top','fontsize',setting.fontsizeaxis);
  ylabel('Mod/Obs','FontSize',setting.fontsizeaxis);  
end


% // plot SNWA
subplot(5,1,5); hold on;
accobserved = data(:,5);
for p=1:numel(EQlistsort)
  accelmod(p) = EQlistsort(p).accelprefor.SNWA.*100;
  if accobserved(p)==0
      accelobs(p) = NaN;
      diffModel(p) = NaN;
      accelmodcorr(p) = accelmod(p)/setting.SNWA.ratioModObsAccel;
  else
      accelobs(p) = accobserved(p); 
      plot([p;p],[0;accelobs(p)],'-r','LineWidth',2); 
      diffModel(p) = EQlistsort(p).accelprefor.SNWA.*100 / accobserved(p);
      accelmodcorr(p) = NaN;
  end
end
plot([1;numel(EQlistsort)],[setting.SNWA.trigg;setting.SNWA.trigg],'--b');
semilogy([1:numel(EQlistsort)],accelmodcorr,'rs','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',10);
semilogy([1:numel(EQlistsort)],accelobs,'rs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',12);
set(gca,'YAxisLocation','left'); set(gca,'fontsize',setting.fontsizeaxis);
ylabel('Acceleration (cm/s²)','fontsize',setting.fontsize);

setting.h1 = gca;
if setting.plot2ndPlotEQlistplot.yesno == 1
  setting.h2 = axes('Position',get(setting.h1,'Position'));
  plot([1:numel(EQlistsort)],diffModel(:),'ok','LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',7,'Parent',setting.h2);
  hold on;
  set(setting.h2,'YAxisLocation','right','Color','none','XTickLabel',[],'XTick',[]); 
  set(setting.h2,'XLim',get(setting.h1,'XLim'),'Layer','top','fontsize',setting.fontsizeaxis);
  ylabel('Mod/Obs','FontSize',setting.fontsizeaxis);  
end

%semilogy([1:numel(EQlistsort)],accelmod,'rs','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','c','MarkerSize',8);
%EQlistsort(p).ilocSponheuer.BGWA,EQlistsort(p).accelMcGarr.BGWA*100,accobserved(p),EQlistsort(p).distanceTo.BGWA);

disp(' ');



function distkm = getDistancekm(setting,origlat,origlon,flag)
distkm = 0;
switch flag   
    case 'BGWA'
        lat = setting.BGWA.lat;
        lon = setting.BGWA.lon;
    case 'UMWA'
        lat = setting.UMWA.lat;
        lon = setting.UMWA.lon;        
    case 'WIWA'
        lat = setting.WIWA.lat;
        lon = setting.WIWA.lon;        
    case 'KMWA'
        lat = setting.KMWA.lat;
        lon = setting.KMWA.lon;        
    case 'SNWA'
        lat = setting.SNWA.lat;
        lon = setting.SNWA.lon;        
end
[s,azi] = vdist(lat,lon,origlat,origlon); 
distkm = s/1000;




function setting = getRatioModelObservedAcceleration(EQlistsort,data,setting)

for p=1:numel(EQlistsort)
    accobservedBGWA(p) = data(p,2);
    accobservedUMWA(p) = data(p,3);
    accobservedWIWA(p) = data(p,4);
    accobservedKMWA(p) = data(p,5);
    accobservedSNWA(p) = data(p,6);
  if accobservedBGWA(p)==0
     diffBGWA(p) = NaN;
  else
     diffBGWA(p) = EQlistsort(p).accelprefor.BGWA.*100 / accobservedBGWA(p);
  end
  
  if accobservedUMWA(p)==0
     diffUMWA(p) = NaN;
  else
     diffUMWA(p) = EQlistsort(p).accelprefor.UMWA.*100 / accobservedUMWA(p);
  end
  
  if accobservedWIWA(p)==0
     diffWIWA(p) = NaN;
  else
     diffWIWA(p) = EQlistsort(p).accelprefor.WIWA.*100 / accobservedWIWA(p);
  end  
  
   if accobservedKMWA(p)==0
     diffKMWA(p) = NaN;
  else
     diffKMWA(p) = EQlistsort(p).accelprefor.KMWA.*100 / accobservedKMWA(p);
  end 
  if accobservedSNWA(p)==0
     diffSNWA(p) = NaN;
  else
     diffSNWA(p) = EQlistsort(p).accelprefor.SNWA.*100 / accobservedSNWA(p);
  end 
end

ind = ~isnan(diffBGWA);
diffBGWA = diffBGWA(ind);

ind = ~isnan(diffUMWA);
diffUMWA = diffUMWA(ind);

ind = ~isnan(diffWIWA);
diffWIWA = diffWIWA(ind);

ind = ~isnan(diffKMWA);
diffKMWA = diffKMWA(ind);

ind = ~isnan(diffSNWA);
diffSNWA = diffSNWA(ind);

setting.BGWA.ratioModObsAccel = mean(diffBGWA);
setting.UMWA.ratioModObsAccel = mean(diffUMWA);
setting.WIWA.ratioModObsAccel = mean(diffWIWA);
setting.KMWA.ratioModObsAccel = mean(diffKMWA);
setting.SNWA.ratioModObsAccel = mean(diffSNWA);

%