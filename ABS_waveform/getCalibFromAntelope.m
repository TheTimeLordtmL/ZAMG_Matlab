function [setting] = getCalibFromAntelope(setting)
%// get db querry strings
strstation = sprintf('%s',setting.station); 

% connect to Antelope DB for the calib
for z=1:numel(setting.comp)
    db = dbopen(setting.db.calib,'r');
    dbextr = dblookup(db,'','calibration','','');
    curr_component = setting.comp{z};   %'HNZ';
    strcomponents = sprintf('chan==''%s''',curr_component);
    str_querry1 = sprintf('sta==''%s'' && %s',strstation,strcomponents);
    dbtimextr = dbsubset(dbextr,str_querry1);
    n = dbnrecs(dbtimextr);
    if n > 0
        [sta,chan,calib,units] = dbgetv(dbtimextr,'sta','chan','calib','units');
        setting.calib{z} = calib;
    end
    fprintf('..%s  %s found with a calib of %8.2f (%s)\n',strstation,curr_component,calib,units);
end