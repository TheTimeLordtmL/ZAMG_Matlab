function [data_out,datastruct_out,setting] = filterDataWithinPolygonShp(data,datastruct,setting,flag)
% flags: 'normal','reference','periodhist','periodseisgraph','periodlast20year'

%// Read and Mask the data points outside the polygon (*.shp)
tic;

% read the shape file
[shape] = shaperead(setting.useshape.LangrenzenPath);

% mask the data points outside the polygon
count_shapefile = size(shape,1);
for r=1:count_shapefile
    IND = find(~isnan(shape(r).X));
    shape(r).X = shape(r).X(IND);
    shape(r).Y = shape(r).Y(IND);
    curr_X = shape(r).X;
    curr_Y = shape(r).Y;
    
    % // suche alle grid punkte in einem shape-polygon
    IsInMask = inpolygon(data(:,3),data(:,2),curr_X,curr_Y);
    if numel(IsInMask)==1
       fprintf('Mask data to polygon failed. There is only 1 EQ inside the polygon!'); 
       newData{1} = data;
       newDatastruct{1} = datastruct;
    else
       newData{1} = data(IsInMask,:); 
       newDatastruct{1} = datastruct(IsInMask);
    end
end

data_out = []; datastruct_out = [];
for k=1:numel(newData)
    tmp = newData{k};
    data_out = [data_out;tmp];
    tmp2 = newDatastruct{k};
    datastruct_out = [datastruct_out tmp2];
end

%set a new counter and time min/max
setting.count = size(data,1);
if min(data(:,1)) < setting.from
    if strcmp(flag,'normal')
        setting.from = min(data(:,1));
    end
    if strcmp(flag,'reference')
        setting.fromref = min(data(:,1));
    end
end
if max(data(:,1)) > setting.to
    if strcmp(flag,'normal')
        setting.to = max(data(:,1));
    end
    if strcmp(flag,'reference')
        setting.toref = max(data(:,1));
    end
end
t = toc;
if strcmp(flag,'normal')
    setting.filter.reducednumberLandesgrenze = size(data,1)-size(data_out,1);
    setting.count = size(data_out,1);
    fprintf('Number of excluded data is %g for %g polygons from %s (%4.1f s).\n',setting.filter.reducednumberLandesgrenze,r,setting.useshape.LangrenzenPath,t);
end
if strcmp(flag,'reference')
    setting.filter.reducednumberLandesgrenzeref = size(data,1)-size(data_out,1);
    setting.countref = size(data_out,1);
    fprintf('Number of excluded dataref is %g for %g polygons from %s (%4.1f s).\n',setting.filter.reducednumberLandesgrenzeref,r,setting.useshape.LangrenzenPath,t);
end
if strcmp(flag,'periodhist')
    setting.filter.reducednumberLandesgrenzeref = size(data,1)-size(data_out,1);
    setting.countref = size(data_out,1);
    fprintf('Number of excluded periodhist is %g for %g polygons from %s (%4.1f s).\n',setting.filter.reducednumberLandesgrenzeref,r,setting.useshape.LangrenzenPath,t);
end
if strcmp(flag,'periodseisgraph')
    setting.filter.reducednumberLandesgrenzeref = size(data,1)-size(data_out,1);
    setting.countref = size(data_out,1);
    fprintf('Number of excluded periodseisgraph is %g for %g polygons from %s (%4.1f s).\n',setting.filter.reducednumberLandesgrenzeref,r,setting.useshape.LangrenzenPath,t);
end
if strcmp(flag,'periodlast20year')
    setting.filter.reducednumberLandesgrenzeref = size(data,1)-size(data_out,1);
    setting.countref = size(data_out,1);
    fprintf('Number of excluded periodlast20year is %g for %g polygons from %s (%4.1f s).\n',setting.filter.reducednumberLandesgrenzeref,r,setting.useshape.LangrenzenPath,t);
end


 