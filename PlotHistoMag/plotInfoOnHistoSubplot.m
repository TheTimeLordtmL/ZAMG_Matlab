function plotInfoOnHistoSubplot(setting)
% plot some basic statistics and the filename
%Magnitude Classes    -1.0<M<0.5  0.5<M<1.0  1.0<M<1.5  1.5<M<2.0  M>=2.0   Summe
%Max. Numbers/Class         67        70        36        17         7 
%Magnitude Values         131       161        78        37        15   422
const = 5;
subplot(setting.InfoPlot.subM,setting.InfoPlot.subN,setting.InfoPlot.subP);
plot([0 100],[0 100],'.w');
axis off;


text(80,5,sprintf('end:   %s (%g)',setting.toexcact,setting.to),'FontSize',setting.fontsizeaxis-const);
text(80,25,sprintf('begin: %s (%g)',setting.fromexcact,setting.from),'FontSize',setting.fontsizeaxis-const);
text(80,55,sprintf('Network: %s',setting.filter.network),'FontSize',setting.fontsizeaxis-const);
text(80,75,sprintf('DB: %s',setting.filter.db),'FontSize',setting.fontsizeaxis-const);

switch setting.lokalsetting
    case 1  %   NormalHistplotmitMag(setting);
        text(0,95,sprintf('Data excluded: %g (%s)    %s: %g  events used: %g  events all: %g   file: %s',setting.filter.NumberEtypeExclude,setting.filter.excludedDataStr,setting.strtempres,setting.period.count,setting.count,setting.countold,setting.filepath),'FontSize',setting.fontsizeaxis-const);
        text(2,55,setting.statvalues{1},'FontSize',setting.fontsizeaxis-const);
        text(2,30,setting.statvalues{2},'FontSize',setting.fontsizeaxis-const);
        text(2,5,sprintf('%s   sum=%g',setting.statvalues{3},setting.statvalues{4}),'FontSize',setting.fontsizeaxis-const);
    case 2  %   NormalHistplotEQmitandere(setting);
        text(0,95,sprintf('%s: %g  events used: %g  events all: %g   file: %s',setting.strtempres,setting.period.count,setting.count,setting.countold,setting.filepath),'FontSize',setting.fontsizeaxis-const);
        text(0,75,sprintf('Data excluded #1: %g (%s)  ',setting.filter.NumberEtypeExclude1,setting.filter.excludedDataStr1),'FontSize',setting.fontsizeaxis-const);
        text(0,55,sprintf('Data excluded #2: %g (%s)  ',setting.filter.NumberEtypeExclude2,setting.filter.excludedDataStr2),'FontSize',setting.fontsizeaxis-const);
    case 3
        
end