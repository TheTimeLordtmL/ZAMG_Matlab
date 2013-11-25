function [HistPLzDist,HistName] = StackPLZtoHistogramm(OneReport)
% stack the plz and outout it sorted by the distance
% out= plz | numberstack | distance | azimuth | lat | lon  | damages

dist = OneReport.distkmlist(:);
plz = str2double(OneReport.zip_input(:));
name = OneReport.place_input(:); 
azim = OneReport.azimlist(:); 
lat = OneReport.lat(:); 
lon = OneReport.lon(:); 
dam = OneReport.damaging(:); 

%sortiere nach plz
for k=1:OneReport.formcounts
  tmp = num2str(dist(k));
  tmp2 = num2str(azim(k));
  tmp3 = num2str(lat(k));
  tmp4 = num2str(lon(k));
  tmp5 = num2str(dam(k));
  tmp6 = num2str(plz(k));
  distcell{k} = tmp;
  azimcell{k} = tmp2;
  latcell{k} = tmp3;
  loncell{k} = tmp4;
  damcell{k} = tmp5;
  plzcell{k} = tmp6;
end
distcell = distcell';
azimcell = azimcell';
latcell = latcell';
loncell = loncell';
damcell = damcell';
plzcell = plzcell';

A = sortrows([plzcell distcell azimcell latcell loncell damcell name],1);
plz = A(:,1); dist = A(:,2);   azim = A(:,3);  
lat = A(:,4); lon = A(:,5);  dam = A(:,6);  name = A(:,7); 

%stack the plz data
plzunique = unique(plzcell);
plz_num = str2double(plz);
p = 0;
HistPLzDist = zeros(numel(plzunique),3);
for k=1:numel(plzunique)
    ind = [];
    currplz = plzunique(k);
    currplz_num = str2num(currplz{1});
    if ~isempty(currplz_num) && ~isnan(currplz_num)
        %fprintf('%g \n',currplz_num)
        p = p + 1;
        %       if p==35
        %           disp(' ');
        %       end
        if numel(currplz_num) > 1
            %wrong PLZ detected
            p = p - 1;
        else
            ind = find(plz_num==currplz_num);  %suche refernz PLZ um alle anderen PLZ's zu stapeln
            %curr_arrplz = plz(ind);
            HistPLzDist(p,1) = currplz_num;
            HistPLzDist(p,2) = numel(ind);
            distcell = dist(ind(1)); latcell = lat(ind(1));
            azimcell = azim(ind(1)); loncell = lon(ind(1));
            HistPLzDist(p,3) = str2double(distcell{1});
            HistPLzDist(p,4) = str2double(azimcell{1});
            HistPLzDist(p,5) = str2double(latcell{1});
            HistPLzDist(p,6) = str2double(loncell{1});
            HistPLzDist(p,7) = stackthedamages(dam,ind);
            namecell = name(ind(1));
            HistName{p} = namecell{1};
        end
    end
end
HistPLzDist = HistPLzDist(1:p,:);

%sortiere nach Orte etc. nach Epizentraldistanz
HistName = HistName';
A = sortrows([num2cell(HistPLzDist) HistName],3);
HistPLzDist = cell2mat(A(:,1:7)); HistName = A(:,8);

fprintf('StackPLZtoHistogramm: %g Meldungen(numel(plz), %g Unique PLZ, %g HistPLZDist(size,1))\n',numel(plz),numel(unique(plz)),size(HistPLzDist,1));



function damvals = stackthedamages(cellin,index)

damvals = 0;
for k=1:numel(index)
    curr_damindex = index(k);
    tmp = str2double(cellin{curr_damindex});
    if tmp == 1
        damvals = damvals + 1;
    end
end







