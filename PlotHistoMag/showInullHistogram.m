function showInullHistogram(timestr,inull,setting)
%show felt eqarthquake histogramm and compare to
% data from macroseimsic lists

years = zeros(numel(timestr),1);
for k=1:numel(timestr)
   curtimestr = timestr{k};  %09/04/1295   0:00:00.000
   curtimevec = datevec(curtimestr,'mm/dd/yyyy HH:MM:SS');
   years(k) = curtimevec(1);
end

[years_sort,ind] = sort(years);
inull_sort = inull(ind);

% read macroseismic list
[data] = readMacroTextFile(setting.felt.macroseismikfelstnumberfile);
fprintf('[ok] import %s: total felt EQs Austria(All)=%g(%g)  Years from %g to %g \n',setting.felt.macroseismikfelstnumberfile,sum(data(:,2)),sum(data(:,3)),min(data(:,1)),max(data(:,1)));

% plot the data

hist(years_sort,[min(years):max(years)]);
hold on;
plot(data(:,1),data(:,2),'or','MarkerFaceColor','y');

disp(' ');
 


function [data] = readMacroTextFile(fileinput)
%data= year,feltAT,felt
tic;
fid = fopen(fileinput,'r');  

p = 0; data = [];
while(~feof(fid))
    tline = fgetl(fid);
    if(isempty(tline))
        continue;
    end
    tmp1 = textscan(tline, '%d %d %d ','commentStyle','#');
    %#year  feltAT  felt
    %1981   22      25
    %1986   14      19
    %1995   16      19
    if numel(tmp1)>=3 && ~isempty(tmp1{1})
        p = p + 1;
        curr_1= tmp1{1};
        curr_2 = tmp1{2};
        curr_3 = tmp1{3};
        data(p,1) = curr_1;
        data(p,2) = curr_2;
        data(p,3) = curr_3;
    end
end
fclose(fid);

t = toc;
disp(' ');
fprintf('Read %g lines from %s in %5.1f seconds.\n',p,fileinput,t);

