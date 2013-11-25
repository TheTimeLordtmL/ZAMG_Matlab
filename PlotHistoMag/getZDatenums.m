function [zdatenum,zdatstr,interval] = getZDatenums(setting)
% get lists of the datum strings that are stacked
%  afterwards. e.g. 1999 2000 2001 ..
%        or    1999/01 1999/02 1999/03 ..
zdatenum = []; zdatstr = []; interval = 1;
switch setting.temporalresolution
    case 'j'
        interval = 365;
        zdatenum=fix(setting.from):interval:ceil(setting.to);
        zdatstr = datestr(zdatenum,'yyyy');
        zdatenum = datenum(zdatstr,'yyyy');    
    case 'm'
        interval = 14;
        zdatenum=fix(setting.from):interval:ceil(setting.to);
        zdatstr = datestr(zdatenum,'mm/yyyy');
        zdatenum = datenum(zdatstr,'mm/yyyy');
        interval = 30.5;
    case 'd'
        interval = 1;
        zdatenum=fix(setting.from):interval:ceil(setting.to);
        zdatstr = datestr(zdatenum,'dd/mm/yyyy');
        zdatenum = datenum(zdatstr,'dd/mm/yyyy');
    case 'h'
        interval = 1/24;
        zdatenum=fix(setting.from):interval:ceil(setting.to);
        zdatstr = datestr(zdatenum,'dd/mm/yyyy HH');
        zdatenum = datenum(zdatstr,'dd/mm/yyyy HH');
end