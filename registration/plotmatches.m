function h = plotmatches(pts1, pts2)
%PLOTMATCHES Plots a set of matching points.
% Usage:
%   plotmatches(pts1, pts2)
%   h = plotmatches(pts1, pts2)
%


pts1 = validatepoints(pts1);
pts2 = validatepoints(pts2);

N = size(pts1,1);
X = vert([pts1(:,1), pts2(:,1), NaN(N,1)]');
Y = vert([pts1(:,2), pts2(:,2), NaN(N,1)]');

h = gobjects(3,1);

hold on
h(1) = plot(pts1(:,1),pts1(:,2),'go');
h(2) = plot(X, Y,'y-');
h(3) = plot(pts2(:,1),pts2(:,2),'r+');

if nargout < 1
    clear h
end

end

