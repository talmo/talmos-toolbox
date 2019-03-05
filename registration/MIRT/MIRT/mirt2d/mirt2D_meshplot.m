% function mirt2D_meshplot(x,y,n,m);
% Plot a 2D mesh from it's x,y control points coordinate vectors.
% input :
%               x - x-nodes positions (n*mx1 or mxn)
%               y  - y-nodes positions (n*mx1 or mxn)
%               n - xsize of the mesh 
%               m - ysize of the mesh  
%		
%	       (m,n optional if x,y are already matices of size mxn)
%
% if n,m are not givet, then x,y are assumed in (mxn) format, and m, n
% computed directly from them. If n,m are given then x,y shoud be column vectors
% (n*mx1).
% Andriy Myronenko, March 11, 2006. (myron@csee.ogi.edu)


function mirt2D_meshplot(x,y,n,m)

if ~exist('n','var') || isempty(n)
    [m, n] = size(x); 
end;

xy=[x(:) y(:)];
A = spdiags(ones(m*n,2),[1 m],m*n,m*n);
a=m:m:size(xy,1)-1;
A(sub2ind([m*n m*n],a,a+1))=0;
gplot(A,xy);axis ij equal off;
