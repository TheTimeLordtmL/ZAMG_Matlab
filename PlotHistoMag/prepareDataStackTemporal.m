function [numbers,seismoment,interval] = prepareDataStackTemporal(data,setting)
numbers = [];   seismoment = [];  interval = [];

switch setting.temporalresolution
    case 'j'
        interval = 365;
        zdatenum = str2num(datestr(data(:,6),'yyyy'));
    case 'm'
        interval = 12;
        zdatenum = str2num(datestr(data(:,6),'mm'));
    case 'd'
        interval = 31;
        zdatenum = str2num(datestr(data(:,6),'dd'));
    case 'h'
        interval = 24;
        zdatenum = str2num(datestr(data(:,6),'HH'));
end

[sortzdatenum,ind] = sort(zdatenum,'ascend');
datasort = data(ind,:);
clear ind;

numbers = zeros(interval,1);  seismoment = numbers; 
for p=1:interval
    ind2 = find(sortzdatenum==p);
    if ~isempty(ind2)
        curr_data = datasort(ind2,:);
        numbers(p) = size(curr_data,1);
        curr_moment = 10.^(1.5.*curr_data(:,5)+9.1);
        seismoment(p) = sum(curr_moment);      
    else
        numbers(p) = 0;
        seismoment(p) = 0;
    end  
end


