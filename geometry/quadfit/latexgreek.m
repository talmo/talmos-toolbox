function s = latexgreek(s)
% Replace all recognized Greek letters with their LaTeX equivalents.
% This function replaces a wider range of letters than does the MatLab
% built-in function texlabel.
%
% Input arguments:
% s:
%    a character string to scan for Greek letter names
%
% See also: texlabel

% Copyright 2008-2009 Levente Hunyadi

validateattributes(s, {'char'}, {'vector'});

persistent search replace;

if isempty(search) || isempty(replace)
    letters = {
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
        'Alpha', ...
        'Beta', ...
        'Gamma', ...
        'Delta', ...
        'Epsilon', ...
        'Zeta', ...
        'Eta', ...
        'Theta', ...
        'Iota', ...
        'Kappa', ...
        'Lambda', ...
        'Mu', ...
        'Nu', ...
        'Xi', ...
        'Pi', ...
        'Rho', ...
        'Sigma', ...
        'Tau', ...
        'Upsilon', ...
        'Phi', ...
        'Chi', ...
        'Psi', ...
        'Omega' ...
    };
    search = cellfun(@(letter) ['(?<![A-Za-z0-9])' letter], letters, 'UniformOutput', false);
    replace = cellfun(@(letter) ['\\' letter], letters, 'UniformOutput', false);  % special regular expression character "backslash" needs to be escaped
end
s = regexprep(s, search, replace);