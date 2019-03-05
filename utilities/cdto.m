function cdto(fun)
%CDTO Changes to function directory.
% Usage:
%   cdto('fun')
%   cdto(@fun)
%
% See also: which, funpath, func2str

% Get function name if handle is passed in
if isa(fun, 'function_handle')
    fun = func2str(fun);
    if fun(1) == '@'
        error('Cannot cd to anonymous function.')
    end
end

% Get function path
p = which(fun);
if isempty(p); error('Function does not exist: %s', fun); end

% Check for built-in
if strcmp('built-in', p(1:8)); p = p(11:end-1); end

% Get parent directory
p = fileparts(p);
if ~exists(p); error('Path to function does not exist: %s', p); end

if istt(p)
    % If it's in talmos-toolbox, let's use cdtt to remember the last directory
    cdtt(p)
else
   % Just do the thing
    cd(p)
end

end

