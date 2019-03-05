function out = cpf(func, varargin)
%CPF Parallel cellfun!
% Usage:
%   out = cpf(func, C)
% 
% See also: cf, cellfun

% nout = min(nargout, 1);
nout = 1;

for i = 1:numel(varargin{1})
    args = cf(@(x) x{i}, varargin);
    futures(i) = parfeval(@()func(args{:}), nout);
end

out = cell(size(varargin{1}));
for i = 1:numel(varargin{1})
    [idx,out_i] = fetchNext(futures);
    out{idx} = out_i;
end

end
