function curTraceOut = getDisplacementfromVelocity(curTrace)
%use the velocity data to output displacement

%DataIn = DataIn - mean(DataIn);
contData = curTrace;
contTime = 1:numel(contData);
Data = cumtrapz(contTime - contTime(1), contData);
Data = detrend(Data);
curTraceOut = Data - mean(Data);
