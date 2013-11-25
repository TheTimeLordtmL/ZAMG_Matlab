function  displayTheStatisticsWithRefPeriode(statisticsRef,statistics,setting)
% // display the statistics

fprintf('                          Reference periode (%g days)         Current periode (%g days)   \n',curr_ref.refperiod.daycounts,curr_stats.currperiod.daycounts);
fprintf('Geographic region         num   num/a  Macc/a         num(%%)          num/a(%%)     Macc/a (%%)  \n');
%        Polygon - Österreich       29     14     65           46(+159%)     46 (+317%)    101 (+155%)
for k=1:numel(statistics)
   curr_region = setting.statref.strgeogrregion{k};
   
   curr_stats = statistics{k};
   stat_count = curr_stats.currperiod.count;
   stat_counta = stat_count/curr_stats.currperiod.daycounts*365;
   stat_mlacc = curr_stats.currperiod.ml.accum;
   stat_mlacca = stat_mlacc/curr_stats.currperiod.daycounts*365;
  
   
   curr_ref = statisticsRef{k};
   ref_count = curr_ref.refperiod.count;
   ref_counta = ref_count/curr_ref.refperiod.daycounts*365;
   ref_mlacc = curr_ref.refperiod.ml.accum;
   ref_mlacca = ref_mlacc/curr_stats.currperiod.daycounts*365;
   fprintf('%-23s % 5g  %5.0f  %5.0f        % 5g(%+3.0f%%)  %5.0f (%+3.0f%%)  %5.0f (%+3.0f%%)\n',curr_region,ref_count,ref_counta,ref_mlacca,...
       stat_count,100/ref_count*stat_count,stat_counta,100/ref_counta*stat_counta,stat_mlacca,100/ref_mlacca*stat_mlacca);
%   fprintf('                    M%3.1f %s   M%3.1f %s\n',curr_ref.refperiod.maxevent.ml,curr_ref.refperiod.maxevent.timestr,curr_stats.currperiod.maxevent.ml,curr_stats.currperiod.maxevent.timestr);
end
disp(' ');




