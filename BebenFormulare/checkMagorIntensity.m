function  val = checkMagorIntensity(ml,inull,depth,timeflt,type)
val = zeros(numel(ml),1);
emptyvals = 0;
korrvals = 0;

switch type
    case 'ml'
       for p=1:numel(ml)
          % Compute Magnitude from inull
          val(p) = ml(p);
          if (isempty(ml(p)) || isempty(inull(p))) && (~isempty(ml(p)) && ~isempty(inull(p)))
             korrvals = korrvals + 1; 
             fprintf('Ml estimated for event %s by the value of ',epoch2str(timeflt(p),'%G %H:%M:%S'));
             val(p) = 2.33*log10(depth(p)+0.67*inull(p)-2); 
             fprintf('%5.2f using I0=%4.1f \n',val(p),inull(p));
          else
              if isempty(ml(p)) && isempty(inull(p))
                emptyvals = emptyvals + 1; 
                fprintf('I0 and Ml are emtpy for event on %s \n ',epoch2str(timeflt(p),'%G %H:%M:%S'));    
              end
          end
       end
    case 'inull'
       for p=1:numel(ml)
          % Compute inull from Magnitude
          val(p) = inull(p);
          if (isempty(ml(p)) || isempty(inull(p))) && (~isempty(ml(p)) && ~isempty(inull(p)))
             korrvals = korrvals + 1; 
             fprintf('I0 estimated for event %s by the value of ',epoch2str(timeflt(p),'%G %H:%M:%S'));
             val(p) = 1.5*(ml(p)-2.33*log10(depth(p))+2);
             fprintf('%4.1f using Ml=%5.2f \n',inull(p),val(p));
          else
              if isempty(ml(p)) && isempty(inull(p))
                 emptyvals = emptyvals + 1; 
                 fprintf('I0 and Ml are emtpy for event on %s \n ',epoch2str(timeflt(p),'%G %H:%M:%S')); 
              end   
          end
       end
end

if emptyvals>0 || korrvals>0
   fprintf('[warning]  korrvals=%g    emptyvals=%g',korrvals,emptyvals); 
end