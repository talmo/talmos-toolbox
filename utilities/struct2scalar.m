function S = struct2scalar(S, catfields)
%STRUCT2SCALAR Converts a structure array into a scalar struct.
% Usage:
%   S = struct2scalar(S)
% 
% Args:
%   S: structure array
%   catfields: concatenate fields of the structure (default: false)
%
% Returns:
%   S: scalar structure
% 
% See also: struct2cell, struct2table

if nargin < 2 || isempty(catfields); catfields = false; end

fns = fieldnames(S);
S = cell2struct(arr2cell(struct2cell(S),1),fns);

if catfields
    S = structfun(@cellcat,S,'uniformoutput',false);
end

end
