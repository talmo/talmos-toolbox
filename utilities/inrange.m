function TF = inrange(X, lims, inclusive)
%INRANGE Checks whether each element in X is in the range specified by lims.
% Usage:
%   TF = inrange(X, lims)
%   TF = inrange(X, lims, false) % non-inclusive
%
% Args:
%   X: numeric
%   lims: numeric array of the form [Xmin, Xmax], where Xmin <= Xmax
%   inclusive: if false, does not include limits in the range (default: true)
%
% Returns:
%   TF: logical of the same size as X. TF is true where X is within the
%       range specified by lims.
%
% Example:
%     >> inrange([0, 0.5, 1, 1.5], [0 1])
%     ans =
%       1×4 logical array
%        1   1   1   0
%     >> inrange([0, 0.5, 1, 1.5], [0 1], false)
%     ans =
%       1×4 logical array
%        0   1   0   0
%
% See also: alims, range2idx

if nargin < 3; inclusive = true; end

assert(lims(1) <= lims(2), 'Lower limit must be <= upper limit.')

if inclusive
    TF = X >= lims(1) & X <= lims(2);
else
    TF = X > lims(1) & X < lims(2);
end

end

