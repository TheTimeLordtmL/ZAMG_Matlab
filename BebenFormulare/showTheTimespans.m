function showTheTimespans(FeltEQ,setting)
% show the event origin time with the timespan 
% and mark it if a time span conflict is detected.

for k=1:numel(FeltEQ.timeflt)
    suche = 0;
   for z=1:numel(setting.time.conflicts)
      if k==setting.time.conflicts(z)
          suche = 1;  k = numel(setting.time.conflicts);
      end
   end
   if suche == 1
     strstern = '*';
   else
     strstern = ''; 
   end  
   strtime = FeltEQ.timestr(k);
   fprintf('Event [%2.0f] %s: time span %5.2f (hours) %s\n',k,strtime{1},FeltEQ.timespan(k),strstern); 
end

disp(' ');