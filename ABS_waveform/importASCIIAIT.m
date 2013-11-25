function [dataA,setting,error] = importASCIIAIT(setting,whichcol)
%fprintf('[1] X1 Y1 Z1 X2 Y2 Z2 - read sensor xx \n');
error = 0;

tic;
fid = fopen(setting.ASCII.filename,'r');  

n = 0;
while(~feof(fid))
    tline = fgetl(fid);
    if(isempty(tline))
        continue;
    end
    switch whichcol
        case 1
            tmp1 = textscan(fid, '%f %f %f ', 'delimiter', ' ','commentStyle', '#');
            if numel(tmp1)>=3
                data1 = tmp1{1};
                data2 = tmp1{2};
                data3 = tmp1{3};
            end
        case 2
            tmp1 = textscan(fid, '%f %f %f %f %f %f ', 'delimiter', ' ','commentStyle', '#');
            if numel(tmp1)>=6
                data1 = tmp1{4};
                data2 = tmp1{5};
                data3 = tmp1{6};
            end
    end
    
end
fclose(fid);

t = toc;
disp(' ');
fprintf('Read %g lines from %s in %5.1f seconds.\n',n,setting.ASCII.filename,t);


dataA{1} = data1;
dataA{2} = data2;
dataA{3} = data3;

if isempty(data1) || isempty(data2) || isempty(data3)
    error = 1;
end
    
    
