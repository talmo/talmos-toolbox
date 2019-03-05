function T = titlecase(str)
%TITLECASE Capitalizes the first letter of every word in a string.
% Usage:
%   T = titlecase(str)
%
% See also: upper, lower, regexprep

T = regexprep(str, '(\<[a-z])', '${upper($1)}');

end

