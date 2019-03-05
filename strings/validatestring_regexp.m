function TF = validatestring_regexp(str, expression, varargin)
%VALIDATESTRING_REGEXP Checks the validity of a text string using regexp.
% Usage:
%   TF = validatestring_regexp(str, expression)
%   TF = validatestring_regexp(str, expression, 'ThrowError', false)
%   TF = validatestring_regexp(..., option1, ..., optionN)
%
% Set ThrowError to false to suppress error if no match is found.
% See regexp for option names.
%
% See also: regexp, validatestr, validatestring, instr

% Process parameters
[ThrowError, options] = parse_inputs(varargin{:});

% Test expression
startIndex = regexp(str, expression, 'start', options{:});

% Convert to cell if scalar input
if ~iscell(startIndex)
    startIndex = {startIndex};
end

% Check if empty
TF = ~cellfun('isempty', startIndex);

% Throw error
if ~all(TF) && ThrowError
    error('The string did not match the specified regexp expression.')
end

end

function [ThrowError, options] = parse_inputs(varargin)
% Options accepted by regexp
regexp_options = {'all', 'once', 'matchcase', 'ignorecase', 'noemptymatch', 'emptymatch', 'dotall', 'dotexceptnewline', 'stringanchors', 'lineanchors', 'literalspacing', 'freespacing'};
regexp_args = cellfun(@(x) ischar(x) && instr(x, regexp_options), varargin);
options = varargin(regexp_args);

% Create inputParser instance
p = inputParser;

% Throw error
p.addParameter('ThrowError', true, @(x) validateattributes(x, {'logical'}, {'scalar'}));

% Parse
p.parse(varargin{~regexp_args});
ThrowError = p.Results.ThrowError;


end