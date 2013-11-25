function [FeltEQ,setting] = getEventswithCharacteristicMagnitude(FeltEQIn,setting)
%parse all records and take only records with either ml/mw/ms/mb

FeltEQ = []; count = 0;
for k=1:numel(FeltEQIn.timeflt)
    currevid = FeltEQIn.evid(k);
    [evidfound,evind] = getIsEvidFound(FeltEQ,currevid);
    if evidfound == 0
        % add the record to FeltEQ
        count = count + 1;
        FeltEQ.timeflt(count) = FeltEQIn.timeflt(k);
        FeltEQ.lat(count) = FeltEQIn.lat(k);
        FeltEQ.lon(count) = FeltEQIn.lon(k);
        FeltEQ.ml(count) = FeltEQIn.ml(k);
        FeltEQ.etype(count) = FeltEQIn.etype(k);
        FeltEQ.magtype(count) = FeltEQIn.magtype(k);
        FeltEQ.evname(count) = FeltEQIn.evname(k);
        FeltEQ.auth(count) = FeltEQIn.auth(k);
        FeltEQ.orid(count) = FeltEQIn.orid(k);
        FeltEQ.evid(count) = FeltEQIn.evid(k);
        FeltEQ.timestr(count) = FeltEQIn.timestr(k);
        FeltEQ.timespan(count) = FeltEQIn.timespan(k);        
    end
    if evidfound == 1
        % add or change the magnitude value
        tmp1 = FeltEQ.magtype(evind); magtyp_old = tmp1{1};  clear tmp1;
        magval_old = FeltEQ.ml(evind); 
        tmp2 = FeltEQIn.magtype(k);  magtyp_new = tmp2{1}; clear tmp2;
        magval_new = FeltEQIn.ml(k);
        if magval_old < -2 & magval_new > -2
           %set to the new values
           FeltEQ.magtype(evind) = {magtyp_new};
           FeltEQ.ml(evind) = magval_new;
        else
           %   'ml' 'ms' 'mb'
           if magtyp_old=='mb' & (magtyp_new=='ms' | magtyp_new=='ml') & magval_new > -2
              FeltEQ.magtype(evind) = {magtyp_new};
              FeltEQ.ml(evind) = magval_new;   
           end
          if magtyp_old=='ms' & magtyp_new=='ml'  & magval_new > -2
              FeltEQ.magtype(evind) = {magtyp_new};
              FeltEQ.ml(evind) = magval_new;               
          end
        end
    end
end
setting.datacountorig = numel(FeltEQ.timeflt);
setting.time.from = min(FeltEQ.timeflt);
setting.time.to = max(FeltEQ.timeflt);etting.datacountorig = numel(FeltEQ.timeflt);






function [evidfound,ind] = getIsEvidFound(FeltEQ,currevid)
evidfound = 0;
ind = 0;

if ~isempty(FeltEQ)
   for k=1:numel(FeltEQ.timeflt)
       evid = FeltEQ.evid(k);
       if evid == currevid
           evidfound = 1;
           ind = k;
           break;
       end
   end
end






