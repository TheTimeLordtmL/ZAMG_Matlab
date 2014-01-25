function [p,s,noise] = getPSnoiseDataFromTimeFrame(curTrace,setting,sps,ppicksamp,spicksamp)
%
% use time frames to output p,s,nosie data from currTrace.
% input: trace vector with noise, p-phase and s-phase signal
% sps..sample rate HZ
% ppicksamp..pick time p-phase (samples)
% spicksamp..pick time s-phase (samples)

% // get the noise data
if (ppicksamp/sps-setting.waveforms.tnoisesubtract) >= 0
    %noise can be reduced by setting.waveforms.tnoisesubtract value
    indmin = 1;  indmax = (ppicksamp-setting.waveforms.tnoisesubtract*sps);
else
    %noise ist too short and is taken as whole part
    %noise is taken from first sample to begin of P-wave onset
    indmin = 1;  indmax = ppicksamp;
end
if indmin>=1 && indmax<=size(curTrace,1)
    noise = curTrace(indmin:indmax);
else
    noise = [];
end


% // get the p-wave data
% is data larger as p-phase+p-window length?
if size(curTrace,1) >= (ppicksamp+setting.waveforms.tpwindowmax*sps)
    %p-phase has full length as specified in setting.waveforms.tpwindowmax
    indmin = ppicksamp;  indmax = ppicksamp+setting.waveforms.tpwindowmax*sps;
else
    %p-phase ist too short and is taken up to the end of the trace
    indmin = ppicksamp;  indmax = size(curTrace,1);
    fprintf('P-phase is too short and is taken up to the end of the trace (pick at %g samples, trc len=%g samples)\n',ppicksamp,size(curTrace,1));
end
if indmin>=1 && indmax<=size(curTrace,1)
    p = curTrace(indmin:indmax);
else
    p = [];
end


% // get the s-wave data
% is data larger as s-phase+s-window length?
if size(curTrace,1) >= (spicksamp+setting.waveforms.tswindowmax*sps)
    %s-phase has full length as specified in setting.waveforms.tpwindowmax
    indmin = spicksamp;  indmax = spicksamp+setting.waveforms.tswindowmax*sps;
else
    %s-phase is too short and is taken up to the end of the trace
    indmin = spicksamp;  indmax = size(curTrace,1);
    fprintf('S-phase is too short and is taken up to the end of the trace (pick at %g samples, trc len=%g samples)\n',spicksamp,size(curTrace,1));
end
if indmin>=1 && indmax<=size(curTrace,1)
    s = curTrace(indmin:indmax);
else
    s = [];
end



