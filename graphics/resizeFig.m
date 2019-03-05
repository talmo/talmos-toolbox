function resizeFig(fig, sz)
%RESIZEFIG Resizes a figure.
% Usage:
%   resizeFig(sz)
%   resizeFig(fig, sz)

if nargin == 1
    sz = fig;
    fig = gcf;
end

delta = fig.Position(3:4) - sz;
fig.Position(3:4) = sz;
fig.Position(2) = fig.Position(2) + delta(2);

end

