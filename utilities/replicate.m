function varargout = replicate(X)
%REPLICATE Replicates X to every output.
% Usage:
%   [X1, X2, ...] = replicate(X)
%
% Example:
%     >> [a,b] = replicate(zeros(2))
%     a =
%          0     0
%          0     0
%     b =
%          0     0
%          0     0
%
% See also: deal, output

varargout = repmat({X}, nargout, 1);

end

