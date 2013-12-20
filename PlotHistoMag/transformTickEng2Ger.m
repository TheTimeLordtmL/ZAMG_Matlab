function legstr=transformTickEng2Ger(legstr,setting)
%
for k=1:numel(legstr)
    switch setting.temporalresolution
        case 'd'
            tmp = legstr{k};
            [tmpleft,tmpright] = strtok(tmp, '.');
            tmpright = strtok(tmpright, '.');
            switch tmpright
                case 'May'
                    legstr{k} = sprintf('%s.Mai',tmpleft);
                case 'Oct'
                    legstr{k} = sprintf('%s.Okt',tmpleft);
                case 'Dec'
                    legstr{k} = sprintf('%s.Dez',tmpleft);
            end
    end
end