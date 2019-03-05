function S = vec2str(V, delim)
%VEC2STR Returns the vector as a delimited string.
% Usage:
%   VEC2STR(V)
%   VEC2STR(V, delim)
%
% Notes:
%   - V will be converted to a vector by V(:)
%   - delim = ', ' (default)
if nargin < 2
    delim = ', ';
end

V = V(:); % Turn into a column vector

S = num2str(V);         % Convert to string
S = cellstr(S)';        % Split string into row cell array
S = strjoin(S, delim);  % Join cells with delimiter
S = strtrim(S);         % Trim whitespace

end

