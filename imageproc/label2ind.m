function ind = label2ind(L, classname)
%LABEL2IND Returns a cell array of indices 
% Usage:
%   ind = label2ind(L)
%   ind = label2ind(L, classname)
% 
% Args:
%   L: labels matrix
%   classname: class of output indices (default: uint32)
%
% Returns:
%   ind: cell array of indices for each label
% 
% See also: ind2label, bwlabel

if nargin < 2; classname = 'uint32'; end

N = uniquenz(L);
ind = af(@(i) feval(classname, find(L == i)), horz(N));


end
