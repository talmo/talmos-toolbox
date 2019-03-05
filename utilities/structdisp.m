function structdisp(S)
%STRUCTDISP Print contents of a structure.
% Usage:
%   structdisp(S)
% 
% Args:
%   S: structure
% 
% See also: structsize

fields = fieldnames(S);
w = max(cellfun(@length,fields));
for f = 1:numel(fields)
    if isfloat(S.(fields{f}))
        printf(['*%' num2str(w) 's*: %f'], fields{f}, S.(fields{f}))
    elseif ischar(S.(fields{f}))
        printf(['*%' num2str(w) 's*: %s'], fields{f}, S.(fields{f}))
    else
        printf(['*%' num2str(w) 's*: %d'], fields{f}, S.(fields{f}))
    end
end

end
