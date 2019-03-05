function varnames = wsvars(varargin)
%WSVARS Returns variable names in the base workspace.
% Usage:
%   varnames = wsvars
%   varnames = wsvars('a*') % only variables that start with a
% 
% See also: who, evalin

args = '';
if nargin > 0
    args = strcat('''', varargin(:), '''');
    args = strjoin(args,',');
end

varnames = evalin('base', ['who(' args ')']);

end
