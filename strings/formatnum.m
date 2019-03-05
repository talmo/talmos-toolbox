function str = formatnum(num, precision, truncate)
%FORMATNUM Formats a number into a pretty string.
% Usage:
%   str = formatnum(num)
%   str = formatnum(num, precision)
%   str = formatnum(num, precision, truncate)

if nargin < 2
    precision = 4;
end
if nargin < 3
    truncate = true;
end

% Check if we're below precision
if num < (10^(-precision))
    if truncate
        str = sprintf(['<%.' num2str(precision) 'f'], 10^(-precision));
    else
        str = sprintf(['%.' num2str(precision) 'g'], num);
        str = regexprep(str, 'e-[0]*(\d+)$', '^-$1');
    end
else
    if truncate
        num = round(num * (10^precision)) / (10^precision);
    end
    str = sprintf(['%.' num2str(precision) 'f'], num);
end

% Remove trailing zeros
str = regexprep(str, '0+$', '');

end


