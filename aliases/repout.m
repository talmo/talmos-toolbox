function varargout = repout(varargin)
N = max(nargout,1);
varargout{1:N} = replicate(varargin{:});
end
