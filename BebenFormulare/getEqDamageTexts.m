function [schadenText] = getEqDamageTexts(ReportsIn,orilat,orilon,setting,indexnum)
% // get damage texts only for reports which are damaging
% vorbeben,nachbeben,schaden_dinge,wirkung_dinge,schaden_gebauede_txt,lddate,leichte_schaeden
%    1       2          3               4               5               6        7  
% maessige_schaeden,starke_schaeden,sehr_starke_schaeden,fid,plz,dist,loc
%        8                  9               10           11   12   13  14
[fidlistschaden,plz,dist,location,nodatafound] = getfidlistschaden(ReportsIn,orilat,orilon,setting,indexnum);
if nodatafound == 0
    [schadenText] = getDataDamageText(ReportsIn,setting,indexnum,fidlistschaden,plz,dist,location);
else
    fprintf('There were no damaging reports.\n');
    schadenText = [];
end



function [fidlistschaden,plz,dist,location,nodatafound] = getfidlistschaden(ReportsIn,orilat,orilon,setting,indexnum)
% // open db and get the data between min and maxFID

Reports =  ReportsIn;
fidlist = Reports(indexnum).fid;
infoEvent = setting.infoSelectEvent;

minfid = min(fidlist); %timestart = infoEvent{9} - infoEvent{8}*60*60;
maxfid = max(fidlist); %timeend =  infoEvent{9} + infoEvent{8}*60*60;

db = dbopen(setting.db.formular,'r');
dbextr = dblookup(db,'',setting.db.formulartable,'','');
str_querry1 = sprintf('fid >= %g && fid <= %g && damaging==''y''',minfid,maxfid);
dbformextr = dbsubset(dbextr,str_querry1);
n = dbnrecs(dbformextr);
if n>0
      [fidlistschadenunsort,plzunsort,lat,lon,locationunsort] = dbgetv(dbformextr,'fid','zip_input','lat','lon','place_input'); 
      nodatafound = 0;
else
    nodatafound = 1;
    fidlistschaden = []; plz = [];   dist = []; location = [];
end
dbclose(db); 

%sort after distance
if nodatafound == 0
    indtmp = find(lat>90|lat<-90);
    lat(indtmp) = 40.000;
    indtmp = find(lon>360|lon<-360);
    lon(indtmp) = 10.000;
    origlat = ones(numel(lat),1) * orilat;
    origlon = ones(numel(lon),1) * orilon;
    [s,a12,a21] = vdist(lat,lon,origlat,origlon);
    distunsort = s/1000;
    [dist,ind] = sort(distunsort,'ascend');
    fidlistschaden = fidlistschadenunsort(ind);
    plz = plzunsort(ind);
    location = locationunsort(ind);
end





function [schadentxt] = getDataDamageText(ReportsIn,setting,indexnum,fidlistschaden,plz,dist,location)
%damage texts from 'webform'

minfid = min(fidlistschaden); %timestart = infoEvent{9} - infoEvent{8}*60*60;
maxfid = max(fidlistschaden); %timeend =  infoEvent{9} + infoEvent{8}*60*60;

% // open db and get the data between min and maxFID
db = dbopen(setting.db.formular,'r');
dbextr = dblookup(db,'',setting.db.formulartable2,'','');
str_querry1 = sprintf('fid >= %g && fid <= %g && verspuert!=''n''',minfid,maxfid);
dbformextr = dbsubset(dbextr,str_querry1);
n = dbnrecs(dbformextr);
    
if n>0
   fprintf('..saving %g damage texts from %s. \n',n,setting.db.formulartable2);
   if setting.save.individualforms==1
      [vorbeben,nachbeben,schaden_dinge,wirkung_dinge,schaden_gebauede_txt,lddate,leichte_schaeden,maessige_schaeden,starke_schaeden,sehr_starke_schaeden,fid] = dbgetv(dbformextr,'vorbeben','nachbeben','schaden_dinge','wirkung_dinge','schaden_gebaeude_txt','lddate','leichte_schaeden','maessige_schaeden','starke_schaeden','sehr_starke_schaeden','fid');   
   end
end
dbclose(db); 

% // sort FID according to fidlist and assign the records.
% get new cell size
p = 0;
for k=1:numel(fidlistschaden)
    currfid = fidlistschaden(k);
    found = 0;  
    for m=1:numel(fid)
        if currfid==fid(m)
          found = 1;
          p = p + 1;
          break;
        end
    end
end
schadentxt = cell(p,14);

% sort FID and write cell
p = 0; found = 0; 
for k=1:numel(fidlistschaden)
    currfid = fidlistschaden(k);
    found = 0;  
    for m=1:numel(fid)
        if currfid==fid(m)
          found = 1;
          p = p + 1;
          %fprintf('%g\n',m)
          break;
        end
    end
    if found==1
        %querry all basic parameters or strings
        if  ~isempty(vorbeben)
            schadentxt{p,1} = vorbeben(m);
        else
            schadentxt{p,1} = '';
        end
        if  ~isempty(nachbeben)
            schadentxt{p,2} = nachbeben(m);
        else
            schadentxt{p,2} = '';
        end
        if  ~isempty(schaden_dinge)
            schadentxt{p,3} = schaden_dinge(m);
        else
            schadentxt{p,3} = '';
        end
        if  ~isempty(wirkung_dinge)
            schadentxt{p,4} = wirkung_dinge(m);
        else
            schadentxt{p,4} = '';
        end
        if  ~isempty(schaden_gebauede_txt)
            schadentxt{p,5} = schaden_gebauede_txt(m);
        else
            schadentxt{p,5} = '';
        end
        if  ~isempty(epoch2str(lddate,'%G %H:%M:%S'));
            schadentxt{p,6} = epoch2str(lddate(m),'%G %H:%M:%S');
        else
            schadentxt{p,6} = '';
        end
        if  ~isempty(leichte_schaeden);
            schadentxt{p,7} = leichte_schaeden(m);
        else
            schadentxt{p,7} = '';
        end
        if  ~isempty(maessige_schaeden)
            schadentxt{p,8} = maessige_schaeden(m);
        else
            schadentxt{p,8} = '';
        end
        if  ~isempty(starke_schaeden)
            schadentxt{p,9} = starke_schaeden(m);
        else
            schadentxt{p,9} = '';
        end
        if  ~isempty(sehr_starke_schaeden)
            schadentxt{p,10} = sehr_starke_schaeden(m);
        else
            schadentxt{p,10} = '';
        end
        if  ~isempty(fid)
            schadentxt{p,11} = fid(m);
        else
            schadentxt{p,11} = '';
        end
        if  ~isempty(plz(k))
            schadentxt{p,12} = plz(k);
        else
            schadentxt{p,12} = '';
        end
        if  ~isempty(dist(k))
            schadentxt{p,13} = dist(k);
        else
            schadentxt{p,13} = '';
        end
        schadentxt{p,14} = location(k);
        if  ~isempty(location(k))
            schadentxt{p,14} = location(k);
        else
            schadentxt{p,14} = '';
        end
       %art_erschuetterung_all{k} = cell2mat(art_erschuetterung(foundfid)); %r..ruck s..schwanken z..zittern     
    end
end








