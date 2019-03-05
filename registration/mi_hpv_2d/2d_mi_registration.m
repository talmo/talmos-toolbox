%% 2-D rigid body Image registration using mutual information. 
% Rigid body 2-D image co-registration (translation and rotation) is performed
% using maximization of mutual information.  
%
% Function is implemented in c-code and compiled using the Matlab compiler
% to minimize computation time.  
%
% Mutual information joint entropy matrix is computed using the Hanning
% windowed sinc function as the kernel of interpolation, which is the HPV
% estimation method [1].  
%
% Maximization of the joint entropy matrix is carried out using Powel's
% Direction set method [2] with original c-code very slightly modified from
% J.P. Moreau's code[3].  
%
% [1] Lu X, et al., Mutual information-based multimodal image registration
% using a novel joint histogram estimation, Comput Med Imaging Graph
% (2008), doi: 10.1016/j.compmedimag.2007.12.001
%
% [2] Numerical Recipes, The Art of Scientific Computing By W.H. Press, 
% B.P. Flannery, S.A. Teukolsky and W.T. Vetterling, Cambridge University 
% Press, 1986
%
% [3] http://pagesperso-orange.fr/jean-pierre.moreau/Cplus/tpowell_cpp.txt
%
% See also: 

%% Syntax
%   [parameters xy xy_0] = mi_hpv_2d(Reference Image,Floating Image)
%
% Input:
%
%   Reference Image: image that will be compared too.  Must be uint8.  Take
%   care to scale image properly.
%
%   Floating Image: image that will be rotated and translated.  Must be
%   uint8.  Take care to scale image properly.
%
% Output:
%
%   parameters: 3x1 Array with the form [DeltaX  DeltaY  DeltaTheta].  
%   Theta is counterclockwise in-plane rotation in radians.  DeltaX/Y
%   are translations in pixels.
%   
%   xy: Optional output.  8x1 Array with the x and y coordinates of the
%   corners of the output matix.
%
%   xy_0: Optional output.  8x1 Array with the x and y coordinates of the
%   corners of the input matrix.
%
%   The output provides the necessary tools for you to translate the Float
%   image, but does not move it for you.  You have the option of using
%   parameters and moving the reference image (using circshift and imrotate
%   for example) or you can use the xy and xy_0 output to more accurately
%   transform the reference image, but its slightly more complicated.  The
%   inclusion of both more has to do with me being unsatisfied with the
%   lack of precision in circshift and imrotate.  I recommend the latter
%   approach.

%% Example
% We will use the Shepp-Logan phantom (phantom.m).  Note we first scale the
% image to have signal intensities in the range 0-255 and then convert to
% uint8.  

Ref = imread('sl_phantom.tif'); % same as: Ref = uint8(phantom.*255);
Float = imread('phantom_transformed.tif');
diff = abs(Float-Ref);
figure(1);
subplot(1,3,1);
imshow(Ref);
title('Reference image')
subplot(1,3,2);
imshow(Float);
title('Float image')
subplot(1,3,3);
imshow(diff);
title('Difference image')
%%
% The image has first been rotated counterclockwise 30 degrees and then
% shifted in the x and y directions. Input the appropriate syntax and wait
% patiently.  Operating times have been clocked on my 2Ghz pentium 
% processor at around 40 seconds.  This time is of course dependent upon
% your matrix size and how far it must search to find the maximum.

[para, xy, xy_0] = mi_hpv_2d(Ref,Float);
%%
% This code is using the tformarray (and associated) function, which uses
% the optional xy and xy_0 corner locations.  Again you can call the function
% with just para and use circshift and imrotate if you like. 

xy = reshape(xy,[2 4])';
xy_0 = reshape(xy_0,[2 4])';
T = maketform('projective',xy_0,xy);
R = makeresampler('cubic','replicate'); 
Coregged = tformarray(Float,T,R,[1 2],[1 2],[size(Ref,1) size(Ref,2)],[],[]);

diff2 = abs(Coregged-Ref);
figure(2)
subplot(1,3,1);
imshow(Ref);
title('Reference image')
subplot(1,3,2);
imshow(Coregged);
title('Co-Registered image')
subplot(1,3,3);
imshow(diff2);
title('Difference image')
%% Disclaimer
% This code has been compiled only for a Dell computer running windows
% vista.  It is pretty trivial to re-compile for other operating systems,
% and the c-code has been included for this purpose.  You of course need to
% have the matlab compiler package license.
% Also, I only adapted the Powell code, so I don't know that it is optimum.
% Eventually, I will probably check this.  I'm pretty sure my MI
% calculating code is correct, however no one is perfect.  Please test this
% code yourself before blindly applying it.  
%
% Please email me with questions/complaints/errors:
% matthew.sochor@gmail.com
%% References
% If you do use this code in any publication, please include the above
% references.