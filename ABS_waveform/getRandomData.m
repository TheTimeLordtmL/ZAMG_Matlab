function [dataV,dataA,setting] = getRandomData(setting)
setting.samplerate{1} = 100; setting.samplerate{2} = 100; setting.samplerate{3} = 100;
freq1 = 26;  %hz 
freq2 = 10;  %hz

data{1} = rand(32000,1);
data{2} = rand(32000,1);
data{3} = rand(32000,1);

%generate two samped sine waves 
t1 = zeros(32000,1); t2 = t1;
t1(8000:13999,1) = (1:6000)/1000';  t1(6501:8000,1) = fliplr((1:1500)/1000');
tmp1 = exp(-0.65.*t1).*sin(2*pi()*freq1.*t1);
t2(19000:27999) = (1:9000)/1000'; t2(16001:19000,1) = fliplr((1:3000)/1000');
tmp2 = exp(-0.4.*t2).*sin(2*pi()*freq2.*t2);
tmpadd = tmp1 + tmp2;

if setting.intitialunit == 'V'
    dataV{1} = data{1}./2.5 + tmpadd;
    dataV{2} = data{2}./1.5 + tmpadd;
    dataV{3} = data{3}./2.0 + tmpadd;
    dataA = [];
end
if setting.intitialunit == 'A'
    dataA{1} = data{1}./2.5 + tmpadd;
    dataA{2} = data{2}./1.5 + tmpadd;
    dataA{3} = data{3}./2.0 + tmpadd;
    dataV = [];
end
