function stack2gif(images, filename, fps, skipEvery, map)
%STACK2GIF Saves a set of images to an animated gif.
% Usage:
%   stack2gif(images, filename)
%   stack2gif(images, filename, fps)
%   stack2gif(images, filename, fps, skipEvery, map)

if nargin < 3 || isempty(fps)
    fps = 15;
end
if nargin < 4 || isempty(skipEvery)
    skipEvery = 1;
end
if nargin < 5
    map = [];
end
fps = fps / skipEvery;

images = validate_stack(images);

if ~isequal(filename(end-3:end), '.gif')
    error('Filename must end in .gif.')
end

% Subsample
images = images(:,:,:,1:skipEvery:end);

% imwrite only accepts indexed RGB images, so we have to create a colormap
isRGB = size(images, 3) == 3;
if isRGB && isempty(map)
    % We want to compute colormap using ALL images, so concatenate them sideways
    sz = size(images);
    images = reshape(permute(images, [1 2 4 3]), sz(1), [], sz(3));
    
    % Compute map using Minimum Variance Quantization with 256 bins
    [~, map] = rgb2ind(images, 256);
    
    % Reshape back to original
    % images = permute(reshape(images, sz([1 2 4 3])), [1 2 4 3]);
    
    % Convert to indexed
    images = mat2cell(images, sz(1), repmat(sz(2),1,sz(4)), sz(3));
    for i = 1:numel(images); images{i} = rgb2ind(images{i},map); end
    
    % Reshape back to original
    images = cat(4, images{:});
end
assert(size(images, 3) == 1, 'If specifying colormap, image must be indexed.') 

% Class compatibility
if isa(images, 'single')
    images = double(images);
end

% Save
if isempty(map)
    imwrite(images, filename, 'DelayTime', 1/fps, 'LoopCount', inf)
else
    imwrite(images, map, filename, 'DelayTime', 1/fps, 'LoopCount', inf)
end

printf('Saved %d frames (*%s*) to: *%s*', size(images,4), bytes2str(filename), filename);


% numFrames = size(images, 4);
% imwrite(images(:,:,:,1), filename, 'DelayTime', 1/fps, 'LoopCount', inf, 'WriteMode', 'overwrite')
% for i = 2:numFrames
%     imwrite(images(:,:,:,i), filename, 'DelayTime', 1/fps, 'WriteMode', 'append')
% end

end