function titlecat(newLine, varargin)
%TITLECAT Concatenates line to the current figure title.
% Usage:
%   titlecat(newLine)
%   titlecat(h, newLine)

if ishghandle(newLine)
    h = newLine;
    newLine = varargin{1};
else
    h = gca;
end

if ~iscell(newLine)
    newLine = {newLine};
end

T = get(get(h, 'Title'), 'String');
if ~isempty(T) && ischar(T)
    T = {T};
end

T = [T newLine];

title(h, T)

end

