% Builds the pdisteuclidean function using BLAS
if ispc
    blaslib = fullfile(matlabroot,'extern','lib',computer('arch'),'microsoft',...
      'libmwblas.lib');
    mex('-v', '-largeArrayDims', 'pdisteuclidean.c', blaslib)
else
    mex -v -largeArrayDims pdisteuclidean.c -lmwblas
end
