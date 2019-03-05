function dsinfo = h5dsinfo(filepath, grp)
%H5DSINFO Returns a structure with info on all datasets in an HDF5 file.
% Usage:
%   h5dsinfo(filepath)
%   dsinfo = h5dsinfo(filepath)
%   dsinfo = h5dsinfo(filepath, grp)
% 
% Args:
%   filepath: file path to HDF5 file
%   grp: path to group within HDF5 file (default: '/')
%
% Returns:
%   dsinfo: structure with info on each dataset within the file
%
% Note: if no output requested will just print the info as a table
%
% See also: h5file, h5info, h5getdatasets

if nargin < 2; grp = '/'; end

% Query for info on the whole file
info = h5info(filepath, grp);

% Recurse through the info structure
dsinfo = getdsets(info);

% Merge all the structures
dsinfo = vertcat(dsinfo{:});

if nargout < 1
    if isscalar(dsinfo)
        disp(dsinfo)
    else
        T = struct2table(dsinfo);
        T.shape = cf(@(x)mat2str(x),T.shape);
        T.maxshape = cf(@(x)mat2str(x),T.maxshape);
        T.chunks = cf(@(x)mat2str(x),T.chunks);
        disp(T)
    end
    clear dsinfo
end

end

function dsets = getdsets(G)
% Recurse through info structure and pull out datasets

dsets = {};
if ~isempty(G.Datasets)
    base = G.Name;
    if base(end) == '/'; base = base(1:end-1); end
    
    dsets = {struct(...
        'path', strcat(base, '/', {G.Datasets.Name})', ...
        'dtype', af(@(x) x.Datatype.Type, G.Datasets), ...
        'shape', af(@(x) x.Dataspace.Size, G.Datasets), ...
        'maxshape', af(@(x) x.Dataspace.MaxSize, G.Datasets), ...
        'chunks', {G.Datasets.ChunkSize}' )};
    
end

for i = 1:numel(G.Groups)
    dsets = [dsets; getdsets(G.Groups(i))];
end

end

