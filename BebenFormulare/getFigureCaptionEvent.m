function figcaption = getFigureCaptionEvent(FeltEQ,Reports,indexnum)

figname = FeltEQ.timestr(indexnum);  evname = FeltEQ.evname(indexnum); ml = FeltEQ.ml(indexnum);
evtype = FeltEQ.etype(indexnum); magtype = FeltEQ.magtype(indexnum); 
figcaption = sprintf('%s %s (%3.1f%s) - %g reports (%s)',figname{1},evname{1},ml,magtype{1},Reports(indexnum).formcounts,evtype{1});

