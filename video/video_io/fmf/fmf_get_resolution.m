function [width, height] = fmf_get_resolution(filename)
%FMF_GET_RESOLUTION Returns the width and height in pixels of an FMF video.
% Usage:
%   res = fmf_get_resolution(filename)
%   [width, height] = fmf_get_resolution(filename)
%
% Note: width = # cols and height = # rows

% Read height and width from header
[~, ~, height, width] = fmf_read_header(filename);

% Return single output
if nargout < 2
    width = [width, height];
end

end

