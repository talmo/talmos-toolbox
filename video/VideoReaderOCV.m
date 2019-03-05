classdef VideoReaderOCV < handle
    %VideoReaderOCV Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filename
        cap
        numFrames
        fps
        width
        height
        channels
        grayscale
        frameIdx
        params
    end
    
    methods
        function obj = VideoReaderOCV(filename, varargin)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            
            defaults = struct();
            defaults.grayscale = [];
            defaults.api = 'FFMPEG';
            params = parse_params(varargin, defaults);
            obj.params = params;
            
            obj.cap = cv.VideoCapture(filename, 'API', params.api);
            
            obj.filename = filename;
            obj.numFrames = obj.cap.FrameCount;
            obj.fps = obj.cap.FPS;
            obj.width = obj.cap.FrameWidth;
            obj.height = obj.cap.FrameHeight;
            obj.channels = 3;
            obj.frameIdx = 1;
            
            if isempty(params.grayscale)
                I = obj.read();
                obj.seek(1);
                obj.grayscale = isequal(I(:,:,1),I(:,:,3));
            else
                obj.grayscale = params.grayscale;
            end
            if obj.grayscale; obj.channels = 1; end
            
        end
        function seek(obj, idx)
            obj.cap.PosFrames = idx - 1;
        end
        function frames = read(obj,idx)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            if nargin < 2 || isempty(idx)
                idx = obj.frameIdx;
            end
            
            frames = zeros(obj.height, obj.width, obj.channels, numel(idx), 'uint8');
            for i = 1:numel(idx)
                if obj.frameIdx ~= idx(i)
                    obj.seek(idx(i));
                end
                I = obj.cap.read();
                if obj.grayscale
                    I = I(:,:,1);
                end
                frames(:,:,:,i) = I;
            end
        end
        
        function frameIdx = get.frameIdx(obj)
            frameIdx = obj.cap.PosFrames + 1;
        end
    end
end

