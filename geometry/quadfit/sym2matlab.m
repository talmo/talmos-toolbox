function c = sym2matlab(c)
% Convert symbolic expression containing matrix entries into MatLab.
%
% See also: symm

% Copyright 2010 Levente Hunyadi

greek = {
    'alpha', ...
    'beta', ...
    'gamma', ...
    'delta', ...
    'epsilon', ...
    'varepsilon', ...
    'zeta', ...
    'eta', ...
    'theta', ...
    'vartheta', ...
    'iota', ...
    'kappa', ...
    'lambda', ...
    'mu', ...
    'nu', ...
    'xi', ...
    'pi', ...
    'varpi', ...
    'rho', ...
    'varrho', ...
    'sigma', ...
    'varsigma', ...
    'tau', ...
    'upsilon', ...
    'phi', ...
    'varphi', ...
    'chi', ...
    'psi', ...
    'omega' ...
};
idpattern = ['([A-Za-z]|', strjoin('|',greek), ')'];

c = char(c);
c = regexprep(c, [idpattern '_(\d+)_(\d+)'], '$1($2,$3)');  % A_23_1 --> A(23,1)
c = regexprep(c, [idpattern '_(\d+)'], '$1($2)');  % b_10 --> b(10)
c = regexprep(c, [idpattern '(\d)(\d)(?!\d)'], '$1($2,$3)');  % A23 --> A(2,3)
c = regexprep(c, [idpattern '(\d)(?!\d)'], '$1($2)');  % b1 --> b(1)

function string = strjoin(adjoiner, strings)
% Concatenates a cell array of strings.
%
% Input arguments:
% adjoiner:
%    string separating each neighboring element
% strings:
%    a cell array of strings to join
%
% See also: cell2mat

% Copyright 2008-2009 Levente Hunyadi

validateattributes(adjoiner, {'char'}, {'vector'});
validateattributes(strings, {'cell'}, {'vector'});
assert(iscellstr(strings), ...
    'strjoin:ArgumentTypeMismatch', ...
    'The elements to join should be stored in a cell vector of strings (character arrays).');

% arrange substrings into cell array of strings
concat = cell(1, 2 * numel(strings) - 1);  % must be row vector
j = 1;
concat{j} = strings{1};
for i = 2 : length(strings)
    j = j + 1;
    concat{j} = adjoiner;
    j = j + 1;
    concat{j} = strings{i};
end

% concatenate substrings preserving spaces
string = cell2mat(concat);