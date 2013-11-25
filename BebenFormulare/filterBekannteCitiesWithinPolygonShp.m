function [data_out] = filterBekannteCitiesWithinPolygonShp(data,shapefile)
%// Read and Mask the data points outside the polygon (*.shp)

% read the shape file
[shape] = shaperead(shapefile);

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
       data1.lat = data(IsInMask).lat;
       data1.lon = data(IsInMask).lon;
       data1.name = {data(IsInMask).name};
    else
       data1.lat = data.lat(IsInMask);
       data1.lon = data.lon(IsInMask);
       data1.name = data.name(IsInMask);      
    end
    newData{r} = data1;
end

data_out = [];
for k=1:1
    tmp = newData{k};
    data_out = [data_out;tmp];
end



