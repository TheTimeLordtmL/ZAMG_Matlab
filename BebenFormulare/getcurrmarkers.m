function [col0,line0,symb0] = getcurrmarkers(pin)

col0 = getcurrcolor(pin);
line0 = getcurrmarker(pin);
symb0 = getMarker(pin);



function  curr_marker = getcurrmarker(pin)
curr_marker = '-k';
switch pin
    case 1
        curr_marker = '-';
    case 2
        curr_marker = '--';
    case 3
        curr_marker = '-.';
    case 4
        curr_marker = ':';
    case 5
        curr_marker = '-';
    case 6
        curr_marker = '--';
    case 7
        curr_marker = '-.';
    case 8
        curr_marker = ':';
    case 9
         curr_marker = '--';
    case 10
         curr_marker = ':';
    case 11
        curr_marker = '-.';
end

function  curr_color = getcurrcolor(pin)
curr_color = [0.0,0.0,0.0];
switch pin
    case 1
        curr_color = [0.0,0.0,0.0];
    case 2
        curr_color = 'r';
    case 3
        curr_color = 'b';
    case 4
        curr_color = 'k';
    case 5
        curr_color = [0.8,0.8,0.8];
    case 6
        curr_color = [0.4,0.4,0.4]';
    case 7
        curr_color = [0.15,0.15,0.15];
    case 8
        curr_color = [0.0,0.0,0.0];
    case 9
        curr_color = [0.2,0.2,0.2];
    case 10
        curr_color = [0.6,0.6,0.6];
    case 11
        curr_color = [0.0,0.0,0.0];
end



function marker = getMarker(indexin)

marker = '<';
switch indexin
    case 1
        marker = 's';
    case 2
        marker = 'd';
    case 3
        marker = 'o';
    case 4
        marker = '+';
    case 5
        marker = '<';
end

