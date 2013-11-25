function Data = getAccelerationfromVelocity(DataIn)
%use the velocity data to output acceleration
%Differentation

DataIn = DataIn - mean(DataIn);
Data = diff(DataIn)/(1/1);    % Numerical Differentiation (dy/dx).
Data(end+1) = 0;                         % Add a zero to the end to keep the same tracelength.
Data = Data - mean(Data);