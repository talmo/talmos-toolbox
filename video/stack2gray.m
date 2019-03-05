function gray = stack2gray(images)
%STACK2GRAY Converts a stack of RGB images to grayscale.
% Usage:
%   gray = stack2gray(images)

images = validate_stack(images);

gray = cell(size(images, 4), 1);
for i = 1:numel(gray)
    gray{i} = rgb2gray(images(:,:,:,i));
end
gray = cat(4, gray{:});

end

