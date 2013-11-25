function searchEQreportsAndShowStatistics(setting)
% search earthquake formulars (reports) and stack them 
% to month or years. The data are directly read from the
% specified db.
%   
[FeltEQ,setting] = getAllFeltEvents(setting);
[FeltEQ,setting] = getEventswithCharacteristicMagnitude(FeltEQ,setting);

% plot data within Landesgrenzen (see getSetting.m)
if setting.useshape.useLandgrenzen == 1;   
    [FeltEQ,setting] = filterFeltEQWithinPolygonShp(FeltEQ,setting);
else
    fprintf('No data were excluded with a spatial filter.\n');
    setting.datacountfilt = setting.datacountorig;
end

%Read and apply corrections for the time spans from csv file
[FeltEQ,setting] = applyTimeSpanCorrections(FeltEQ,setting);

%replace evname outside from Austria (as long as the antelope-db bug exists)
FeltEQ = replaceEvnameOutsideAustria(FeltEQ,setting);

%Detect if events intersect with the time span
[error,numerror,setting] = detectIntersections(FeltEQ,setting);
%showTheTimespans(FeltEQ,setting);  %show the actual time spans

if error ~= 1  
  %enter the time spans manually
  if numerror > 0
      inp = input('Do you want to manually change the event-based time spans? [y/n]\n','s');
      if inp == 'y' || inp == 'Y'
         FeltEQ = inputTimespanManually(FeltEQ,setting);
      end
  end
  
  %Search all reports for the felt earthquakes
  if setting.useshape.useLandgrenzen==1
     fprintf('Search all reports for the %g earthquakes located within %s \n in DB %s (%s). \n',setting.datacountfilt,setting.useshape.name,setting.db.formulartable,setting.db.formular);
  else
     fprintf('Search all reports for the %g earthquakes in DB %s (%s). \n',setting.datacountfilt,setting.db.formulartable,setting.db.formular);
  end
  [Reports,setting] = getEqReports(FeltEQ,setting);                 %basic & matrix parameters from 'webform_extract'
  writeEQReports(setting,Reports,FeltEQ);

  if setting.save.individualforms == 1
    HistPLzDist = []; HistName = [];   infoSelectEvent = ' ';   setting.infoSelectEvent = ' ';
    inp = input('Do you want to view the details for one event? [y/n]\n','s');
    if inp == 'y' || inp == 'Y'
        inp = input('Please enter the event number [q..quit]\n','s');
        if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            setting.curreventid = str2num(inp);
            while inp ~= 'q'
              fprintf('[1] Print Reports grouped by PLZ (Number/location of reports) \n');
              fprintf('[2] Print Reports interpreted by EMS98 (Human,Object,DamageTexts,KML) - need to run [1] first \n');
              fprintf('[3] Plot 4 specified Parameters (R,S,T,X) \n');
              fprintf('[4] Show significant EQ''s for this area\n');
              fprintf('[q] quit \n');
              inp = input('Please enter your selection [q..quit]\n','s');
              if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
                  switch str2num(inp)
                      case 1
                          [HistPLzDist,HistName,infoSelectEvent,setting] = plotSingleEvent(Reports,FeltEQ,setting);
                      case 2
                          if setting.plotSingleEvent.IsApplied == 0
                              fprintf('[warning]: You may need to run [1] Plot SingleEvent first. \n');
                          end
                          plotIndividualReportParameters(Reports,FeltEQ,setting,HistPLzDist,HistName,infoSelectEvent);
                      case 3
                       %MELDUNGEN PER BUNDESLAND
                      case 4
                        showSignificantEQsThisEvent(FeltEQ,setting,'auto');                     
                       %ETC:
                  end
              end
            end
        end
    end  
  else
      fprintf('   >> end of operations as setting.save.individualforms = 0. \n');
  end
  %plot events,reports and time span
  %plot event + abfall der Meldungen mit Zeit
end    
