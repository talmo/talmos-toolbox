function info = matinfo(matfilepath)
%MATINFO Displays or returns a table with info about each variable in a MAT file.
% Usage:
%   matinfo(matfilepath)
%   info = matinfo(matfilepath)
% 
% See also: matvars, matfile, whos

if ischar(matfilepath)
    m = matfile(matfilepath);
elseif isa(matfilepath,'matlab.io.MatFile')
    m = matfilepath;
end

info = whos(m);
info = struct2table(rmfield(info,{'global','persistent','nesting'}));

if nargout < 1
    info.name = categorical(info.name);
    info.size = categorical(cf(@mat2str, info.size));
    info.class = categorical(info.class);
    
    disp(info)
    clear info
end

end
