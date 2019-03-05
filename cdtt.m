function cdtt(subdir)
%CDTT Changes the current directory to talmos-toolbox.
% Usage:
%   cdtt
%   cdtt subdir
%
% Call again to go back to the last directory.

if nargin < 1; subdir = ''; end

persistent lastDir;

current = cd;
tt = ttbasepath;
if ~isempty(subdir)
    if contains(subdir, tt)
        tt = subdir;
    else
        tt = fullfile(tt, subdir);
    end
end

if isempty(lastDir) || ~instr(tt, current)
    cd(tt)
    lastDir = current;
else
    if exists(lastDir)
        cd(lastDir)
    end
end
end

