function ttpaths(remove)
%TTPATHS Adds the paths to all talmos-toolbox folders.
% Usage:
%   ttpaths
%   ttpaths(1) % removes from the path

ttPath = fileparts(mfilename('fullpath'));
if nargin < 1
    addpath(genpath(ttPath))
    disp('Added talmos-toolbox paths.')
else
    rmpath(genpath(ttPath))
    disp('Removed talmos-toolbox paths.')
end
end

