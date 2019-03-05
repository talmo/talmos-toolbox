function [axHand, figHand] = axgrid(varargin)
%AXGRID Create a tightly spaced grid of axes.
%   [ax, h] = AXGRID(nRows, nCols, SPACING) creates a grid of axes 
%   in a new figure window.  
%
%   Supported "SPACING" options:
%          'none'   :   No spacing between the axes.
%          'tight'  :   Small amount of space between the axes.
%          'normal' :   DEFAULT with just enough space for axis labels.
%          'loose'  :   Similar to the spacing provided by subplot.
%
%   Example usage:
%          [ax, fig] = axgrid(4,2);  % equivalent to axgrid(4,2,'normal')
%          ax = axgrid(3,'tight');
%          ax = axgrid([2 1],'none');
%
%   Copyright 2016 (C) Austin Fite. All rights reserved.

    % default to 'normal' spacing (can be 'none', 'tight', 'normal', or 'loose')
    spacing = 'normal';
    
    % parse inputs for option strings
    if nargin > 0
        options = {'none','tight','normal','loose'};
        
        % test the last input
        if ischar(varargin{end}) 
            if ismember(varargin{end},options)
                % valid option found
                spacing = varargin{end};
                
                % now that we've recorded it, delete the option from varargin
                varargin(end) = [];
            else
                error('MATLAB:axgrid:unsupportedOption',...
                    'Unsupported option: "%s".  Axis spacing can be ''none'', ''tight'', ''normal'', or ''loose''.',varargin{end});
            end
        end
    end

    % varargin should now only contain row/col info
    if numel(varargin) == 0
        % defaults to 2x2 with no inputs
        nRows = 2;
        nCols = 2;
    elseif numel(varargin) == 1
        % create an [N,N] grid for scalar input or [R,C] for nonscalar (2x1) input
        if isscalar(varargin{1}) && ~isnan(varargin{1})
            nRows = varargin{1};
            nCols = varargin{1};
        elseif isnumeric(varargin{1}) && numel(varargin{1}) == 2 && ~any(isnan(varargin{1}))
            nRows = varargin{1}(1);
            nCols = varargin{1}(2);
        else
            % invalid input format
            error('MATLAB:axgrid:invalidInputType','axgrid(N) requires N to be either a 2x1 or a 1x1 array of integers.')
        end
    elseif numel(varargin) == 2
        % require two scalar inputs for axgrid(R,C)
        if all(cellfun(@isscalar, varargin)) && ~any(cellfun(@isnan, varargin))
            nRows = varargin{1};
            nCols = varargin{2};
        else
            error('MATLAB:axgrid:nonscalarInput','For axgrid(R,C), both inputs must be scalar integers.');
        end
    else
        error('MATLAB:axgrid:tooManyInputs',...
            'Too many input arguments. Supported syntax is axgrid(R,C), axgrid(N), or axgrid([R,C]).')
    end
    
    % round inputs in case of non-integer input
    nRows = round(nRows);
    nCols = round(nCols);

    %% Create the new figure
    figHand = figure('renderer','zbuffer','units','normalized','position',[0.05 0.1 0.9 0.8]);
    
    % create axes in default position to start
    axHand = nan(nRows,nCols);
    for iAx = 1:numel(axHand)
        axHand(iAx) = axes('nextplot','add');  %#ok<*LAXES>
        grid(axHand(iAx),'on');
    end
    
    %% Organize the axes into a grid
    
    switch spacing
        case 'none'
            margins = [0 0]; % space between axes in [x,y]
            limitY = 1;      % defines top-right corner of the box that contains the axes
            limitX = 1;      % "
            datumX = 0;      % bottom-left corner of the bounding box
            datumY = 0;      % "
        case 'tight'
            margins = [0.02 0.02];
            limitY = 0.975;
            limitX = 0.9875;
            datumX = 0.04;
            datumY = 0.06;
        case 'normal'
            margins = [0.045 0.08];
            limitY = 0.975;
            limitX = 0.9875;
            datumX = 0.04;
            datumY = 0.06;
        case 'loose'
            margins = [0.06 0.12];
            limitY = 0.975;
            limitX = 0.9875;
            datumX = 0.04;
            datumY = 0.08;
    end
    
    % total whitespace in the x and y directions
    whitespaceX = datumX + margins(1)*(nCols-1) + (1-limitX);
    whitespaceY = datumY + margins(2)*(nRows-1) + (1-limitY);
    
    % size of each axis in the figure is the availableSpace / numAxes
    axWidth = (limitX-whitespaceX)/nCols;
    axHeight = (limitY-whitespaceY)/nRows;
    
    % set the positions of each axis
    for iCol = 1:nCols
        for iRow = 1:nRows
            
            position = [...
                datumX+axWidth*(iCol-1)+margins(1)*(iCol-1),...
                datumY+axHeight*(iRow-1)+margins(2)*(iRow-1),...
                axWidth,...
                axHeight];
            
            set(axHand(iRow,iCol),'position',position);
            
        end
    end

    % need to flip axHand to have the order of its elements match the grid
    % because our datum was the bottom-left corner
    axHand = flipud(axHand);
        
end

