function [data_out,setting] = filterFeltEQWithinPolygonShp(data,setting)
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
    IsInMask = inpolygon(data.lon(:),data.lat(:),curr_X,curr_Y);
    if numel(IsInMask)==1
       data1.timeflt = data(IsInMask).timeflt;
       data1.lat = data(IsInMask).lat;
       data1.lon = data(IsInMask).lon;
       data1.ml = data(IsInMask).ml;
       data1.etype = {data(IsInMask).etype};
       data1.evname = {data(IsInMask).evname};
       data1.magtype = {data(IsInMask).magtype};
       data1.auth = {data(IsInMask).auth};
       data1.evid = data(IsInMask).evid;
       data1.orid = data(IsInMask).orid;
       data1.timestr = {data(IsInMask).timestr};
       data1.timespan = data(IsInMask).timespan;
    else
       data1.timeflt = data.timeflt(IsInMask);
       data1.lat = data.lat(IsInMask);
       data1.lon = data.lon(IsInMask);
       data1.ml = data.ml(IsInMask);
       data1.etype = data.etype(IsInMask);
       data1.evname = data.evname(IsInMask);
       data1.magtype = data.magtype(IsInMask);
       data1.auth = data.auth(IsInMask);
       data1.orid = data.orid(IsInMask);
       data1.evid = data.evid(IsInMask);
       data1.timestr = data.timestr(IsInMask);
       data1.timespan = data.timespan(IsInMask);       
    end
    newData{r} = data1;
end

data_out = [];
for k=1:1
    tmp = newData{k};
    data_out = [data_out;tmp];
end

%set a new counter and time min/max
setting.datacountfilt = numel(data.timeflt);
if min(data.timeflt) < setting.time.from
  setting.time.from = min(data.timeflt);
end
if max(data.timeflt) > setting.time.to
  setting.time.to = max(data.timeflt);
end
t = toc;

fprintf('.. apply a spatial filter for %s. ',setting.useshape.name);
fprintf('The number of excluded data is %g for %g polygons from %s (%4.1f s).\n',(setting.datacountorig-setting.datacountfilt),r,setting.useshape.LangrenzenPath,t);
disp(' ');
