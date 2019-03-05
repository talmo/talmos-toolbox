% mirt2Dgroup_frame The main function for groupwise non-rigid registration 
% of a sequence of 2D images using cubic B-spline based transformation parametrization. 
% Frame by frame mode.
%
%   Input
%   ------------------ 
%   a           3D matrix of the image sequence of size MxNxK, where K is the
%               number of images (frames).
%   main        a structure of main MIRT options
%
%       .similarity=['ssd','sad','rc','cc','cd2','ms','mi']  
%               Similarity measure.
%       .okno (default 16) mesh window size between the B-spline
%               control points. The mesh cell is square.
%       .subdivide (default 3) - a number of hierarchical levels. 
%               E.g. for main.subdivide=3 the registration is carried sequentially
%               at image size 2^(3-1)=4 times smaller, 2^(2-1)=2 times smaller and the 
%               original size. The mesh window size remain the same for all levels.
%       .lambda (default 0.1) - a regularization weight. A regularization
%               is defined as Laplacian (or curvature) penalization of the
%               displacements of B-spline control points.
%       .alpha (default 1) - a parameter of the similarity measure, for
%               e.g. alpha value of the Residual Complexity.
%       .single (default 0) show mesh deformation at each iteration
%       .group (0,1, or 2, default 1) a method of groupwise registration: 0-everything to the 
%               first frame, 1 - the next to the previous frame, 2 - the
%               next to the moving average of the previous frames (accumulated memory)
%
%   optim      a structure of optimization related options
%
%       .maxsteps (default 150) Maximum number of iterations.
%       .fundif (default 1e-5) Tolerance stopping criterion.
%       .gamma (default 0.1) Initial optimization step size.
%       .anneal (default 0.9) The multiplicative constant to update the
%                            step size
%
%   Output
%   ------------------ 
%   res      structure of the resulting parameters:
%
%           .X       a matrix of final nodes
%           .okno    window size (equal to the initial main.okno).
%
%   Examples
%   --------
%
%   See many detailed examples in the 'examples' folder.
%
%   See also  mirt2Dgroup_sequence, MIRT_GUI



% Copyright (C) 2007-2010 Andriy Myronenko (myron@csee.ogi.edu)
% also see http://www.bme.ogi.edu/~myron/matlab/MIRT/
%
%     This file is part of the Medical Image Registration Toolbox (MIRT).
%
%     The source code is provided under the terms of the GNU General Public License as published by
%     the Free Software Foundation version 2 of the License.



function res=mirt2Dgroup_frame(a, main, optim)


% Check the input options and set the defaults
if nargin<1, error('mirt2Dgroup_sequence error! Not enough input parameters.'); end;

% Check the proper parameter initilaization
[main,optim]=mirt_check(main,optim,nargin+1);


tic
if ischar(a),load(a); end

if ~isfield(optim,'progressbar'), optim.progressbar=0; end;
if optim.progressbar, h = waitbar(0,'Please wait...'); end;

disp('Starting groupwise 2D stabilization.');
disp('Preprocessing...');


dimen=size(a);
% Size atthe smalles hierarchical level
M=ceil(dimen(1:2)/2^(main.subdivide-1));


% Generate B-splines mesh of control points
[x, y]=meshgrid(1-main.okno:main.okno:M(2)+2*main.okno, 1-main.okno:main.okno:M(1)+2*main.okno);
[mg{1}, ng{1}]=size(x);
% new image size
main.siz=[(mg{1}-3)*main.okno (ng{1}-3)*main.okno dimen(3)];


X=cat(3,x,y);  % Initial B-spline control points mesh
main.Xgrid=X;  % save the regular grid
res.X=repmat(X,[1 1 1 dimen(3)]);

main.F=mirt2D_F(main.okno);


% leave only image described by nodes
ab=nan(2^(main.subdivide-1)*main.siz(1), 2^(main.subdivide-1)*main.siz(2), dimen(3));
ab(1:dimen(1), 1:dimen(2), 1:dimen(3))=a;
clear a;

% preprocessing for sublivels
for level=2:main.subdivide
        mg{level}=2*mg{level-1}-3;
        ng{level}=2*ng{level-1}-3;
end


% the first frame is the reference
siz=[(mg{1}-3)*main.okno (ng{1}-3)*main.okno];
main.refimsmall=imresize(ab(:,:,1),siz,'bicubic');   
main.refimsmall(main.refimsmall<0)=0;  
main.refimsmall(main.refimsmall>1)=1;



%% Starting sub levels loop
for level=1:main.subdivide
    if optim.progressbar,  waitbar(0,h,['Processing level ' num2str(level) ' out of ' num2str(main.subdivide) '.']); end;
    
    main.level=level;
      
    main.mg=mg{level}; main.ng=ng{level};
    main.siz=[(mg{level}-3)*main.okno (ng{level}-3)*main.okno];
    %main.refimsmall=cutimsmall;
    
    main.K=mirt2D_initK([main.mg main.ng]);
  
    %% Strating loop optimization for a given sublevel
    iter=1;    
    
    for volume=2:dimen(3)
        
        if optim.progressbar, waitbar(iter*volume/(optim.maxcycle*dimen(3)),h); end;
        
        main.volume=volume;
        disp(['Processing image ' num2str(volume) ' out of ' num2str(dimen(3))]);
        
        % resize and concatinate
        imsmall=imresize(ab(:,:,volume),main.siz,'bicubic');
        imsmall(imsmall<0)=0;
        imsmall(imsmall>1)=1;
        
        [gradx, grady]=gradient(imsmall);
        main.imsmall=cat(3,imsmall, gradx,grady);
        clear imsmall gradx grady;
        
        
        [res.X(:,:,:,volume), imsmall]=mirt2D_registration(res.X(:,:,:,volume), main, optim);
        
        
        % choose the sequention group mode (0:everything to the first, 1: next to the previous 2: next to the prevous average)
        switch main.group
            case 1
                main.refimsmall=imsmall; % register the next frame to the previous one
            case 2
                main.refimsmall=0.5*(main.refimsmall+imsmall); % register the next frame to the privious moving average (accumulated memory)
        end     % otherwise the reference frame remains the same (the very first frame)
                
                
        iter=iter+1;
        
        
    end
    
    % if the sublevel is not last prepear for the next level
    if level<main.subdivide
        siz=[(mg{level+1}-3)*main.okno (ng{level+1}-3)*main.okno];
        res.X=mirt2D_subdivide(res.X, dimen(3));
        main.Xgrid=mirt2D_subdivide(main.Xgrid, 1);
        main.refimsmall=imresize(main.refimsmall,siz,'bicubic');

    end
    
end

res.okno=main.okno;

if optim.progressbar, close(h); end;

disp('Registration succesfully completed.')
disptime(toc);

