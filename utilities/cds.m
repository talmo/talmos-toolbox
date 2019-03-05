function target_path = cds(query, varargin)
%CDS Change directory with partial matching.
% Usage:
%   cds(query)
%   target_path = cds(query)
% 
% Args:
%   query: partial string to match against folder names
%
% Returns:
%   target_path: matched folder
% 
% See also: cdto

if nargin < 1; return; end
if nargin > 1; query = strjoin([{query} varargin]); end

dirs = dir_folders(pwd);
hits = contains(dirs,query,'IgnoreCase',true);

if ~any(hits); printf('No folders matching ''%s'' found.', query); return; end

idx = find(hits,1);
target_path = dirs{idx};

cd(target_path)

if nargout < 1; clear target_path; end
end
