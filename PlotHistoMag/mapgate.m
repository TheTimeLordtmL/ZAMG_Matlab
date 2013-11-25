function varargout = mapgate(varargin)
%MAPGATE Gateway routine to call private functions.
%   MAPGATE is used to access private functions. 
%
%   FHNDL = MAPGATE(FCN) returns the function handle.
%
%   [OUT1, OUT2,...] = MAPGATE(FCN, VAR1, VAR2,...) calls FCN in
%   MATLABROOT/toolbox/map/map/private with input arguments
%   VAR1, VAR2,... and returns the output, OUT1, OUT2,....

%   Copyright 2003-2011 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2011/05/17 02:12:04 $

error(nargchk(1, Inf, nargin, 'struct'))
if nargin == 1 && nargout == 1
    % FHNDL = MAPGATE(FCN)
    varargout{1} = str2func(varargin{1});
else
    % [OUT1, OUT2,...] = MAPGATE(FCN, VAR1, VAR2,...)
    if nargout==0,
        feval(varargin{:});
    else
        [varargout{1:nargout}] = feval(varargin{:});
    end
end
%#function geoReservedNames getprojdirs checkrefmat checkrefvec 
