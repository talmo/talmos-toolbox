function TF = isemptystruct(S, vals)
%ISEMPTYSTRUCT Checks whether the structure is empty.
% Usage:
%   TF = isemptystruct(S)
%   TF = isemptystruct(S, vals) % checks if all values are empty
%
% Notes:
%   - This checks if the structure has any fields (or non-empty values).
%   - Compare to isempty():
%     S = struct()
%     S = 
%     struct with no fields.
%     isempty(S)
%     ans =
%          0
%
% See also: isempty

narginchk(1, 2)
if nargin < 2; vals = false; end

% Check fieldnames
TF = isempty(fieldnames(S));

% Check the values
if vals && ~TF
    TF = all(structfun('isempty', S));
end

end

