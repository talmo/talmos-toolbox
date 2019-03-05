%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is main function for translation compensation
% 
% input
%               a - 3D matrix [m,n,k]=size(a)
%                       where m,n - image size
%                       k - number of frames
%
% output
%               d-3D matrix after translation
%                       in general image size in d is s
%
% Andriy Myronenko
% 04 May. 2010
%
% This file is part of Medical Image Registration Toolkit 
% For all questions contact (myron@csee.ogi.edu)

function B = mirt2D_translation2(A, resize, neighbor, progress)

[M, N, k] =size(A);
U(1,:)=[0 0];count=0;             

if ~exist('resize','var') || isempty(resize), resize = 2; end; % build a graph with 2 neighbours connectivity (min=1, max=k)
if ~exist('neighbor','var') || isempty(neighbor), neighbor = 2; end;
if ~exist('progress','var') || isempty(progress), progress = 0; end; % do not show the progress bar by default

if k==1, return; end;
neighbor=min(k-1,neighbor);


% Step 1
if progress, h = waitbar(0,'Translation compensation. Preprocessing. Please wait...'); end;
for i=1:k,
  if progress, waitbar(i/k,h); end;
  a(:,:,i)=imadjust(imresize(A(:,:,i),1/resize));
  tmp=mirt_dctn(a(:,:,i)); tmp(1:2,1:2)=0;
  a(:,:,i)=mirt_idctn(tmp);
end

[m, n, k] =size(a);

% Step 2
if progress,  waitbar(0,h,'Translation compensation. Processing. Please wait...'); end;

for i=1:k-neighbor,
    if progress, waitbar(i/(k-neighbor),h); end;
    for j=i+1:i+neighbor,
       
         
        c = normxcorr2(a(:,:,j),a(:,:,i));
        [max_c, imax] = max(c(:));
        [iy,jx]=find(c>max_c(1)*0.99);
        
        for ij=1:length(iy)
       
        count =count+1;
        first(count)=j;
        second(count)=i;
        W(count)=c(sub2ind(size(c),iy(ij),jx(ij)));
       % [ypeak, xpeak] = ind2sub(size(c),imax(1));
        
        U(count+1,:) = [jx(ij)-n iy(ij)-m];
        
        end
        
    end
end

if progress,waitbar(0,h,'Translation compensation. Post-processing. Please wait...'); end;

S=sparse([1 2:count+1 2:count+1],[1 first second],[1 ones(1,count) -ones(1,count)],count+1,k);


% Solve linear system using Iterative Least Squares
% Alternatively try direct solution T=round(S\U);

U=U*resize;
W(W<0)=0;
W=[1;W'];
W=spdiags(W,0,count+1,count+1);



W2=speye(count+1,count+1);
T=0;Told=100; 
for i=1:10000
    if norm(T-Told,'fro')<1e-5, break; end
    Told=T;
    T=inv(S'*(W*W2)*S)*S'*(W*W2)*U;
    W2=spdiags(1./(W*sqrt((S*T-U).^2+1e-6)),0,count+1,count+1);
end

%T=inv(S'*W*S)*S'*W*U;

T=round(T);
    

% Interpolate images
T=T-repmat(min(T),k,1);
maxT=max(T);

B=nan(maxT(2)+M,maxT(1)+N,k);
x=1:N;y=1:M;
for i=1:k,
 if progress, waitbar(i/k,h); end;
 B(y+T(i,2),x+T(i,1),i)=A(:,:,i);
end

if progress, close(h); end;