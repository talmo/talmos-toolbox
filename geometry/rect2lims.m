function [xlims, ylims] = rect2lims(rect)
%RECT2LIMS Convert [x y width height] to [xmin xmax], [ymin ymax].
% Usage:
%   lims = rect2lims(rect) % [xmin xmax ymin ymax]
%   [xlims, ylims] = rect2lims(rect)
% See also: rect2bb, lims2bb

xlims = [rect(1), rect(1) + rect(3)];
ylims = [rect(2), rect(2) + rect(4)];

if nargout < 2
    xlims = [xlims ylims];
end

end

