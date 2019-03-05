# sub2mask
MATLAB helper for combining subscript and logical indexing

## Principle:
Have you ever experienced the inconvenience of manipulating 3D or nD arrays with logical indexing?
The following example shows something that doesn't work: logical indexing of 2D layers of a 4D array.
```
A = rand(10,10,3,3);
mask = eye(10)==1;
A(mask,3,:) %errors:
  Index exceeds matrix dimensions.
```

The helper function `sub2mask` offers an alternative by creating an appropriate logical mask from logical and subscript inputs.
```
A(sub2mask(size(A),mask,3,:))
% OR
I = @(A,varargin) sub2mask(size(A),varargin{:});
A(I(A,mask,3,:))
% OR
I = @(varargin) sub2mask(size(A), varargin{:});
A(I(mask,3,:))
```
