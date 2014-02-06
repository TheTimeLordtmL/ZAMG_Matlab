function showSimpleHistplotEQList(setting,datastructhist)
% // show histogram of the EQ-List that is exported
% out= plz | numberstack | distance | azimuth | lat | lon
% / infoSelectEvent:
% /   {1}..Selected event [1] is on 2012-02-01  {2}..Magnitude: 3.2ml
% /   {3}..Location: Pitten 48.3332 16.4531  {4}..Reports: 234   evid: 522124    orid: 105475
% /   {5}..date  {6}..magnitude  {7}..location  {8}..curr_timespan  
% /   {9}..timeflt {10}..latitude  {11}..longitude

magval = setting.eqlist.minmag;

% // prepare the stacked PlZ locations
for k=1:size(datastructhist,2)
    mag(k) = datastructhist(k).netmag;
    lat(k) = datastructhist(k).origin.lat;
    lon(k) = datastructhist(k).origin.lon;
    orid(k) = datastructhist(k).orid;
    depth(k) = datastructhist(k).origin.depth;
    etype{k} = datastructhist(k).etype{1};
    inull(k) = datastructhist(k).inull;
    evid(k) = datastructhist(k).evid;
end

%// plot the data
scrsz = get(0,'ScreenSize');
figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height],'Name',setting.title);
set(gcf,'Color','w');
interval = 0.5;
intervaldepth = 1;

% / plot Magnitude or Intensity Histogram
subplot(2,2,1);   hold on;
if setting.eqlist.useinensities == 1
    intmin = fix(min(inull));  intmax= ceil(max(inull));
    intclass = [intmin:interval:intmax];    histstack = hist(inull,intclass);
    hist(inull,intclass);    set(gca,'fontsize',setting.fontsizeaxis);
    xlabel('Intensity','fontsize',setting.fontsize);
    xlim([intmin intmax]); 
    magintclass = intclass;
else
    magmin = fix(min(mag));  magmax= ceil(max(mag));
    magclass = [magmin:interval:magmax];    histstack = hist(mag,magclass);  
    hist(mag,magclass);    set(gca,'fontsize',setting.fontsizeaxis);
    xlim([magmin magmax]); 
    xlabel('Magnitude','fontsize',setting.fontsize);
    magintclass = magclass;
end
%title(setting.title,'fontsize',setting.fontsizetitle);
%xtickold = get(gca,'XTick'); ytickold = get(gca,'YTick');
%xtickvallabel = get(gca,'XTickLabel'); 
ylabel('Anzahl','fontsize',setting.fontsize);
clear xtickvallabel xtickold ytickold n;

% / plot E-Type Histogram
subplot(2,2,2);   hold on;
[b, m, n] = unique(etype);  
[anzahlEtypesB] = getEtypeHistogramData(n,b);
bar(anzahlEtypesB);  hold on;
xtickold = get(gca,'XTick'); ytickold = get(gca,'YTick');
xticknew = [0:numel(b)+1];     set(gca,'XTick',xticknew); 
for p=1:numel(b)
    xtickvallabel{p+1} = b{p};
end
xtickvallabel{1} = ' ';
xtickvallabel{numel(b)+2} = ' ';
set(gca,'XTickLabel',xtickvallabel,'fontsize',setting.fontsizeaxis);
xlim([0 numel(b)+1]); 
ylabel('Anzahl','fontsize',setting.fontsize);
xlabel('Etype','fontsize',setting.fontsize);
clear xtickvallabel xtickold ytickold n m b;

% / plot Depth Histogram
subplot(2,2,3);   hold on;
depthmin = fix(min(depth));  depthmax= ceil(max(depth));
depthclass = [depthmin:intervaldepth:depthmax];    histstackdepth = hist(depth,depthclass);
hist(depth,depthclass);    set(gca,'fontsize',setting.fontsizeaxis);
xlim([depthmin depthmax]);
set(gca,'fontsize',setting.fontsizeaxis);
ylabel('Anzahl','fontsize',setting.fontsize);
xlabel('Depth','fontsize',setting.fontsize);


plotHistogrammParameter(depthclass,intervaldepth,histstackdepth,'Depth');

if setting.eqlist.useinensities == 1
    plotHistogrammParameter(magintclass,interval,histstack,'Intensity');
else
    plotHistogrammParameter(magintclass,interval,histstack,'Magnitude');
end
disp(' ');




function plotHistogrammParameter(magclass,interval,histstack,strtypehisto)

strhead = ''; strcount = '';
stepsize = interval/2;
for k=1:numel(magclass)
    strhead = sprintf('%s   %3.1f-%3.1f',strhead,magclass(k)-stepsize,magclass(k)+stepsize);
    strcount = sprintf('%s   %7.0f',strcount,histstack(k));
end
fprintf('Histogramm of %s with bin size and number per bin \n ',strtypehisto);

fprintf('%s \n',strhead);
fprintf('%s \n',strcount);
