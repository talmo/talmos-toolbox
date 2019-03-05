% F=mirt2D_mat2avi(a)  converts 'a' - 3D matrix (MxNxK), where 
% MxN are image size and K is a number of frames, to the
% Matlab's avi video format, so that it can be directly
% saved using movie2avi(F,'filename.avi');
% 
% See also mirt2D_avi2mat, mirt2D_register

% Copyright (C) 2007-2010 Andriy Myronenko (myron@csee.ogi.edu)
% also see http://www.bme.ogi.edu/~myron/matlab/MIRT/
%
%     This file is part of the Medical Image Registration Toolbox (MIRT).

function F=mirt2D_mat2avi(a)

d=size(a);
b=num2cell(im2uint8(a),1:numel(d)-1);
[F(1:d(end)).cdata]=deal(b{:});    
[F.colormap]=deal([]);
