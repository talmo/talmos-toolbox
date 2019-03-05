function varargout = xout(varargin)
	varargout{1:nargout} = replicate(varargin{:});
end
