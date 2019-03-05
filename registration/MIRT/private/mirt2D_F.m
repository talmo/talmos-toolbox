% MIRT2D_F Initializes a matrix of cubic B-spline coefficients
% for a single square 2D patch. F times the vector of 16 (4x4) given control points
% will give a new spatial locations of image pixels within this patch.
%

% Copyright (C) 2007-2010 Andriy Myronenko (myron@csee.ogi.edu)
% also see http://www.bme.ogi.edu/~myron/matlab/MIRT/
% This file is a part of Medical Image Registration Toolbox (MIRT)

function Fi=mirt2D_F(okno)
  
  B=[-1 3 -3 1;
    3 -6 3 0;
    -3 0 3 0;
    1 4 1 0]/6;
u=linspace(0,1,okno+1)';
u=u(1:end-1);

T=[u.^3 u.^2 u ones(okno,1)];
B=T*B;
Fi=kron(B,B);


