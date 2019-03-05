function L = ind2label(inds, sz, classname)
%IND2LABEL Reconstruct labels image from cell array of indices.
% Usage:
%   L = ind2label(inds, sz)
%   L = ind2label(inds, sz, classname)
% 
% Args:
%   inds: cell array of image indices (also accepts numeric array)
%   sz: size of output image
%   classname: class of output image (default: uint8)
%              change this to uint16 or uint32 if you have many labels
%
% Returns:
%   L: reconstructed labels image
% 
% See also: label2ind, ind2im

if nargin < 3; classname = 'uint8'; end

if ~iscell(inds); inds = {inds}; end

L = zeros(sz, classname);
for i = 1:numel(inds)
    L(inds{i}) = i;
end

end
