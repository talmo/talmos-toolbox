function S = getfields(S, fields, varargin)
%GETFIELDS Return structure with the specified fields.
% Usage:
%   S = getfields(S, fields)
%   S = getfields(S, field1, field2, ...)
% 
% Args:
%   S: structure to index
%   fields: cell array of fieldnames to return
%   field1, field2, ...: fieldnames to return
% 
% Returns:
%   S: structure with the specified fields
%
% See also: getfield, varstruct

if ~iscell(fields); fields = {fields}; end
if nargin > 2; fields = [horz(fields), varargin]; end
fields = horz(fields);

vals = cf(@(x) S.(x), fields);

S = cell2struct(vals, fields, 2);

end
