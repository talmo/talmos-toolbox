function h = append_title(str, varargin)
%APPEND_TITLE Appends the specified string(s) as new lines to the current axes title. Accepts the same parameters as title().
% Usage:
%   append_title(str)
%   append_title(cellstr)
%   append_title(..., Name,Value)
%   h = append_title(...)
%
% See also: title

% Make sure input is a cell
if ~iscell(str)
    str = {str};
end
if ~iscellstr(str)
    error('Title must be a string or cell array of strings.')
end

% Get current title
current_title = get(get(gca, 'Title'), 'String');

% Just assign the new title if there's no title currently
if (ischar(current_title) && isempty(current_title)) || ...
    (iscell(current_title) && all(areempty(current_title)))
    handle = title(str, varargin{:});
else
    % Make sure current title is a cell
    if ~iscell(current_title)
        current_title = {current_title};
    end
    
    % Set new title
    handle = title([current_title(:); str(:)], varargin{:});
end

if nargout > 0
    h = handle;
end
end

