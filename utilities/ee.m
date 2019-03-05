function ee(path)
%EE Convenience function for opening a path in Windows Explorer.
% Usage:
%   ee(path)
%
% See also: winopen

if nargin < 1; path = pwd; end

winopen(path)

end

