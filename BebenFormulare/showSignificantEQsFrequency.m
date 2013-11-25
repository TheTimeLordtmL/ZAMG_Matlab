function showSignificantEQsFrequency(setting,B,L)
% // reoccurance interval for Iloc
[EQlistInull] = getEQsWithINULLobserved(setting,B,L);
[EQlistInull] = filterEQsInullForDistance(EQlistInull,setting);
[Ilocal,EQ3listLocal] = showIlocalFrequency(EQlistInull,setting,B,L);

% // reoccurance interval for Mag
%[EQlistMag] = getEQsWithMagLobserved(setting,B,L);
%[EQlistMag] = filterEQsMagForDistance(EQlistMag,setting);
%[m0,m1,MagInt,EQ3listMag] = showIlocalFrequency(EQlistInull,setting);

writeEQFrequency(Ilocal,EQ3listLocal,setting);
printFrequencyRelations(Ilocal,setting);

 
 %[EQlistMag] = getEQsWithMAGobserved(setting,B,L);

function [Iloc,EQlisten] = showIlocalFrequency(EQlistInull,setting,B,L)
% // Fit Logarithmic     
[InullN,InullInt] = hist(EQlistInull(:).inull,setting.logNJahr.minIntensityplot:0.5:setting.logNJahr.maxIntensityplot);
InullN = InullN(2:numel(InullN));    InullInt = InullInt(2:numel(InullInt)); 
[IlocalN,IlocalInt] = hist(EQlistInull(:).ilocal,setting.logNJahr.minIntensityplot:0.5:setting.logNJahr.maxIntensityplot);
IlocalN = IlocalN(2:numel(IlocalN));    IlocalInt = IlocalInt(2:numel(IlocalInt));
mintime = min(EQlistInull.timeflt(:));    maxtime = max(EQlistInull.timeflt(:));
mintimestr = epoch2str(mintime,'%G');     maxtimestr = epoch2str(maxtime,'%G');
timeinterval = (maxtime-mintime)/(60*60*24*365);
fprintf('%6.1f years of data found lasting from %s to %s \n',timeinterval,mintimestr,maxtimestr); 

[b0,b1] = fitLogarithmic((IlocalN./timeinterval),IlocalInt);
 bilocal = b0 + b1 * IlocalInt;
 %figure;
 %semilogy(IlocalInt,IlocalN./timeinterval,'ro');
 %hold on;
 %semilogy(IlocalInt,10.0.^bilocal,'-.r');
 
%bdosa1 = 2.7-0.061*InullInt;
bdosaWien = -1.65+0.61*InullInt;
bdosaWien = 10.^bdosaWien;    bdosaWien = 1./bdosaWien; bdosaWien = log10(bdosaWien);
  
% // show the reoccurance interval and the three largest Iloc-Earthquakes
%    per Intensity-class
 fprintf('log(N/Jahre) = %+5.3f  %+5.3f * Iloc \n',b0,b1);
 p = 0;
 for j=3:7
   p = p + 1;
   [EQlistfor3] = getlatestEQsbyIntensity(setting,B,L);  
   [EQlist3] = filterEQsForIlocal(EQlistfor3,setting,j); EQlisten{p} = EQlist3;
   prnstring1 = sprintf('Intensität: %3.0g   Wiederkehrperiode %5.0f Jahre \n',j,1/(10^(b0 + b1 * j)));
   prnstring2 = printLastThreeEQs(EQlist3,setting);
   fprintf('%s',prnstring1);
   for k=1:numel(prnstring2)  
     fprintf('%s',prnstring2{k});
   end
 end
 
 
Iloc.b0 = b0;  Iloc.b1 = b1;  Iloc.IlocalInt = IlocalInt;   Iloc.reoccurance = IlocalN./timeinterval;

disp(' '); 



function [a0,a1] = fitLogarithmic(dataY,dataX)
a0 = []; a1 = [];
y = log10(dataY)';
A = [ones(numel(dataX),1) dataX'];

ind = ~isinf(y);
y = y(ind);  A = A(ind,:);
%b1 = ( ~InullN./timeinterval)';
%B1 = [ones(numel(InullInt),1) InullInt'];
x = lscov(A,y);

a0 = x(1);
a1 = x(2);




function printFrequencyRelations(Ilocal,setting)

%b0,b1,IlocalInt

%bdosa1 = 2.7-0.061*IlocalInt;
bdosaWien = -1.65+0.61*Ilocal.IlocalInt;
bilocal = Ilocal.b0 + Ilocal.b1 * Ilocal.IlocalInt;

figure('Position',[setting.src.left setting.src.bottom setting.src.width setting.src.height]);
% // plot log(N/Jahr)
subplot(2,1,1);
semilogy(Ilocal.IlocalInt,Ilocal.reoccurance,'ro','markersize',8,'linewidth',3);
hold on; grid on;
%semilogy(IIlocal.IlocalInt,10.0.^bdosaWien,'-b','linewidth',3);
semilogy(Ilocal.IlocalInt,10.0.^bilocal,'-.r','linewidth',3);
ylabel('log(N/Jahre)');   xlabel('Intensität (lokal)');
legend('standort (observed)','standort (model)');

% // plot reoccurance interval
subplot(2,1,2);
%bdosaWien = -1.65+0.61*Ilocal.InullInt;
%bstandort = 10.^bilocal;    bstandort = 1./bstandort; bstandort = log10(bstandort);

bdosaInnsbruck = -2.97+0.78*Ilocal.IlocalInt; %bdosaInnsbruck = 10.^bdosaInnsbruck;    bdosaInnsbruck = 1./bdosaInnsbruck; bdosaInnsbruck = log10(bdosaInnsbruck);
bdosaBregenz = -1.57+0.63*Ilocal.IlocalInt; %bdosaBregenz = 10.^bdosaBregenz;   bdosaBregenz = 1./bdosaBregenz; bdosaBregenz = log10(bdosaBregenz);
bdosaLeoben = -2.37+0.69*Ilocal.IlocalInt; %bdosaLeoben = 10.^bdosaLeoben;    bdosaLeoben = 1./bdosaLeoben; bdosaLeoben = log10(bdosaLeoben);
bdosaLinz = -1.73+0.73*Ilocal.IlocalInt; %bdosaLinz = 10.^bdosaLinz;    bdosaLinz = 1./bdosaLinz; bdosaLinz = log10(bdosaLinz);
bilocalR = 10.^bilocal;    bilocalR = 1./bilocalR; bilocalR = log10(bilocalR);

semilogy(Ilocal.IlocalInt,10.0.^bilocalR,'-.rd','markersize',8,'linewidth',3);
%semilogy(Ilocal.IlocalInt,10.0.^bdosaWien,'-b');
hold on; grid on;
semilogy(Ilocal.IlocalInt,10.0.^bdosaInnsbruck,'-ko','linewidth',2);
semilogy(Ilocal.IlocalInt,10.0.^bdosaBregenz,':ko','linewidth',2);
semilogy(Ilocal.IlocalInt,10.0.^bdosaLeoben,'-bx');
semilogy(Ilocal.IlocalInt,10.0.^bdosaLinz,':bx');
ylabel('reoccurance interval (Jahre)');   xlabel('Intensität (lokal)');
legend(sprintf('Standort R=%g km',setting.logNJahr.distmax),'Innsbruck (DOSA)','Bregenz (DOSA)','Leoben (DOSA)','Linz (DOSA)');

disp(' ');




