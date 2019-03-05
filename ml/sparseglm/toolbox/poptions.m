%[options] = poptions(opt,varargin)
%Process options and stick them into a structure
%Part of the code and general idea ripped off process_options, (C) 2002 Mark A. Paskin


function [options] = poptions(opt,varargin)
% Check the number of input arguments
n = length(varargin);
if (mod(n, 2))
  error('Each option must be a string/value pair.');
end
nopt = n/2;
options = [];



%Set to defaults
for ind=1:2:n
  options = setfield(options,varargin{ind},varargin{ind+1});
end

%Now loop through input
for ind=1:2:length(opt)
  if (isfield(options,opt{ind}))
    options = setfield(options,opt{ind},opt{ind+1});
  else
    error(sprintf('Option %s undefined',opt{ind}));
  end
end

%Check that all necessary options have been specified 
fnames = fieldnames(options);
for f = 1:length(fnames)
  fi = getfield(options,fnames{f});
  if (~isa(fi,'function_handle') & ~isa(fi,'struct'))
    if (isnan(fi))
      error(sprintf('Option %s must be specified',fnames{f}));
    end
  end
end