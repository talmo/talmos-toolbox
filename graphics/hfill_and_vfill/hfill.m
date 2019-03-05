function [h] = hfill(ybounds,ColorSpec,varargin)
% h = hfill(ybounds,ColorSpec,varargin) creates fill objects bounded by 
% the values ybounds.  ColorSpec defines the color of the fill objects. 
% Optional varargin can be used to set edgecolor, transparency, etc.
% varargin must be in the form of name-value pairs (e.g., 'facealpha',.5 )
% Optional output h is the handle(s) of each patch object.  
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
% hfill(scalarValue) places a horizontal line along y = scalarValue.
%
% hfill([ystart yend]) fills a horizontal shaded region bounded by
% ystart and yend. 
%
% hfill([ystart1,yend1,ystart2,yend2,...,ystartn,yendn]) fills multiple
% horizontal regions.
%
% hfill(...,ColorSpec) defines the face color of the patch(es) created by
% hfill. ColorSpec can be one of the Matlab color names (e.g. 'red'),
% abbreviations (e.g. 'r', or rgb triplet (e.g. [1 0 0]). ColorSpec may
% also be 'gray'. 
%
% hfill(...,ColorSpec,'PatchProperty','PatchValue') defines patch properties
% such as 'EdgeColor' and 'FaceAlpha'. 
% 
% hfill(...,'bottom') places the newly created patch(es) at the bottom of
% the uistack.  
%
% h = hfill(...) returns handle(s) of newly created patch objects. 
% 
% 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
% INPUTS: 
% ybounds   Bounding values of area(s) to be filled. Can be in any of the
%           following forms: 
%           ybounds = [ystart1,yend1,ystart2,yend2,...,ystartn,yendn]
% 
%           ybounds = [ystart1 yend1;
%                      ystart2 yend2;
%                      ...
%                      ystartn yendn];
%
%           ybounds = [ystart1 ystart2 ... ystartn;
%                      yend1   yend2   ... yendn];
% 
%           ybounds = scalarvalue produces a horizontal line at scalarvalue. 
% 
% ColorSpec Defines the color of the patch(es) to be created. Can be RGB 
%           value (e.g., [0 1 0]), short name (e.g., 'g'), or long name 
%           (e.g. 'green'). Also supports the 'gray' for 50% gray.
% 
% varargin  List of name-value pairs such as 'facealpha',.5,'edgecolor','r'.
% 
% varargin can also include the tag 'bottom' or 'back' to send the patch to the back.
% 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
% EXAMPLE: 
% 
% plot(0:100,(0:100).^2,'linewidth',2)
% hfill([1000 2000],'gray')
% hfill(3000:500:6500,'g','facealpha',.6,'edgecolor','r','linestyle',':')
% hfill([8000 9000],[1 0 0],'bottom')
% 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
% Chad A. Greene, August 15, 2013. 
% * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
%
% See also vfill. 

assert(nargin>0,'The hfill function requires at least one input.')
if ~exist('ColorSpec','var')
    ColorSpec = 'k'; 
end

plotbehind=false; 
assert(isnumeric(ybounds)==1,'ybounds must be numeric.') 
if length(ybounds)==1
    ybounds(2)=ybounds(1);
    varargin{length(varargin)+1} = 'edgecolor'; 
    varargin{length(varargin)+1} = ColorSpec; 
    
end
    
nyb = numel(ybounds); % number of elements in ybounds. 
if mod(nyb,2)
    fprintf('Number of bounding values must be even.');
    fprintf('In other words, enter start and end values for fill bounds.');
    return
end

if strcmpi(ColorSpec,'gray')||strcmpi(ColorSpec,'grey')
    ColorSpec = .5*[1 1 1];
end

for k = 1:length(varargin)
    if strcmpi(varargin{k},'bottom')||strcmpi(varargin{k},'back')
        plotbehind = true;
        varargink=k; 
    end
end

if plotbehind
    varargin(varargink,:)=[];
end
        
% Sort ybounds and start assuming they are in the order
% [ystart1,yend1,ystart2,yend2,...,ystartn,yendn]
syb=sort(reshape(ybounds,nyb,1)); % sorted y bounds

% Current axis properties: 
xlim = get(gca,'xlim');
initialHoldState = ishold(gca);
hold on

% Plot the patches: 
n=0; % a counter
h = NaN(nyb/2,1); % preallocate patch handles for speed. 
for k = 1:2:nyb-1; 
    n=n+1;
    h(n) = fill([xlim(1) xlim(2) xlim(2) xlim(1)],...
        [syb(k) syb(k) syb(k+1) syb(k+1)],ColorSpec);
end

% Set optional input properties as name-value pairs: 
try
    [~]=set(h(:),varargin{:});
end
    
% Return hold state: 
if initialHoldState==0
    hold off;
end

if plotbehind
    uistack(h,'bottom');
end

if nargout==0
    clear h; 
end

end