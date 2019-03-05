function S = ws2struct(varargin)
%WS2STRUCT Returns a structure with the current workspace variables.
% Usage:
%   S = ws2struct
%   S = ws2struct('a*') % only variables starting with 'a'
%
% Args: same as who
%
% Note: this function automatically excludes the 'ans' variable
% 
% See also: who, wsvars, varstruct

varnames = wsvars(varargin{:});

isAns = strcmp(varnames,'ans');
varnames = varnames(~isAns);

args = strjoin(varnames,',');
S = evalin('base',['varstruct(' args ')']);

end
