function [error,numerror,setting] = detectIntersections(FeltEQ,setting)
% look for two or more events that were in the same time span
% and causes wrong EQ formular values.
error = 0;   numerror = 0; count_conflict = 0; setting.time.conflicts = 0; error_msg = '';
for k=1:numel(FeltEQ.timeflt)
    curr_timespan = FeltEQ.timespan(k);
    timestart(k) = FeltEQ.timeflt(k) - curr_timespan*60*60;
    timeend(k) = FeltEQ.timeflt(k) + curr_timespan*60*60;
end

eqproblem_flag = 0; error_count = 0 ;
fprintf('Time spans that cover more than 1 earthquake: [xx]..index number eq\n');
for k=1:numel(FeltEQ.timeflt)
     z = 0; events = []; events_ind = []; eventmag = []; eventmagtype = {''};
     for t=1:numel(FeltEQ.timeflt)
        if FeltEQ.timeflt(t)>=timestart(k) && FeltEQ.timeflt(t)<=timeend(k)
           z = z + 1;
           events(z) = FeltEQ.timeflt(t);
           events_ind(z) = t;     
           eventmag(z)= FeltEQ.ml(t); 
           %if numel(FeltEQ.timeflt)==1  %habe nur 1 Beben gefunden
           %  eventmagtype{z} = FeltEQ.magtype(t);
           %else
             tmp = FeltEQ.magtype(t);
             eventmagtype{z}= tmp{1}; 
           %end
        end
     end
     eqproblem_flag = 1;
     strevent = ''; strneu = ''; strind = ''; strcurr = ''; 
     if z > 1
         for g=1:size(events,2)
            strneu = epoch2str(events(g),'%G %H:%M:%S');
            strind = sprintf('[%g]',events_ind(g));
            strcurr = sprintf('%s %s',strind,strneu); 
            strevent = sprintf('%s %s',strevent,strcurr);
            strevent = sprintf('%s(%3.1f%s) %s',strevent,eventmag(g),eventmagtype{g});
            count_conflict = count_conflict + 1;
            setting.time.conflicts(count_conflict) = events_ind(g);             
         end
         error_count = error_count + 1 ;
         error_msg{error_count} = strevent;
         %fprintf('%s \n',strevent);
     end
end

if eqproblem_flag == 0
  fprintf('..not detected\n');
else
  error_msg = unique(error_msg);
  for h=1:numel(error_msg)
    fprintf('%s \n',error_msg{h});
  end
  disp(' ');
  b = input('Event time spans are ambigous! Abort the code? [y/n]\n','s');
  if ~isempty(b)
    if b=='y' || b=='Y'
       error = 1;  
    end
  end
  numerror = numel(error_msg);
  setting.time.conflicts = unique(setting.time.conflicts(:));  
end