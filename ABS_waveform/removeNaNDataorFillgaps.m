function [dataV,dataA,setting] = removeNaNDataorFillgaps(dataV,dataA,setting)

if setting.intitialunit == 'V'
    val1 = [];     val2 = [];    val3 = [];
    for z=1:numel(setting.comp)
        switch z
            case 1
                val1 = dataV{1};
            case 2
                val2 = dataV{2};
            case 3
                val3 = dataV{3};
        end
    end
    
    [vout1,vout2,vout3,absDataBValues] = removegapsNaN(val1,val2,val3);
    
    dataV{1} = vout1;
    dataV{2} = vout2;
    dataV{3} = vout3;   
end

if setting.intitialunit == 'A'
    val1 = [];     val2 = [];    val3 = [];
    for z=1:numel(setting.comp)
        switch z
            case 1
                val1 = dataA{1};
            case 2
                val2 = dataA{2};
            case 3
                val3 = dataA{3};
        end
    end
    [vout1,vout2,vout3,absDataBValues] = removegapsNaN(val1,val2,val3);
    dataA{1} = vout1;
    dataA{2} = vout2;
    dataA{3} = vout3;
end
setting.absDataBValues = absDataBValues;
fprintf(' - -');




function  [vout1,vout2,vout3,absDataBValues] = removegapsNaN(val1,val2,val3)
vout1 = val1;    vout2 = val2;    vout3 = val3;
index.begin1 = 1;      index.begin2 = 10;  gapcount = 0;
absDataBValues.from = 1;        absDataBValues.to = numel(vout1);

% the average value is computed from each sample, but not from NaN or inf sample
%   the mean value is below used instead of NaN or Inf vals!!
ind = find(vout1~=Inf & vout1~=nan);   mean1 = mean(val1(ind));
ind = find(vout2~=Inf & vout2~=nan);   mean2 = mean(val2(ind));
ind = find(vout3~=Inf & vout3~=nan);   mean3 = mean(val3(ind));

% // show if begin is empty or if end is empty on all traces
% begin is empty
if val1(1)==Inf && val2(1)==Inf && val3(1)==Inf
    %when do the data begin at all 3 components?
    [begin1,begin2,begin3] = getDatabegin(vout1,vout2,vout3);
    %reduce data by earliest data begin
    index.size1 = numel(vout3);
    if begin1==begin2 && begin2==begin3
        index.begin1 = begin1;
    else
        index.begin1 = min([begin1 begin2 begin3]);
        vout1(index.begin1:begin1) = mean1;
        vout2(index.begin1:begin2) = mean2;
        vout3(index.begin1:begin3) = mean3; 
        fprintf('[remove empty data]: the three components might start at different samples - gap at the beginning\n');
    end
    gapcount = gapcount + 1;
    vout1 = vout1(index.begin1:numel(vout1));
    vout2 = vout2(index.begin1:numel(vout2));
    vout3 = vout3(index.begin1:numel(vout3));
    %indexAbs(gapcount).from = 1;
    %indexAbs(gapcount).to = index.begin1;
    absDataBValues.from = index.begin1;
    absDataBValues.to = index.size1;
end
% end is empty

if val1(numel(val1))==Inf && val2(numel(val2))==Inf && val3(numel(val3))==Inf
    %when do the data end at all 3 components?
    [begin1,begin2,begin3] = getDatabegin(flipud(vout1),flipud(vout2),flipud(vout3));
    begin1 = numel(vout1) - begin1 + 1;
    begin2 = numel(vout2) - begin2 + 1;
    begin3 = numel(vout3) - begin3 + 1;
    %reduce data after latest data section
    index.size2 = numel(vout3);
    if begin1==begin2 && begin2==begin3
        index.begin2 = begin1;
    else
        index.begin2 = max([begin1 begin2 begin3]);
        vout1(begin1:index.begin2) = mean1;
        vout2(begin2:index.begin2) = mean2;
        vout3(begin3:index.begin2) = mean3;
        fprintf('[remove empty data]: the three components might start at different samples - gap at the end\n');
    end
    gapcount = gapcount + 1;
    vout1 = vout1(1:index.begin2);
    vout2 = vout2(1:index.begin2);
    vout3 = vout3(1:index.begin2);
    if gapcount > 1
        %indexAbs(gapcount).from = index.begin2 + indexAbs(gapcount-1).to;
        %indexAbs(gapcount).to = index.size2 + indexAbs(gapcount-1).to;    
        absDataBValues.to = absDataBValues.from + index.begin2;
    else
        %indexAbs(gapcount).from = index.begin2;
        %indexAbs(gapcount).to = index.size2;
        absDataBValues.from = 1;
        absDataBValues.to = index.begin2;
    end
end


% // Each samples which is Nan or Inf is changed to the mean value from
%    above
ind = find(vout1==Inf & vout1==nan);
if  ~isempty(ind)
    vout1(ind) = mean1;
    fprintf('removed %g NaN''s or Inf''s . . 1 \n',numel(ind));
end
ind = find(vout2==Inf & vout2==nan);
if  ~isempty(ind)
    vout2(ind) = mean2;
    fprintf('removed %g NaN''s or Inf''s . . 2 \n ',numel(ind));
end
ind = find(vout3==Inf & vout3==nan);
if  ~isempty(ind)
    vout3(ind) = mean3;
    fprintf('removed %g NaN''s or Inf''s . . 3 \n ',numel(ind));
end

%ind = find(val~=Inf & val~=nan); mean1 = mean(val(ind));
%ind2 = find(val==Inf & val==nan); val(ind2) = mean1;

% plot(dataA{1})
 
 
 
 
 
function [begin1,begin2,begin3] = getDatabegin(vout1,vout2,vout3)
%output the ealiest sample with data
ind = find(vout1~=Inf & vout1~=nan);   begin1 = min(ind);
ind = find(vout2~=Inf & vout2~=nan);   begin2 = min(ind);
ind = find(vout3~=Inf & vout3~=nan);   begin3 = min(ind);







