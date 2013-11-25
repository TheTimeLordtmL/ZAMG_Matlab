function prnstring = printLastThreeEQs(EQlist3,setting)

if numel(EQlist3.timeflt)==0
  prnstring{1} = '';  
else
 for k=1:numel(EQlist3.timeflt)
   magtype = EQlist3.magtype(k);
   magval = EQlist3.ml(k);
   datetime = EQlist3.timestr(k);
   inull = EQlist3.inull(k);
   distkm = EQlist3.distancekm(k);
   evname = EQlist3.evname(k);
   iloc = EQlist3.ilocal(k);
   acc = EQlist3.accel(k);
   evid = EQlist3.evid(k);
   if numel(EQlist3.timeflt)==1
     magtype = magtype{1};
     evname = evname{1};
     datetime = datetime{1};
   end
   prnstring{k} = sprintf('%s %3.1f(%3.1f°) %s %4.0fkm %25s %4.1f° %6.2f cm/s² %10.0f\n',magtype{1},magval,inull,datetime{1},distkm,evname{1},iloc,acc*100,evid); 
 end    
end
