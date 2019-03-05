function printfrac(msg, i, N)
%PRINTFRAC Print a fraction with percentage.
% Usage:
%   printfrac(i, N)
% 
% Args:
%   i: 
%   N: 
% 
% See also: printf

if nargin == 2; N = i; i = msg; msg = ''; end
if ~isempty(msg); msg = [msg ': ']; end

printf('%s%d/%d (%.2f%%)', msg, i, N, (i/N)*100)

end
