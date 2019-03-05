function vp = h5play(filepath, dataset)
%H5PLAY Convenience wrapper for playing movies stored in HDF5 containers.
% Usage:
%   h5play
%   h5play(filepath)
%   h5play(filepath, dataset)
% 
% Args:
%   filepath: path to the HDF5 file. If empty or not specified a file 
%             browser will pop up (default: [])
%   dataset: path to dataset within the file (default: '/video/data')
% 
% See also: vplayer, h5file

if nargin < 1 || isempty(filepath); filepath = []; end
if nargin < 2 || isempty(dataset); dataset = '/video/data'; end

% File browser
if isempty(filepath)
    filepath = uibrowse('*.h5', [], 'Select an HDF5 file...');
end

% Check filepath
if ~exists(filepath) || ~strcmpi(get_ext(filepath), '.h5')
    error('Non-existent or invalid HDF5 file specified.')
end

% Check dataset
dsets = h5getdatasets(filepath);
if ~any(contains(dsets, dataset))
    error('Specified dataset does not exist: %s', dataset)
end

% Check if the dataset is transposed
sz = h5size(filepath, dataset);
isTransposed = sz(2) == 1; % [time, 1, width, height]

% Get handle for out-of-memory reader
if isTransposed
    f = hdf5file(filepath,dataset);
else
    f = hdf5prop(filepath,dataset);
end

% Launch video player
vp = vplayer(f, 'scale', false, 'stackName', filepath);

if nargout < 1; clear vp; end

end
