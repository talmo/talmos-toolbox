function stack = ind2stack(S, parallel)
%IND2STACK Reconstruct stack from structure array of ind-vals.
% Usage:
%   stack = ind2stack(S)
%   stack = ind2stack(S, parallel)
% 
% Args:
%   S: structure with fields 'sz', 'ind' and optionally 'vals'
%   parallel: reconstruct stack in parallel (default: false)
%
% Returns:
%   stack: 4-d stack reconstructed from S
% 
% See also: ind2im, im2ind

if nargin < 2; parallel = false; end

N = numel(S);
stack = cell1(N);

if parallel
    parfor i = 1:N
        stack{i} = ind2im(S(i));
    end
else
    for i = 1:N
        stack{i} = ind2im(S(i));
    end
end

stack = cellcat(stack,4);

end
