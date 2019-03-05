function [idx,Lidx] = bwccidx(BW)
%BWCCIDX Returns a cell array with the indices to each connected component in BW.
% Usage:
%   idx = bwccidx(BW)
%   idx = bwccidx(L)
% 
% Args:
%   BW: logical 2d array
%   L: numeric 2d array from bwlabel
%
% Returns:
%   idx: cell array of the same length as countcc(BW)
% 
% Example:
% >> celldisp(bwccidx([1 1 1 2 2 2 3 4]))
% ans{1} =
%      1     2     3
% ans{2} =
%      4     5     6
% ans{3} =
%      7
% ans{4} =
%      8
%
% See also: bwlabel, bwccmasks, countcc

Lidx = [];
if islogical(BW)
    ccs = bwconncomp(BW);
    idx = ccs.PixelIdxList;
else
    Lidx = rmmissing(uniquenz(BW));
    idx = af(@(i)bwccidx(BW == i),Lidx);
    [idx,Lidx] = cellcat(idx,2);
end
end
