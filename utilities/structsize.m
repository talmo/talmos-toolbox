function sz = structsize(S)
%STRUCTSIZE Computes the size in bytes of each field in a structure.
% Usage:
%   structsize(S)
%   sz = structsize(S)
% 
% Args:
%   S: structure
% 
% See also: varsize, structfun

if nargout < 1
    sz = structfun(@(x)bytes2str(varsize(x)),S,'UniformOutput',false);
    name = inputname(1);
    if isempty(name); name = 'struct'; end
    printf('*%s* (%s total)', name, bytes2str(varsize(S)))
    structdisp(sz)
    clear sz
else
    sz = structfun(@varsize,S,'UniformOutput',false);
end

end
