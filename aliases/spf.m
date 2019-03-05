function varargout = spf(varargin)
	varargout{1:min(nargout,1)} = stackparfun(varargin{:});
end
