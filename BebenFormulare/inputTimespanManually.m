
function FeltEQ = inputTimespanManually(FeltEQ,setting)
% use input to manually set some values
% for the time span - event based

%for k=1:numel(FeltEQ.timeflt)
%    fprintf('[%g] %s \n',k,FeltEQ.timestr(k));
%end
inp = 'Y';
while inp ~= 'q'
    inp = input('Please enter an index number to change the event-based time span [q..quit]\n','s');
    if isnumeric(str2num(inp)) && inp ~= 'q'
      timeval = input('Enter the time span (in hours) [q..quit]\n','s');
        if isnumeric(str2num(timeval))
           FeltEQ.timespan(str2num(inp)) = str2num(timeval);
        end
    end
end