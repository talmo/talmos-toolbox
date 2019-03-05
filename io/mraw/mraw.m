classdef mraw < handle
    %   mraw.m 
    %   MRAW Read 8 - 16 bit monchrome and color Photron image data as a
    %   class
    %   
    %   C=MRAW('c:\Photron\Filename') loads video infos from
    %   'c:\Photron\Filename' into class C.  
    %
    %   Remarks
    %   -------
    %   This class must be handed the common *.cih and *.mraw file name.
    %   A file extension is not allowed.
    %   This function is intended for color and monochrome 8 to 16 bit
    %   *.mraw files.
    %   NOTE: Both the *.cih file and the *.mraw file are utilized
    %   partly adapted from Autor: SEP          Creation Date: June 20,2013
    %   
    %   Added support for 8 to 16 bit.
    %   Added support for big/little endian bit order.
    %   Added support for variable header information.
    %   Lookup table transformation to 16 bit output.
    %   Included LUT Function to class.
    %   Included Videoplay with VideoFig from João Filipe Henriques.
    %   Autor: Markus Lindner                    Creation Date: Feb 24,2017
    %
    %   Added ExtendedInfos from .cih file
    %   Autor: Markus Lindner                    Creation Date: Mar 23,2017
    %
    %   Examples
    %   --------
    %   % Load image 10
    %       C=mraw('c:\Photron\Moviefile');
    %       Image = C.getFrame(10);
    %   % Access camera setup Framerate
    %       fRate = C.FrameRate;
    %   % Play whole Video with LUT
    %       C = mraw('c:\Photron\Moviefile');
    %       lastImage = C.TotalFrames;
    %       C.makeLut(0,200,1);
    %       for i = 1:lastImage
    %           imshow(C.getFrame_uint8(i))
    %       end
    %   Play whole Video with included Player
	%       C = mraw('c:\Photron\Moviefile');
	%       C.play;

   properties (Access = public)
      Filename
      TotalFrames
      Width
      Height
      Pixels
      FrameRate
      SeqSize
      ColorBit
      ColorType
      BitDepth
	  BitSide
      Lut
      ExtendedInfos
   end
   properties (Access = private)
      FidVideo
   end
   methods
      function delete(obj)
        % Deconstructor - closes Files when Object gets destroyed  
        fclose(obj.FidVideo);
      end
      
      function obj = mraw(val)
        % Constructor - creates Camera Setup and opens Video file
        obj.Filename = val;
        fid1=fopen(sprintf('%s.cih',obj.Filename),'r');
        obj.FidVideo=fopen(sprintf('%s.mraw',obj.Filename),'r');
        % Check if Files loaded
        if fid1<1 || obj.FidVideo<1 
            disp([num2str(datestr(now)), ': MRAW-Files could not be found!']);
            return;
        end
        % Read Header Information
        Header=textscan(fid1,'%s','delimiter',':');
        trigger = cell2mat(Header{1,1}(find(strcmp('Trigger Mode ',Header{1,1})==1)+1));
        obj.TotalFrames=str2double(cell2mat(Header{1}(find(strcmp('Total Frame ',Header{1,1})==1)+1)));
        obj.Width=str2double(cell2mat(Header{1}(find(strcmp('Image Width ',Header{1,1})==1)+1)));
        obj.Height=str2double(cell2mat(Header{1}(find(strcmp('Image Height ',Header{1,1})==1)+1)));
        obj.FrameRate=str2double(cell2mat(Header{1}(find(strcmp('Record Rate(fps) ',Header{1,1})==1)+1)));
        obj.ColorBit=str2double(cell2mat(Header{1}(find(strcmp('Color Bit ',Header{1,1})==1)+1)));
        obj.ColorType=cell2mat(Header{1}(find(strcmp('Color Type ',Header{1,1})==1)+1));
        obj.BitDepth=str2double(cell2mat(Header{1}(find(strcmp('EffectiveBit Depth ',Header{1,1})==1)+1)));
        obj.BitSide=cell2mat(Header{1}(find(strcmp('EffectiveBit Side ',Header{1,1})==1)+1));
        posTrig = find(trigger == ' ');
        if ~isempty(posTrig) 
            obj.SeqSize = str2double(trigger(posTrig(1)+1:end));
        else
            obj.SeqSize = trigger;
        end
        obj.Pixels=obj.Width*obj.Height;
        fclose(fid1);
        
        fid1=fopen(sprintf('%s.cih',obj.Filename),'r');
        % ExtendedInfos einlesen
        delimiter = ':';
        endRow = 226;
        formatSpec = '%s%s%*s%[^\n\r]';
        cihdata = textscan(fid1, formatSpec, endRow, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'ReturnOnError', false, 'EndOfLine', '\r\n');
        fclose(fid1);
        obj.ExtendedInfos = deblank([cihdata{1:end-1}]);
      end
      
      function A = getFrame(obj, n)
        % Load Frame n
        first_frame=n;
        bitOrder = 'n';
        if obj.ColorBit ~= 16
            switch obj.BitSide
                case 'Lower'
                    bitOrder = 'b';
                case 'Higher'
                    bitOrder = 'l';
            end
        end
        % Color Image 3x12Bit
        if strcmp(obj.ColorType,'Color')
            color = 3;
        else
            color = 1;
        end
        % Load Images
        start = (first_frame-1)*obj.Pixels*obj.ColorBit/8;
        fseek(obj.FidVideo,start,'bof');
        if color == 3
            I=zeros(obj.Pixels,3,'uint16');
            N=[obj.Width obj.Height 3];
        else
            I=zeros(obj.Pixels,1,'uint16');
            N=[obj.Width obj.Height];
        end
        % Store Images to Mat
        if color == 3
            pixelRGB = (fread(obj.FidVideo,obj.Pixels*color,['ubit' num2str(obj.ColorBit/color) '=>uint16'],bitOrder));
            I(:,1) = pixelRGB(1:3:end,:);
            I(:,2) = pixelRGB(2:3:end,:);
            I(:,3) = pixelRGB(3:3:end,:);
            A(:,:,:)=permute(reshape(I,N),[2 1 3]);  
        else
            I = (fread(obj.FidVideo,obj.Pixels,['ubit' num2str(obj.ColorBit) '=>uint16'],bitOrder));
            A(:,:)=permute(reshape(I,N),[2 1 3]);  
        end    
      end
      
      function obj = makeLut(obj, min_val, max_val, gamma)
        % create LUT and store in property
        lut=zeros(1,65536,'uint16');
        step=cast((max_val-min_val),'double');
        step=step/256.0;   
        v=0;
        wert=cast(min_val,'double');
        for i=min_val:max_val
            if(i>=wert)
                while(wert<i)
                    wert=wert+step;
                    v=v+1;
                end     
            end    
            if v>255
                v=255;
            end 
            lut(i+1)=cast(v,'uint16');
        end
        for i=max_val:65535
            lut(i)=255;   
        end
        obj.Lut = uint16( 255*(double(lut) / 255) .^ (gamma) );
      end
      
      function A = getFrame_uint8(obj, n)
        % uses LUT and casts to uint8 image
        if isempty(obj.Lut)
            obj.makeLut(0,4096,1);
        end
        B = obj.getFrame(n);
        A = cast(intlut(uint16(B),obj.Lut),'uint8'); 
      end
      
      function redraw(obj, n)
        imshow(obj.getFrame_uint8(n));
        text(5, 5, ['# ' num2str(n)], 'Color', 'white')
      end
      
      function play(obj)
        obj.videofig(@(frm) obj.redraw(frm));
        obj.redraw(1);
        disp('Enter -- play/pause')
        disp('Backspace -- play/pause slower')
        disp('Right/left -- advance/go back one frame')
        disp('Page down/page up -- advance/go back 30 frames')
        disp('Home/end -- go to first/last frame')
      end
      
      function [fig_handle, axes_handle, scroll_bar_handles, scroll_func] = ...
            videofig(obj, redraw_func)
        %VIDEOFIG Figure with horizontal scrollbar and play capabilities.
        %
        %   The keyboard shortcuts are:
        %     Enter (Return) -- play/pause video (25 frames-per-second default).
        %     Backspace -- play/pause video 5 times slower.
        %     Right/left arrow keys -- advance/go back one frame.
        %     Page down/page up -- advance/go back 30 frames.
        %     Home/end -- go to first/last frame of video.
        %
        %   Author: João Filipe Henriques, 2010
        %   Editor: Markus Lindner, 2017

        %default parameter values
        play_fps = 25;  %play speed (frames per second)
        big_scroll = 30; %page-up and page-down advance, in frames
        key_func = [];
        num_frames = obj.TotalFrames;

        %check arguments
        check_int_scalar(num_frames);
        check_callback(redraw_func);
        check_int_scalar(play_fps);
        check_int_scalar(big_scroll);
        check_callback(key_func);

        click = 0;
        f = 1;  %current frame

        %initialize figure
        fig_handle = figure('Name', obj.Filename, 'Color',[.1 .1 .1], 'MenuBar','none', 'Units','norm', ...
            'WindowButtonDownFcn',@button_down, 'WindowButtonUpFcn',@button_up, ...
            'WindowButtonMotionFcn', @on_click, 'KeyPressFcn', @key_press);

        %axes for scroll bar
        scroll_axes_handle = axes('Parent',fig_handle, 'Position',[0 0 1 0.03], ...
            'Visible','off', 'Units', 'normalized');
        axis([0 1 0 1]);
        axis off

        %scroll bar
        scroll_bar_width = max(1 / num_frames, 0.01);
        scroll_handle = patch([0 1 1 0] * scroll_bar_width, [0 0 1 1], [.8 .8 .8], ...
            'Parent',scroll_axes_handle, 'EdgeColor','none', 'ButtonDownFcn', @on_click);

        %timer to play video
        play_timer = timer('TimerFcn',@play_timer_callback, 'ExecutionMode','fixedRate');

        %main drawing axes for video display
        axes_handle = axes('Position',[0 0.03 1 0.97]);

        %return handles
        scroll_bar_handles = [scroll_axes_handle; scroll_handle];
        scroll_func = @scroll;

        function key_press(src, event)  %#ok, unused arguments
            switch event.Key  %process shortcut keys
            case 'leftarrow'
                scroll(f - 1);
            case 'rightarrow'
                scroll(f + 1);
            case 'pageup'
                if f - big_scroll < 1  %scrolling before frame 1, stop at frame 1
                    scroll(1);
                else
                    scroll(f - big_scroll);
                end
            case 'pagedown'
                if f + big_scroll > num_frames  %scrolling after last frame
                    scroll(num_frames);
                else
                    scroll(f + big_scroll);
                end
            case 'home'
                scroll(1);
            case 'end'
                scroll(num_frames);
            case 'return'
                play(1/play_fps)
            case 'backspace'
                play(5/play_fps)
                otherwise
                if ~isempty(key_func)
                    key_func(event.Key);  % %#ok, call custom key handler
                end
            end
        end

        %mouse handler
        function button_down(src, event)  %#ok, unused arguments
            set(src,'Units','norm')
            click_pos = get(src, 'CurrentPoint');
            if click_pos(2) <= 0.03  %only trigger if the scrollbar was clicked
                click = 1;
                on_click([],[]);
            end
        end

        function button_up(src, event)  %#ok, unused arguments
            click = 0;
        end

        function on_click(src, event)  %#ok, unused arguments
            if click == 0, return; end

            %get x-coordinate of click
            set(fig_handle, 'Units', 'normalized');
            click_point = get(fig_handle, 'CurrentPoint');
            set(fig_handle, 'Units', 'pixels');
            x = click_point(1);

            %get corresponding frame number
            new_f = floor(1 + x * num_frames);

            if new_f < 1 || new_f > num_frames, return; end  %outside valid range

            if new_f ~= f  %don't redraw if the frame is the same (to prevent delays)
                scroll(new_f);
            end
        end

        function play(period)
            %toggle between stoping and starting the "play video" timer
            if strcmp(get(play_timer,'Running'), 'off')
                set(play_timer, 'Period', period);
                start(play_timer);
            else
                stop(play_timer);
            end
        end
        function play_timer_callback(src, event)  %#ok
            %executed at each timer period, when playing the video
            if f < num_frames
                scroll(f + 1);
            elseif strcmp(get(play_timer,'Running'), 'on')
                stop(play_timer);  %stop the timer if the end is reached
            end
        end

        function scroll(new_f)
            if nargin == 1  %scroll to another position (new_f)
                if new_f < 1 || new_f > num_frames
                    return
                end
                f = new_f;
            end

            %convert frame number to appropriate x-coordinate of scroll bar
            scroll_x = (f - 1) / num_frames;

            %move scroll bar to new position
            set(scroll_handle, 'XData', scroll_x + [0 1 1 0] * scroll_bar_width);

            %set to the right axes and call the custom redraw function
            set(fig_handle, 'CurrentAxes', axes_handle);
            redraw_func(f);

            %used to be "drawnow", but when called rapidly and the CPU is busy
            %it didn't let Matlab process events properly (ie, close figure).
            pause(0.01)
        end

        %convenience functions for argument checks
        function check_int_scalar(a)
            assert(isnumeric(a) && isscalar(a) && isfinite(a) && a == round(a), ...
                [upper(inputname(1)) ' must be a scalar integer number.']);
        end
        function check_callback(a)
            assert(isempty(a) || strcmp(class(a), 'function_handle'), ...
                [upper(inputname(1)) ' must be a valid function handle.'])
         end
      end
   end
end