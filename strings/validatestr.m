function [idx, exception] = validatestr(str, validStrings, varargin)
%VALIDATESTR Returns the first index of the string in the array of valid strings or 0 if not found.
% Same as validatestring but does not produce error.
%
% Usage:
%   idx = validatestr(str,validStrings)
%   idx = validatestr(str,validStrings,argIndex)
%   idx = validatestr(str,validStrings,funcName)
%   idx = validatestr(str,validStrings,funcName,varName)
%   idx = validatestr(str,validStrings,funcName,varName,argIndex)
%   [idx, exception] = validatestr(...)
%
% See also: validatestring, instr, strcmp, strfind

try
    validStr = validatestring(str, validStrings, varargin{:});
    idx = find(strcmp(validStrings, validStr), 1);
catch exception
    idx = 0;
end
end

