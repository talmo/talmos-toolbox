function pointLocations = markImagePoints(imgax,varname,clr)
% Mark and count objects in an image.
%
% Pass in a handle to an image-containing axes
% (optional; default is returned by imgca);
%
% Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% 3/25/2011
% Extensive modifications 08/2016
%
% Copyright 2016 MathWorks, Inc.


if nargin == 0 || isempty(imgax)
	imgax = imgca;
end
axes(imgax);
imghandle = imhandles(imgax);
if isempty(imghandle)
	error('MarkImagePoints: specified axes does not contain an image!')
end
imghandle = imghandle(1); % Just in case there are multiple images in the axes
parentfig = ancestor(imgax,'figure');
pointLocationsRequested = nargin > 1;
pointLocations = [];
if pointLocationsRequested
	requestedvar = varname;
	if isempty(requestedvar)
		requestedvar = 'MarkedPoints';
	end
end
if nargin < 3
	clr = [1 0 0]; %default = red
end
oldTitleProps = get(get(imgax,'title'));
tmp = title(imgax,'Click to define object(s). Press <Enter> to finish selection.');
set(tmp,'color',clr,...
	'fontsize',10,...
	'fontweight','b',...
	'tag','markImagePoints',...
	'Visible','on');
currBDF = get(imgax,'ButtonDownFcn');
currKPF = get(parentfig,'KeyPressFcn');
set(imgax,'ButtonDownFcn','');
set(imghandle,'ButtonDownFcn',@placePoint);
set(parentfig,'KeyPressFcn',@noMorePoints);

	function roi = impoint2(varargin)
		roi = impoint(varargin{:});
		currentPoints = findall(imgax,'tag','impoint');
		currentLabels = get(findall(findall(imgca,'tag','impoint'),...
				'type','Text'),'String');
		currentNumbers = str2double(currentLabels);
		if all(isnan(currentNumbers))
			currentNumbers = 0;
		end
		pointNumber = max(currentNumbers)+1;
		% GECK: G1107720 Point not draggable, context menu not visible
		% in R2014b until string is set!!!
		setString(roi,num2str(pointNumber))
		l = findobj(roi,'type','hggroup');
		uic = unique( get(l,'UIContextMenu') );
		for u = 1:numel(uic)
			uimenu( uic(u),...
				'Label', 'Delete and Reorder',...
				'Callback', @deleteROI )
		end
		%
		function deleteROI(src,evt) %#ok
			delete(roi);
			% RELABEL AS NECESSARY
			currentPoints = findall(imgax,'tag','impoint');
			currentLabels = get(findall(findall(imgca,'tag','impoint'),...
				'type','Text'),'String');
			currentNumbers = str2double(currentLabels);
			[~,inds] = sort(currentNumbers);
			currentPoints = currentPoints(inds);
			for ii = 1:numel(currentPoints)
				api = iptgetapi(currentPoints(ii));
				api.setString(num2str(ii));
			end
		end %deleteROI
		
	end %impoint2

	function pointLocations = noMorePoints(~,evt)
		finished = strcmpi(evt.Key,'return');
		if finished
			% Delete title, reset original functionality
			set(findall(parentfig,'tag','markImagePoints'),...
				'string',oldTitleProps.String,...
				'color',oldTitleProps.Color,...
				'tag',oldTitleProps.Tag,...
				'fontsize',oldTitleProps.FontSize,...
				'fontweight',oldTitleProps.FontWeight,...
				'visible',oldTitleProps.Visible);
			set(imghandle,'ButtonDownFcn','');
			set(parentfig,'KeyPressFcn','');
			set(imgax,'ButtonDownFcn',currBDF);
			set(parentfig,'KeyPressFcn',currKPF);
			if pointLocationsRequested
				markedPointHandles = findall(imgax,'Tag','circle');
				if numel(markedPointHandles) > 1
					pointLocations = cell2mat([...
						get(markedPointHandles,'xData'),...
						get(markedPointHandles,'yData')]);
				else
					pointLocations = [get(markedPointHandles,'xData'),get(markedPointHandles,'yData')];
				end
				assignin('base',requestedvar,pointLocations);
				figure(parentfig)
			end
			nPoints = findall(imgax,'tag','impoint');
			nPoints = numel(nPoints);
			fprintf('\nYou marked %d objects\n\n',nPoints)
		end
	end

	function placePoint(varargin)
		point_loc = get(imgax,'CurrentPoint');
		point_loc = point_loc(1,1:2);
		impoint2(imgax,point_loc);
	end

end