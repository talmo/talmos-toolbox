function padded = padstr(S, padStr, padSize, direction)
%PADSTR Pads a string or array of strings with another string.
% Args:
%   S = string or cell array of strings to be padded
%   padStr = string or cell array of strings to pad with
%   padSize = how many times to repeat the padded string (default = 1)
%   direction = 'pre', 'post', or 'both' (default = 'pre')
%
% Usage:
%   padded = padstr(S, padStr)
%   padded = padstr(S, padStr, padSize)
%   padded = padstr(S, padStr, padSize, direction)

% Parse inputs
narginchk(2, 4)
args = {S, padStr};
if nargin > 2; args{end + 1} = padSize; end
if nargin > 3; args{end + 1} = direction; end
[S, padStr, padSize, direction] = parse_input(args{:});

padded = S;
for i = 1:numel(padded)
    % Figure out what to pad with
    if iscellstr(padStr)
        pad = padStr{i};
    else
        pad = padStr;
    end
    
    % Figure out how many times to pad
    if isscalar(padSize)
        pre_n = padSize;
        post_n = padSize;
    elseif isequal(size(padSize), [1 2])
        pre_n = padSize(1);
        post_n = padSize(2);
    elseif isvector(padSize)
        pre_n = padSize(i);
        post_n = padSize(i);
    else
        pre_n = padSize(i, 1);
        post_n = padSize(i, 2);
    end
    
    % Pad
    if instr(direction, {'pre', 'both'})
        padded{i} = [repmat(pad, 1, pre_n) padded{i}];
    end
    if instr(direction, {'post', 'both'})
        padded{i} = [padded{i} repmat(pad, 1, post_n)];
    end
end

if numel(padded) == 1
    padded = padded{1};
end
end

function [S, padStr, padSize, direction] = parse_input(S, varargin)
% Valid padding directions
directions = {'pre', 'post', 'both'};

% Parse first arg
p = inputParser;
p.addRequired('S', @(x) ischar(x) || iscellstr(x));
p.parse(S);
S = p.Results.S;

num_strs = 1;
if iscellstr(S); num_strs = numel(S); end

% Parse the rest
p = inputParser;
p.addRequired('padStr', @(x) ischar(x) || (iscellstr(x) && iscellstr(S) && numel(x) == num_strs));
p.addOptional('padSize', 1, @(x) validateattr(x, {'numeric'}, {'integer'}) && (isscalar(x) || isequal(size(x), [1 2]) || (iscellstr(S) && size(x, 1) == num_strs)));
p.addOptional('direction', 'pre', @(x) validatestr(x, directions));
p.parse(varargin{:});

if ~iscellstr(S); S = {S}; end
padStr = p.Results.padStr;
padSize = p.Results.padSize;
direction = validatestring(p.Results.direction, directions);

if instr('direction', p.UsingDefaults) && size(padSize, 2) == 2
    direction = 'both';
end

end