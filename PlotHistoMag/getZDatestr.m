function [zdatstring,interval] = getZDatestr(setting)
interval = 1;
switch setting.temporalresolution
    case 'j'
        zdatstr0 = 'yyyy'; zdatstr1 = ''; zdatestr2 = ''; zdatestr3 = '';
    case 'm'
        zdatstr0 = 'mmm'; zdatstr1 = ''; zdatestr2 = ''; zdatestr3 = '';
    case 'd'
        interval = 1;
        zdatstr0 = 'dd.mmm'; zdatstr1 = ''; zdatestr2 = ''; zdatestr3 = '';
    case 'h'
        interval = 1/24;
        zdatstr0 = 'dd.mm'; zdatstr1 = 'HH'; zdatestr2 = ' '; zdatestr3 = 'h';
end
zdatstring{1} = zdatstr0;
zdatstring{2} = zdatstr1;
zdatstring{3} = zdatestr2;
zdatstring{4} = zdatestr3;