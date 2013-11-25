function settingout = getAmplitudeStationsManually(setting)

settingout = setting;
%bad eisenkappel 2013-02-02 13h
[settingout] = addStationwithAmplitudecmpers(settingout,'KEKA','HLZ','HLN','HLE',+1.2,-2.4,+1.6);

% stationHL{1}='BITA'; chnHL{1} = 'HLZ';
% stationHL{2}='OBSA'; chnHL{2} = 'HLN';
% stationHL{3}='SVKA'; chnHL{3} = 'HLE';
% stationHL{4}='KEKA';
% stationHL{5}='ADSA';
% stationHL{6}='WOTA';
% stationHL{7}='RSNA';
% stationHL{8}='RWNA';
% stationHL{9}='LFVA';
% stationHL{10}='DFSA';
% stationHL{11}='DKSA';
% stationHL{12}='SVKA';
% stationHL{13}='SKTA';
% stationHL{14}='SPTA';
% stationHL{15}='OBKA';
% stationHL{16}='KBA';
% stationHL{17}='WTTA';
% 
% 
% stationHN{1}='ABSI'; chnHN{1} = 'HNZ';
% stationHN{2}='ABTA'; chnHN{2} = 'HNN';
% stationHN{3}='BOSI'; chnHN{3} = 'HNE';
% stationHN{4}='CONA';
% stationHN{5}='FETA';
% stationHN{6}='KBA';
% stationHN{7}='KOSI';
% stationHN{8}='MOSI';
% stationHN{9}='MYKA';
% stationHN{10}='RETA';
% stationHN{11}='WTTA';
% stationHN{12}='RISI';
% stationHN{13}='ROSI';
% stationHN{14}='SOKA';
% stationHN{15}='UMWA';
% stationHN{16}='KMWA';
% stationHN{17}='SNWA';
% stationHN{18}='WIWA';
% stationHN{19}='ZAWA';
% stationHN{20}='BGWA';
% stationHN{21}='ZETA';
% stationHN{22}='NATA';
% stationHN{23}='FRTA';
% 
% stationHH{1}='SITA'; chnHH{1} = 'HHZ';
% stationHH{2}='PUBA'; chnHH{2} = 'HHN';
% stationHH{3}='GUWA'; chnHH{3} = 'HHE';
% stationHH{4}='ALBA';
% stationHH{5}='MARA';
% stationHH{6}='KRUC';
% stationHH{7}='KHC';
% stationHH{8}='MORC';
% stationHH{9}='DAVA';
% stationHH{10}='ARSA';
% stationHH{11}='KBA';
% stationHH{12}='OBKA';
% stationHH{13}='CONA';
% stationHH{14}='MOA';


function [setting] = addStationwithAmplitudecmpers(settingin,station,chn1,chn2,chn3,va1,va2,va3)
%write acc or vel cm/s2 cm/s to settings

setting = settingin;

%setting.unit.factor = 1;

currrecords = settingin.manuallStationsRecords + 1;
setting.manuallStations(currrecords).val1 = va1;
setting.manuallStations(currrecords).val2 = 0;
setting.manuallStations(currrecords).units1 = 'cm/s';
setting.manuallStations(currrecords).units2 = 'cm/s';
setting.manuallStations(currrecords).sta = station;
setting.manuallStations(currrecords).chan = chn1;

currrecords = currrecords + 1;
setting.manuallStations(currrecords).val1 = va2;
setting.manuallStations(currrecords).val2 = 0;
setting.manuallStations(currrecords).units1 = 'cm/s';
setting.manuallStations(currrecords).units2 = 'cm/s';
setting.manuallStations(currrecords).sta = station;
setting.manuallStations(currrecords).chan = chn2;

currrecords = currrecords + 1;
setting.manuallStations(currrecords).val1 = va3;
setting.manuallStations(currrecords).val2 = 0;
setting.manuallStations(currrecords).units1 = 'cm/s';
setting.manuallStations(currrecords).units2 = 'cm/s';
setting.manuallStations(currrecords).sta = station;
setting.manuallStations(currrecords).chan = chn3;

setting.manuallStationsRecords = currrecords;
