% This function subdivide the current mesh of B-spline control 
% points to one level up (twise denser). The new size will be
% mg=2*mg-3. The function can subdivide a single mesh or a sequence
% meshes simultaneusly.
%
% The idea is to take each 2D square of 4 (2x2) of B-spline control points
% and upsample it to form a new 2D square of 9 (3x3). And repeat for
% for all B-spline control points
% After upsampling is done, we also need to remove the control points
% around the image border, because they are useless at the higher
% resolution level, and will only add to the computational time.
function Y=mirt2D_subdivide(X, M)

[mg,ng,tmp,tmp]=size(X);

x=squeeze(X(:,:,1,:));
y=squeeze(X(:,:,2,:));

xnew=zeros(mg, 2*ng-2, M);
ynew=zeros(mg, 2*ng-2, M);

xfill=(x(:,1:end-1,:)+x(:,2:end,:))/2;
yfill=(y(:,1:end-1,:)+y(:,2:end,:))/2;
for i=1:ng-1
   xnew(:,2*i-1:2*i,:)=cat(2,x(:,i,:), xfill(:,i,:)); 
   ynew(:,2*i-1:2*i,:)=cat(2,y(:,i,:), yfill(:,i,:)); 
end
xnew=xnew(:,2:end,:);
ynew=ynew(:,2:end,:); 


x=xnew; 
y=ynew; 

xnew=zeros(2*mg-2, 2*ng-3, M);
ynew=zeros(2*mg-2, 2*ng-3, M);

xfill=(x(1:end-1,:,:)+x(2:end,:,:))/2;
yfill=(y(1:end-1,:,:)+y(2:end,:,:))/2;

for i=1:mg-1
   ynew(2*i-1:2*i,:,:)=cat(1,y(i,:,:), yfill(i,:,:)); 
   xnew(2*i-1:2*i,:,:)=cat(1,x(i,:,:), xfill(i,:,:)); 
end
xnew=xnew(2:end,:,:);
ynew=ynew(2:end,:,:);

Y=cat(4, xnew, ynew);
Y=permute(Y,[1 2 4 3]);
Y=2*Y-1;

