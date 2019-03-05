function saveTIFFStack(stack, filename, varargin)
%SAVETIFFSTACK Saves a volume as a TIFF stack.
% Usage:
%   saveTIFFStack(stack, filename)
%
% Args:
%   stack: 3D or 4D RGB stack of images
%   filename: file to save to
% 
% Note: This function will overwrite the file if it already exists.

if ndims(stack) == 3
    stack = permute(stack, [1 2 4 3]);
end

for i = 1:size(stack, 4)
    if i == 1
        imwrite(stack(:,:,:,i), filename, varargin{:})
    else
        imwrite(stack(:,:,:,i), filename, 'WriteMode', 'append', varargin{:})
    end
end

end

