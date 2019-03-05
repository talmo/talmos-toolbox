function M = mergesurfs(S, varargin)
%MERGESURFS Description
% Usage:
%   M = mergesurfs(S)
% 
% Args:
%   S: 
% 
% See also: 

if isstruct(S); S = {S}; end
if nargin >= 2; S = [S, varargin]; end
for i = 1:numel(S)
    if isstruct(S{i})
        S{i} = horz(num2cell(S{i}));
    end
end
S = cellcat(S);

nodes = cf(@(x)x.node,S);
elems = cf(@(x)x.elem,S);

M = struct('node',nodes{1},'elem',elems{1});
for i = 2:numel(S)
    [M.node,M.elem] = mergemesh(M.node,M.elem,nodes{i},elems{i});
end

end
