function getBebenFormulareATBeben()
% search earthquake formulars (reports) and stack them 
% to month or years. The data are directly read from the
% specified db. 
setting = getSettings();

fprintf('[1] Search reports for Earthquakes(fe)\n');       
fprintf('[2] Search reports for Other Events (-, km, sm, etc.)\n');      
fprintf('[3] Show all significant EQ''s for a user specified area\n');
fprintf('[4] Show all significant EQ''s for a City (''bekannte Orte'')\n');
fprintf('[5] Show all Events for a City - constrained by time (Wiederkehrperiode,n)\n');
inp = input('>> Please enter your selection [q..quit]\n','s');
fprintf('[q] quit \n');
if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
   switch str2num(inp)
       case 1
          setting.db.etype = 'eq';
          searchEQreportsAndShowStatistics(setting);  
       case 2
          setting.db.etype = 'other';  
          searchEQreportsAndShowStatistics(setting);            
       case 3
          [B,L] = showSignificantEQsThisEvent([],setting,'user');   
       case 4
          [B,L] = showSignificantEQsThisEvent([],setting,'cities');  
       case 5
          setting.sigEQsManuell.filenameout = setting.sigEQsManuellTimespan.filenameout;
          [B,L] = showSignificantEQsThisEvent([],setting,'allEventscities'); 
          inpF = input('Do you want to show EQfrequencies (Häuffigkeit, Wiederkehrintervall)? [y/n]\n','s');
          if isnumeric(str2num(inpF)) && ~strcmp(inpF,'q')
              if inpF=='y' || inpF=='Y'
                 showSignificantEQsFrequency(setting,B,L);
              end
          end
   end
end 


    










