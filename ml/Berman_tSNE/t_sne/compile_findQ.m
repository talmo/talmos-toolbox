% Builds the findQ function using BLAS
if ispc
    blaslib = fullfile(matlabroot,'extern','lib',computer('arch'),'microsoft',...
      'libmwblas.lib');
    mex('-v', '-largeArrayDims', 'findQ.c', blaslib)
else
    mex -v -largeArrayDims findQ.c -lmwblas
end
