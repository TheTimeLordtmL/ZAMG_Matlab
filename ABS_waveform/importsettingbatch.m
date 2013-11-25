function  [n,data] = importsettingbatch(setting)

tic;
fid = fopen(setting.exportASCII.settingBatchfile,'r');  

n = 0;
while(~feof(fid))
    tline = fgetl(fid);
    if(isempty(tline))
        continue;
    end
    tmp1 = textscan(fid, '%s %s %s %s %s', 'delimiter', ',','commentStyle', '#');
    if numel(tmp1)>=4
        n = numel(tmp1{1});
        data.typ = tmp1{1};
        data.station = tmp1{2};
        data.comp1 = tmp1{3};
        data.comp2 = tmp1{4};
        data.comp3 = tmp1{5};
    else
        n= 0;
        data = [];
    end
end
fclose(fid);

t = toc;
disp(' ');
fprintf('Read %g lines from %s in %5.1f seconds.\n',n,setting.exportASCII.settingBatchfile,t);








