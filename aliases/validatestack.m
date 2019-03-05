function varargout = validatestack(varargin)
	varargout{1:nargout} = validate_stack(varargin{:});
end
