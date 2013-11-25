

function [m] = getMaxMfromData(numdata,countvertical)
% maximale spaltenanzahl für plot
m = 1;

if numdata > countvertical*1
    % zb. 7
    if numdata > countvertical*2
        % zb. 13
        if numdata > countvertical*3
            m = 4;
        else
            m = 3;
        end
    else
        m = 2;
    end
else
    % zb. 3
    m = 1;
end
