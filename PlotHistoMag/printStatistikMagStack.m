function [setting] = printStatistikMagStack(datastack,setting)

strmagmax =   'Max. Numbers/Class '; 
strmagclass = 'Magnitude Classes  ';
strmagval = 'Magnitude Values  ';
%string magnitude max
summag = 0;
for k=1:size(datastack,2)
    tmpstack = datastack(:,k);
    strmagmax = sprintf('%s      %4.0f',strmagmax,max(tmpstack));
    strmagval = sprintf('%s      %4.0f',strmagval,sum(tmpstack));
    summag = summag + sum(tmpstack);
end

%string magnitude classes
for g=1:numel(setting.stacks)
    alteMag = setting.stacks{g};
    if g >= numel(setting.stacks)
        strmagclass = sprintf('%s  M>=%3.1f',strmagclass,alteMag);
    else
        neueMag = setting.stacks{g+1};
        strmagclass = sprintf('%s  %3.1f<M<%3.1f',strmagclass,alteMag,neueMag);
    end
end
fprintf('%s   Summe\n',strmagclass);
fprintf('%s \n',strmagmax);
fprintf('%s   %g\n',strmagval,summag);
setting.statvalues{1}=strmagclass;
setting.statvalues{2}=strmagmax;
setting.statvalues{3}=strmagval;
setting.statvalues{4}=summag;
