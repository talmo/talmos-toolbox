function [prefix, stripped] = findprefix(varargin)
%FINDPREFIX Finds the common prefix in a set of strings.
% Usage:
%   prefix = findprefix(str1, str2, ...)
%   prefix = findprefix({str1, str2, ...})
%   [prefix, stripped] = findprefix(_)
%
% Source: https://github.com/lemonzi/matlab/blob/master/custom/prefix.m

    if (nargin > 1)
        strings = varargin;
    elseif (nargin == 1 && iscell(varargin{1}))
        strings = varargin{1};
    elseif (~iscell(varargin{1}))
        stripped = varargin(1);
        prefix = '';
        return
    else
        stripped = {};
        prefix = '';
        return
    end

    % Max length
    maxlen = max(cellfun(@length, strings));

    % Pad to the right for prefix
    names_mat = zeros(length(strings), maxlen);
    for i = 1:length(strings)
        len = length(strings{i});
        names_mat(i,:) = [strings{i}, repmat(i, 1, maxlen-len)];
    end

    ref = names_mat(1,:);
    eqs = bsxfun(@eq, names_mat, ref);
    eqs = all(eqs, 1);
    split = find(eqs == 0, 1, 'first') - 1;
    if (isempty(split))
        split = length(ref);
    end
    prefix = char(ref(1:split));

    if (nargout > 1)
        % Compute unprefixed versions of the strings
        stripped = strings;
        for i = 1:numel(strings)
            stripped{i} = strings{i}((split+1):end);
        end
    end

end