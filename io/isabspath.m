function TF = isabspath(paths)
%ISABSPATH Returns true if the path(s) are absolute.
% Usage:
%   TF = isabspath(paths)

abs = abspath(paths);
TF = strcmp(paths, abs);

end

