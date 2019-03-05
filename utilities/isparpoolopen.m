function TF = isparpoolopen()
%ISPARPOOLOPEN Returns true if there is a parallel pool open.
% Usage:
%   TF = isparpoolopen
% 
% See also: gcp, parcancel

TF = ~isempty(gcp('nocreate'));

end
