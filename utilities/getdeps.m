function deps = getdeps(filename, ttonly)
%GETDEPS Returns the dependencies for a function or script.
% Usage:
%   deps = getdeps(filename)
%   deps = getdeps(filename, true) % returns only talmos-toolbox dependencies
%
% See also: ttcopydeps, matlab.codetools.requiredFilesAndProducts

if nargin < 2
    ttonly = false;
end

% Find dependencies
deps = matlab.codetools.requiredFilesAndProducts(filename);
deps = deps(:);

% Make sure we got all the mex files too
mex_exts = {'mexw32', 'mexmaci32', 'mexa32', ...
            'mexw64', 'mexmaci64', 'mexa64'};
mex_files = cell(size(mex_exts));
for i = 1:numel(mex_exts)
    mex_files{i} = cf(@(x)extrep(x,mex_exts{i}), deps);
    mex_files{i} = mex_files{i}(exists(mex_files{i}));
end
mex_files = cat(1,mex_files{:});
deps = unique([deps; mex_files]);

% Exclude input filename
% deps = deps(~strcmp(deps, which(filename)));

% Return only talmos-toolbox dependencies
if ttonly
    deps = deps(istt(deps));
end

end

