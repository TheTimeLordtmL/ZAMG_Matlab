function [datastructout] = replaceEvnameOutsideAustria2(datastruct,setting)
%replace evname outside from Austria (as long as the antelope-db bug exists)

datastructout = datastruct;

%get all cities within a rectangle
[placename,lat,lon] = findNearestCity2(setting);

%compare the eq-list and assigne the closest city
if ~isempty(placename) && ~isempty(lat) && ~isempty(lon)
    if ~isempty(datastruct)
        for k=1:numel(datastruct)
            curr_B = datastruct(k).origin.lat;
            curr_L = datastruct(k).origin.lon;
            
            
            %//sort by distance
            origlat = ones(numel(lat),1) * curr_B;
            origlon = ones(numel(lon),1) * curr_L;
            [s,a12,a21] = vdist(lat,lon,origlat,origlon);
            sdistkm = s/1000;
            mindist = min(sdistkm);
            ind = find(sdistkm==mindist);
            if numel(ind) > 1
                ind = ind(1);
            end
            %nearestCity.lat = lat(ind);
            %nearestCity.lon = lon(ind);
            %nearestCity.name = placename(ind);

            datastruct(k).evname = {placename(ind)};
        end
    end
end
disp(' ');