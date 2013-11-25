function EQlistsort = replaceEvnameOutsideAustria(EQlistsort,setting)
%replace evname outside from Austria (as long as the antelope-db bug exists)

for k=1:numel(EQlistsort.timeflt)
curr_B = EQlistsort.lat(k);
curr_L = EQlistsort.lon(k);

%is inside austria?
isinside = isinsideAustria(curr_B,curr_L,setting);

%replace the string
  if isinside==0
      [nearestCity,isinsideTable] = findNearestCity(curr_B,curr_L,setting);
      if isinsideTable > 0
          old = EQlistsort.evname(k);
          new = nearestCity.name;
          fprintf('Location name changed from %s to %s.\n',old{1},new{1});
          EQlistsort.evname(k) = nearestCity.name;
      end
  end
end

disp(' ');