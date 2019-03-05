function TF = fisopen(f)
%FISOPEN Returns true if the file handle is open and valid.
% Usage:
%   TF = fisopen(f)
%
% See also: fopen, fclose, ftell

TF = true;
try
    ftell(f);
catch
    TF = false;
end

end

