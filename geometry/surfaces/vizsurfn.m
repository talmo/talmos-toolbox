function h = vizsurfn(S1, S2, varargin)
%VIZSURFN Visualize N surfaces
% Usage:
%   vizsurfn(S1, S2)
% 
% Args:
%   S1: 
%   S2: 
% 
% See also: vizsurf

S = {S1};
if nargin >= 2; S{end+1} = S2; end
if nargin >= 3; S = [S, varargin]; end
for i = 1:numel(S)
    if isstruct(S{i})
        S{i} = horz(num2cell(S{i}));
    end
end
S = cellcat(S,2);

alpha = 0.5;
n = numel(S);
colors = jet(n);

if isempty(get(groot,'CurrentFigure'))
    figure, figclosekey
end
hold on
h = cell1(n);
for i = 1:n
    h{i} = vizsurf(S{i},[],alpha,0,'facecolor',colors(i,:));
end

hasType = cellfun(@(s)isfield(s,'type'),S);
if any(hasType)
    if ~all(hasType)
        for i = find(~hasType)
            S{i}.type = sprintf('Mesh %d',i);
        end
    end
    
    types = cf(@(s)s.type,S);
    legend(cellcat(cf(@(x)x(1),h)),types,'Location','best')
end
if nargout < 1; clear h; end

end
