function isinside = isinsideAustria(B,L,setting)
isinside = 0;
shapefilenumber = 0;    %Austria polygon
[shapefile,shapename] = getShapeFileInfos(shapefilenumber);
shapefile = fullfile(pwd,'shp',shapefile);

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
    IsInMask = inpolygon(L,B,curr_X,curr_Y);
    if IsInMask==1
      isinside = 1;     
    end
end


