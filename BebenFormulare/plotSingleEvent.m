function  [HistPLzDist,HistName,infoSelectEvent,setting] = plotSingleEvent(Reports,FeltEQ,setting)
% plot time dependend of the reports and the distance
% histogramm. azimuth?

indexnum = setting.curreventid;
infoSelectEvent = reportInfonSelectedEvent(FeltEQ,Reports,indexnum);
[mint,maxt,mintnum,maxtnum] = getMinMaxTime(Reports,FeltEQ,indexnum);
setting.textfile.prefix = sprintf('%s_M%3.1f_%s',infoSelectEvent{5},infoSelectEvent{6},infoSelectEvent{7});
setting.infoSelectEvent = infoSelectEvent;

%[Reports,setting] = getEqAdditionalReportTexts(Reports,setting,indexnum);  %additional texts from 'webform'

if setting.plot.showPlot == 1
    figcaption = getFigureCaptionEvent(FeltEQ,Reports,indexnum);
    figure('Name',figcaption,'Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height]);
   
    % // plot time dependence
    subplot(2,2,1); hold on;
    timeunix = Reports(indexnum).timeflt(:);
    timestr = epoch2str(timeunix,'%G %H:%M');
    time = datenum(timestr,'yyyy-mm-dd HH:MM');
    timestrorigin = epoch2str(FeltEQ.timeflt(indexnum),'%G %H:%M');
    timeorigin = datenum(timestrorigin,'yyyy-mm-dd HH:MM');
    dist = Reports(indexnum).distkmlist(:);
    A = sortrows([time dist],1); % sortiere nach Zeit
    time = A(:,1); dist = A(:,2);
    plot(time,dist,'rs','LineWidth',2,'MarkerEdgeColor','k',...
        'MarkerFaceColor','c','MarkerSize',10);
    plot([timeorigin;timeorigin],[0;max(dist)],'--r','LineWidth',2);
    datetick('x','HH:MM','keepticks');
    xlabel('Zeit (hh:mm)'); ylabel('Distanz (km)');
    
    
    % // plot zeitabhängigkeit
    subplot(2,2,2); hold on;
    timered =   timeunix - FeltEQ.timeflt(indexnum); %origin time in unix secs
    A = sortrows([timered dist],1); % sortiere nach Zeit
    timered = A(:,1)/60; dist = A(:,2); %use minutes
    [n,xout] = hist(timered,50);
    bar(xout,n);
    xlabel('Zeit (min.)'); ylabel('Anzahl der Meldungen');
    fprintf('Abweichung - std(0=bekannt=mean)=%4.1f min.    std(matlab)=%4.1f min.    mean(!)=%4.2f \n',sqrt(sum(timered.^2)/numel(timered)),std(timered),mean(timered));
    
    % //plot entfernungshäuffigkeit
    subplot(2,2,3); hold off;
    theta = Reports(indexnum).azimlist(:);
    dist = Reports(indexnum).distkmlist(:);
    [dist_lim,theta_lim] = limitForThetaUndDistancePlot(dist,theta,setting);
    h = polar(theta_lim*(2*pi/180),dist_lim,'rs');
    set(h,'MarkerFaceColor','c','MarkerSize',10,'MarkerEdgeColor','k');
    %xlabel('azimuth (deg.)');  ylabel('distance (km)');
end

% // histogramm PLZ nach distanz sortiert + ausgabe shell
% out= plz | n% out= plz | numberstack | distance | azimuth | lat | lonumberstack | distance | azimuth | lat | lon
[HistPLzDist,HistName] = StackPLZtoHistogramm(Reports(indexnum));
for k=1:size(HistPLzDist,1)
    fprintf('[%3g] %6g Meldungen aus %g %s, %3.0fkm\n',k,HistPLzDist(k,2),HistPLzDist(k,1),HistName{k},HistPLzDist(k,3));
end

% // stack similar distance groups to one group
[barX,barY] = StackPlZtoBargroups(HistPLzDist);

% // Plot the bars
if setting.plot.showPlot == 1
    subplot(2,2,4); hold on;
    bar(barX,barY);
    xlim(setting.plot.individual.xlim);
    xlabel('Orte nach Epidistanz sortiert'); ylabel('Anzahl der Meldungen');
end

setting.plotSingleEvent.IsApplied = 1;

% // write the Data
writeReportsPerPLZ(setting,HistPLzDist,HistName,infoSelectEvent);
writeReportsPerPLZtoKML(setting,HistPLzDist,HistName,infoSelectEvent);
writeReportsPerPLZRita(setting,HistPLzDist,HistName,infoSelectEvent);

fprintf(' // All files were written to the folder %s \n ',fullfile(pwd,setting.textfile.folder));


  







function [mint,maxt,mintnum,maxtnum] = getMinMaxTime(Reports,FeltEQ,indexnum)

timeflt = Reports(indexnum).timeflt;
timeflt = [timeflt;FeltEQ.timeflt(indexnum)];
mint = min(timeflt);
maxt = max(timeflt);
mintstr = epoch2str(mint,'%G %H:%M'); mintnum = datenum(mintstr,'yyyy-mm-dd HH:MM');
maxtstr = epoch2str(maxt,'%G %H:%M'); maxtnum = datenum(maxtstr,'yyyy-mm-dd HH:MM');
fprintf('earliest report: %s(%g)  latest report: %s(%g)\n',mintstr,mintnum,maxtstr,maxtnum);






function [dist_lim2,theta_lim2] = limitForThetaUndDistancePlot(dist,theta,setting)
% distances are only taken if they lie between the specified
% two limits and are applied on theta.
limval1 = setting.plot.azimuth.xlim(1);
limval2 = setting.plot.azimuth.xlim(2);

dist_lim = []; theta_lim = []; dist_lim2 = []; theta_lim2 = []; 
ind = find(dist(:)>=limval1);
dist_lim = dist(ind);
theta_lim = theta(ind);

ind = [];
ind = find(dist(:)<=limval2);
dist_lim2 = dist_lim(ind);
theta_lim2 = theta(ind);


