function on = bwonset(BW)
%BWONSET Returns true for the first element in each connected component.
% Usage:
%   bwonset(BW)
% 
% Args:
%   BW: logical vector
% 
% Returns:
%   on: logical vector of same size as BW
%
% Example:
%     >> [x; bwonset(x)]
%     ans =
%          1     0     0     1     1     1     0     1
%          1     0     0     1     0     0     0     1
% 
% See also: bwconncomp

on = BW;
on(2:end) = ~BW(1:end-1) & BW(2:end);

end
