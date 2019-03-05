function pos = gcfpos
%GCFPOS Prints or returns the position vector for the current figure.
% Usage:
%   gcfpos % also copies to clipboard
%   pos = gcfpos

pos = get(gcf, 'Position');

if nargout < 1
    pos = round(pos);
    pos = sprintf('[%d, %d, %d, %d]', pos(1), pos(2), pos(3), pos(4));
    disp(pos)
    clipboard('copy',pos)
    clear pos
end
end

