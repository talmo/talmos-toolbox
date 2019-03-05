function basepath = ttbasepath
%TTBASEPATH Returns the base path to the toolbox.
% Usage:
%   basepath = ttbasepath

basepath = fileparts(mfilename('fullpath'));
end