% F=mirt2D_avi2mat(filename, col) reads an avi file (filename)
% and converts to 3D matrix of image frames for grayscale images
% or to the 4D matrix of color image frames.
% 'col' indicates wheather the color videos should be read as grayscale (3D matrix)
% or as color (4D matrix).
% 
% See also mirt2D_mat2avi, mirt2D_register

% Copyright (C) 2007-2010 Andriy Myronenko (myron@csee.ogi.edu)
% also see http://www.bme.ogi.edu/~myron/matlab/MIRT/
%
% This file is part of the Medical Image Registration Toolbox (MIRT).

function a=mirt2D_avi2mat(filename, col)
if ~exist('col','var') || isempty(col), col = 0; end;
 
F=aviread(filename);
d=length(F);

if nargin<1, error('Not enough imput arguments.'); end;
m=size(F(1).cdata);

if numel(m)>2
    if col
     a=zeros(m(1),m(2),3,d);
     for j=1:d
         a(:,:,:,j)=im2double(F(j).cdata);
     end 
    else
    a=zeros(m(1),m(2),d);
    for j=1:d
        a(:,:,j)=im2double(rgb2gray(F(j).cdata));
    end
    end
else
    [X{1:d}] = deal(F.cdata);
    a= cat(3,X{:});
    a=im2double(a);
end