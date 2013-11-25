function [timestart,timeend] = getTimeSpanfromUserinput(setting)

timestart = setting.time.start;    timeend = setting.time.end;
fprintf('Enter the begin of the time span. e.g. %s \n',setting.time.start);
inp = input('>> Please select an option [q..quit]\n','s');
if ~strcmp(inp,'q')
    timestart = inp;
end

fprintf('Enter the end of the time span. e.g. %s \n',setting.time.end);
inp = input('>> Please select an option [q..quit]\n','s');
if ~strcmp(inp,'q')
    timeend = inp;
end




