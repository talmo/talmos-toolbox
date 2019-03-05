function paths = meppaths()
%MEPPATHS Returns path to MEP JAR files.
% Usage:
%   meppaths
% 
% See also: mepstart

% Look for JAR files
mepPath = searchFor('MEP_*.jar', funpath(true), 1);
matconsolectlPath = searchFor('matconsolectl-*.jar', funpath(true), 1);

% Return paths
paths = {mepPath, matconsolectlPath};

end
