function varargout = freemem
%FREEMEM Displays or returns the amount of free system memory in MB.
% This is a wrapper for memory_usage().

if nargout < 1
    memory_usage('MB')
else
    varargout = {memory_usage('MB')};
end
end

