function DI = dunns(D, ind)
%DUNNS Dunn's index for clustering compactness and separation measurement
% Usage: dunns(D, ind)
% 
% Args:
%   D: Dissimilarity matrix
%   ind: Indices for the cluster of each data point

clusters = unique(ind);
denominator=[];

for i = 1:numel(clusters)
    i2 = clusters(i);
    indi=find(ind==i2);
    indj=find(ind~=i2);
    x=indi;
    y=indj;
    temp=D(x,y);
    denominator=[denominator;temp(:)];
end

num=min(min(denominator)); 
neg_obs=zeros(size(D,1),size(D,2));

for i = 1:numel(clusters)
    ix = clusters(i);
    indxs=find(ind==ix);
    neg_obs(indxs,indxs)=1;
end

dem=neg_obs.*D;
dem=max(max(dem));

DI=num/dem;
end