%% |hfill| and |vfill|
% These functions create horizontal or vertical shaded regions on a plot.
% The syntax for both functions is the same.  
%
%% Syntax 
% 
%  hfill(scalarValue)
%  hfill([ystart yend])
%  hfill([ystart1,yend1,ystart2,yend2,...,ystartn,yendn])
%  hfill(...,ColorSpec)
%  hfill(...,ColorSpec,'PatchProperty','PatchValue')
%  hfill(...,'bottom')
%  h = hfill(...)
% 
%% Description 
% 
% |hfill(scalarValue)| places a horizontal line along y = scalarValue.
%
% |hfill([ystart yend])| fills a horizontal shaded region bounded by
% |ystart| and |yend|. 
%
% |hfill([ystart1,yend1,ystart2,yend2,...,ystartn,yendn])| fills multiple
% horizontal regions.
%
% |hfill(...,ColorSpec)| defines the face color of the patch(es) created by
% |hfill|. |ColorSpec| can be one of the Matlab color names (e.g. |'red'|),
% abbreviations (e.g. |'r'|, or rgb triplet (e.g. [1 0 0]). |ColorSpec| may
% also be |'gray'|. 
%
% |hfill(...,ColorSpec,'PatchProperty','PatchValue')| defines patch properties
% such as |'EdgeColor'| and |'FaceAlpha'|. 
% 
% |hfill(...,'bottom')| places the newly created patch(es) at the bottom of
% the |uistack|.  
%
% |h = hfill(...)| returns handle(s) of newly created patch objects. 
% 
%% Examples of |hfill|
% Let's start with a curve, and then plot some |hfill| objects: 
% 
plot(0:100,(0:100).^2,'linewidth',2)

%% 
% Add a horizontal line at _y_ = 7000:  

hfill(7000)

%% 
% Add a blue horizontal line at _y_ = 500:

hfill(500,'b')

%% 
% Add a red horizontal line at _y_ = 700:

hfill(700,[1 0 0])

%% 
% Add a gray patch from _y_ = 1000 to _y_ = 2000: 

hfill([1000 2000],'gray')

%% 
% Make several semitransparent green horizontal patches with dotted red
% edges: 

hfill(3000:500:6500,'g','facealpha',.6,'edgecolor','r','linestyle',':')

%% 
% Place a red patch behind everything: 

hfill([8000 9000],'red','bottom')

%% Examples of |vfill|
% Syntax for |vfill| follows |hfill|: 

figure
plot(0:100,(0:100).^2,'linewidth',2)
vfill([80 90],'gray')
vfill([5 15; 30 50],'g','facealpha',.6,'edgecolor','r','linestyle','--')
vfill([65 75],'r','bottom')

vfill(59)
vfill([22 23; 24 25],'y','edgecolor','none')

%% Author Info
% These functions were created by Chad A. Greene of the University of Texas
% Institute for Geophysics (<http://www.ig.utexas.edu/research/cryosphere/
% UTIG>), August 2013.  Updated August 2014. 