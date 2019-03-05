function varnames = matvars(matfilepath)
%MATVARS Prints or returns the variables in a MAT file.
% Usage:
%   matvars(matfilepath)
%   varnames = matvars(matfilepath)
% 
% Args:
%   matfilepath: path to a MAT file
% 
% See also: matfile

m = matfile(matfilepath);

if nargout < 1
    whos(m)
else
    x = whos(m);
    varnames = {x.name};
end

end
