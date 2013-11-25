function plotAccelerationDistance(stations,origin,setting)

%get stations per channel Hl*, HN*, HH*
[statHL,statHN,statHH] = splitStationChannelsToHnHlHh(stations,origin,setting);

[out] = showdistancePlot1(statHL,statHN,statHH,stations,origin,setting);
disp(' ');




function [out] = showdistancePlot1(statHL,statHN,statHH,stations,origin,setting)
out = [];

valmarker = setting.plot.valmarker1;

figure;  hold on;

%show all Komponents
subplot(3,1,1);  hold on;
if numel(statHL.val1cm(:)) > 0
    semilogy(statHL.distkmlist(:),abs(statHL.val1cm(:)),'ko','MarkerSize',valmarker,'MarkerFaceColor','r');
    if setting.plot.plotstatnames == 1
        station_text = statHL.sta(:);
        text(statHL.distkmlist(:),abs(statHL.val1cm(:)),station_text);
    end
else
    fprintf('No data found for channel HL.  (show all Komponents)\n'); 
end
if numel(statHN.val1cm(:)) > 0
    semilogy(statHN.distkmlist(:),abs(statHN.val1cm(:)),'ks','MarkerSize',valmarker,'MarkerFaceColor','b');
    if setting.plot.plotstatnames == 1
        station_text = statHN.sta(:);
        text(statHN.distkmlist(:),abs(statHN.val1cm(:)),station_text);
    end    
else
    fprintf('No data found for channel HN. (show all Komponents) \n');
end
if numel(statHH.val1cm(:)) > 0
    semilogy(statHH.distkmlist(:),abs(statHH.val1cm(:)),'bd','MarkerSize',valmarker,'MarkerFaceColor','g');
    if setting.plot.plotstatnames == 1
        station_text = statHH.sta(:);
        text(statHH.distkmlist(:),abs(statHH.val1cm(:)),station_text);
    end    
else
    fprintf('No data found for channel HH. (show all Komponents) \n');
end
legend('HL.','HN.','HH.',3);  ylabel('ZNE (cm/s-2)');
%[cparam] = solvemodellItaly(setting,statHL.val1cm(:),statHN.val1cm(:),statHH.val1cm(:));

%show Z Komponents
subplot(3,1,2);  hold on;
ind = findZKomponents(statHL,'HLZ');
if numel(statHL.val1cm(ind)) > 0
    semilogy(statHL.distkmlist(ind),abs(statHL.val1cm(ind)),'ko','MarkerSize',valmarker,'MarkerFaceColor','r');
    if setting.plot.plotstatnames == 1
        station_text = statHL.sta(ind);
        text(statHL.distkmlist(ind),abs(statHL.val1cm(ind)),station_text);
    end
else
    fprintf('No data found for channel HL. (show Z Komponents) \n'); 
end
ind = findZKomponents(statHN,'HNZ');
if numel(statHN.val1cm(ind)) > 0
    semilogy(statHN.distkmlist(ind),abs(statHN.val1cm(ind)),'ks','MarkerSize',valmarker,'MarkerFaceColor','b');
    if setting.plot.plotstatnames == 1
        station_text = statHN.sta(ind);
        text(statHN.distkmlist(ind),abs(statHN.val1cm(ind)),station_text);
    end    
else
    fprintf('No data found for channel HN.  (show Z Komponents)\n');
end
ind = findZKomponents(statHH,'HHZ');
if numel(statHH.val1cm(ind)) > 0
    semilogy(statHH.distkmlist(ind),abs(statHH.val1cm(ind)),'bd','MarkerSize',valmarker,'MarkerFaceColor','g');
    if setting.plot.plotstatnames == 1
        station_text = statHH.sta(ind);
        text(statHH.distkmlist(ind),abs(statHH.val1cm(ind)),station_text);
    end    
else
    fprintf('No data found for channel HH. (show Z Komponents) \n');
end
legend('HL.','HN.','HH.',3);  ylabel('Z (cm/s-2)');
clear ind;

%show max horizontal Komponent
subplot(3,1,3);  hold on;
ind = findmaximalHorizontalKomponent(statHL,'HLN','HLE');
if numel(statHL.val1cm(ind)) > 0
    semilogy(statHL.distkmlist(ind),abs(statHL.val1cm(ind)),'ko','MarkerSize',valmarker,'MarkerFaceColor','r');
    if setting.plot.plotstatnames == 1
        station_text = statHL.sta(ind);
        text(statHL.distkmlist(ind),abs(statHL.val1cm(ind)),station_text);
    end
else
    fprintf('No data found for channel HL. (show max horizontal Komponent) \n'); 
end
ind = findmaximalHorizontalKomponent(statHN,'HNN','HNE');
if numel(statHN.val1cm(ind)) > 0
    semilogy(statHN.distkmlist(ind),abs(statHN.val1cm(ind)),'ks','MarkerSize',valmarker,'MarkerFaceColor','b');
    if setting.plot.plotstatnames == 1
        station_text = statHN.sta(ind);
        text(statHN.distkmlist(ind),abs(statHN.val1cm(ind)),station_text);
    end    
else
    fprintf('No data found for channel HN.  (show max horizontal Komponent)\n');
end
ind = findmaximalHorizontalKomponent(statHH,'HHN','HHE');
if numel(statHH.val1cm(ind)) > 0
    semilogy(statHH.distkmlist(ind),abs(statHH.val1cm(ind)),'bd','MarkerSize',valmarker,'MarkerFaceColor','g');
    if setting.plot.plotstatnames == 1
        station_text = statHH.sta(ind);
        text(statHH.distkmlist(ind),abs(statHH.val1cm(ind)),station_text);
    end    
else
    fprintf('No data found for channel HH. (show max horizontal Komponent) \n');
end
legend('HL.','HN.','HH.',3);  ylabel('max NE (cm/s-2)');
clear ind;

disp(' ');




function [statHL,statHN,statHH] = splitStationChannelsToHnHlHh(stations,origin,setting)
% use station and chn list to constrain HL., HN., HH. channels

stationHL{1}='BITA'; chnHL{1} = 'HLZ';
stationHL{2}='OBSA'; chnHL{2} = 'HLN';
stationHL{3}='SVKA'; chnHL{3} = 'HLE';
stationHL{4}='KEKA';
stationHL{5}='ADSA';
stationHL{6}='WOTA';
stationHL{7}='RSNA';
stationHL{8}='RWNA';
stationHL{9}='LFVA';
stationHL{10}='DFSA';
stationHL{11}='DKSA';
stationHL{12}='SVKA';
stationHL{13}='SKTA';
stationHL{14}='SPTA';
stationHL{15}='OBKA';
stationHL{16}='KBA';
stationHL{17}='WTTA';


stationHN{1}='ABSI'; chnHN{1} = 'HNZ';
stationHN{2}='ABTA'; chnHN{2} = 'HNN';
stationHN{3}='BOSI'; chnHN{3} = 'HNE';
stationHN{4}='CONA';
stationHN{5}='FETA';
stationHN{6}='KBA';
stationHN{7}='KOSI';
stationHN{8}='MOSI';
stationHN{9}='MYKA';
stationHN{10}='RETA';
stationHN{11}='WTTA';
stationHN{12}='RISI';
stationHN{13}='ROSI';
stationHN{14}='SOKA';
stationHN{15}='UMWA';
stationHN{16}='KMWA';
stationHN{17}='SNWA';
stationHN{18}='WIWA';
stationHN{19}='ZAWA';
stationHN{20}='BGWA';
stationHN{21}='ZETA';
stationHN{22}='NATA';
stationHN{23}='FRTA';

stationHH{1}='SITA'; chnHH{1} = 'HHZ';
stationHH{2}='PUBA'; chnHH{2} = 'HHN';
stationHH{3}='GUWA'; chnHH{3} = 'HHE';
stationHH{4}='ALBA';
stationHH{5}='MARA';
stationHH{6}='KRUC';
stationHH{7}='KHC';
stationHH{8}='MORC';
stationHH{9}='DAVA';
stationHH{10}='ARSA';
stationHH{11}='KBA';
stationHH{12}='OBKA';
stationHH{13}='CONA';
stationHH{14}='MOA';

for k=1:numel(stations.sta)
    currsta = stations.sta(k);
    currchn = stations.chan(k);
    indHH(k) = isStaFound(stationHH,chnHH,currsta,currchn);
    indHL(k) = isStaFound(stationHL,chnHL,currsta,currchn);
    indHN(k) = isStaFound(stationHN,chnHN,currsta,currchn);
end
statHL = reduceArrayHLNH(stations,logical(indHL));
statHN = reduceArrayHLNH(stations,logical(indHN));
statHH = reduceArrayHLNH(stations,logical(indHH));



function statout = reduceArrayHLNH(stations,ind)

statout.timeflt = stations.timeflt(ind);
statout.timestr = stations.timestr(ind);
statout.timefltmeas = stations.timefltmeas(ind);
statout.timestrmwas = stations.timestrmwas(ind);
statout.lat = stations.lat(ind);
statout.lon = stations.lon(ind);
statout.val1 = stations.val1(ind);
statout.val2 = stations.val2(ind);
statout.val1cm = stations.val1cm(ind);
statout.val2cm = stations.val2cm(ind);
statout.units1 = stations.units1(ind);
statout.units2 = stations.units2(ind);
statout.sta = stations.sta(ind);
statout.chan = stations.chan(ind);
statout.distkmlist = stations.distkmlist(ind);
statout.azimlist = stations.azimlist(ind);





function  flag = isStaFound(station,chn,currsta,currchn)
flag = 0;

for p=1:numel(station)
    if  strcmp(station{p},currsta)
        if strcmp(currchn,chn{1}) || strcmp(currchn,chn{2}) || strcmp(currchn,chn{3})
            flag = 1;
            break;
        end
    end
end




function ind = findZKomponents(statArr,strChan)
ind = zeros(numel(statArr.val1cm(:)),1);

for k=1:numel(statArr.val1cm(:))
    currchan = statArr.chan(k);
    currchanstr = currchan{1};
    if strcmp(currchanstr,strChan)==1
        ind(k) = 1;
    end
end
ind = logical(ind);




function ind = findmaximalHorizontalKomponent(statArr,strChan1,strChan2)
ind = zeros(numel(statArr.val1cm(:)),1);

for k=1:numel(statArr.val1cm(:))
    currstation = statArr.sta(k);
    currstationstr = currstation{1};
    indstat = [];  e = 0;  valstat = [];
    for j=1:numel(statArr.val1cm(:))
        %find all stations with this name
        curr2stat = statArr.sta(j);
        curr2statstr = curr2stat{1};
        if strcmp(curr2statstr,currstationstr)==1
            currchan = statArr.chan(j);
            currchanstr = currchan{1};
            if strcmp(currchanstr,strChan1)==1 || strcmp(currchanstr,strChan2)==1
                e = e + 1;
                indstat(e) = j;
                valstat(e) = abs(statArr.val1cm(j));
                
            end
        end
    end
    [maxval,indmax] = max(valstat);
    if ~isempty(indmax)
        ind(indstat(indmax)) = 1;
    end
end
ind = logical(ind);
