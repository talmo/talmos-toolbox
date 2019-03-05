classdef CPDNonRigid < images.geotrans.internal.GeometricTransformation
        
    properties
        % Nonrigid transform parameters
        beta
        W
        shift
        s
        Yorig
        mode
        block_sz
        fgt_models
        fgt_params
    end
    
    
    methods
        
        function self = CPDNonRigid(Transform, mode)
            %CPDNonRigid Implements a GeometricTransformation with the
            %parameters and methods from Coherent Point Drift.
            %
            % Transform is the output from cpd_register()
            
            % Define required property from base class
            self.Dimensionality = 2;
            
            % Save transform parameters
            self.beta = Transform.beta * Transform.normal.yscale;
            self.W = Transform.normal.xscale * Transform.W;
            self.shift = Transform.normal.xd - Transform.normal.xscale / Transform.normal.yscale * Transform.normal.yd;
            self.s = Transform.normal.xscale / Transform.normal.yscale;
            self.Yorig = Transform.Yorig;
            
            % Mode to calculate forward mapping
            if nargin < 2
                mode = 'full';
            end
            self.mode = mode;
            self.block_sz = 1e5;
            
            if strcmp(self.mode, 'fgt')
                % Parameters
                params.e = 8;      % Ratio of far field (default e = 10)
                params.K = round(min([sqrt(length(self.Yorig)) 100])); % Number of centers (default K = sqrt(Nx))
                params.p = 6;      % Order of truncation (default p = 8)
                params.hsigma = sqrt(2) * self.beta;
                
                % Create models
                [models(1).xc , models(1).A_k] = fgt_model(self.Yorig', self.W(:, 1)', params.hsigma, params.e);
                [models(2).xc , models(2).A_k] = fgt_model(self.Yorig', self.W(:, 2)', params.hsigma, params.e);
                
                % Save to properties
                self.fgt_models = models;
                self.fgt_params = params;
            end
            
        end
        
        function G = findG(self, x)
            % Constructs a full-rank Gaussian affinity matrix
            % From: cpd_G
            
            k = -2 * self.beta ^ 2;
            n = size(x, 1);
            m = size(self.Yorig, 1);
            
            G = repmat(x, [1 1 m]) - permute(repmat(self.Yorig, [1 1 n]), [3 2 1]);
            G = reshape(sum(G .^ 2, 2), n, m) / k;
            G = exp(G);
        end
        
        function [Q, S] = findQS(self, Y)
            % Computes Q and S using a low-rank approximation
            % From: cpd_GRBF_lowrankQS
            
            M=size(Y, 1);
            hsigma=sqrt(2)*self.beta;

            OPTS.issym=1;
            OPTS.isreal=1;
            OPTS.disp=0;

            % if we do not use FGT we can construct affinity matrix G and find the
            % first eigenvectors/values directly
            if ~self.eigfgt
               G=self.findG(Y);
               [Q,S]=eigs(G,self.numeig,'lm',OPTS);
               return; % stop here
            end 

            %%% FGT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % if we use FGT than we can find eigenvectors without constructing G,
            % all we need to give is the matrix vector product Gx, which can be
            % implemented through FGT.

            e          = 8;      % Ratio of far field (default e = 10)
            K          = round(min([sqrt(M) 100])); % Number of centers (default K = sqrt(Nx))
            p          = 6;      % Order of truncation (default p = 8)


            [Q,S]=eigs(@grbf,M,self.numeig,'lm',OPTS);


            function y=grbf(x,beta) % return y=Gx, without explicitelly constructing G
                [xc , A_k] = fgt_model(Y' , x', hsigma, e,K,p);
                y = fgt_predict(Y' , xc , A_k , hsigma,e);
            end
            
        end
        
        function GW = fgt(self, X)
            % Uses Fast Gaussian Transform to calculate G * W

            % Predict using saved models
            GW = [fgt_predict(X', self.fgt_models(1).xc, self.fgt_models(1).A_k, self.fgt_params.hsigma, self.fgt_params.e)', ...
                  fgt_predict(X', self.fgt_models(2).xc, self.fgt_models(2).A_k, self.fgt_params.hsigma, self.fgt_params.e)'];
        end
        
        function XY = apply_tform(self, UV)
            % Applies inverse mapping to points.
            % From: cpd_transform
            
            % T = Y + G * W
            % XY = UV + G * W
            
            % Accounting for normalization:
            % XY = UV * s + ... % scaling
            %      G * W + ...  % displacement
            %      shift        % translational offset
            
            switch self.mode
                case 'lowrank'
                    % Use low-rank approximation to G * W
                    %    G * W = Q * (S * (Q' * W))
                    % doesn't actually work unless using original points

                    [Q, S] = self.findQS(UV);
                    XY = UV * self.s + ...
                         (Q * (S * (Q' * self.W))) + ...
                         repmat(self.shift, size(UV, 1), 1);
                     
                case 'full'
                    % Compute full-rank G
                    G = self.findG(UV);
                    XY = UV * self.s + ...
                         G * self.W + ...
                         repmat(self.shift, size(UV, 1), 1);
                     
                case 'block'
                    % Compute full-rank in blocks
                    
                    % Pre-allocate output points matrix
                    XY = UV;
                    
                    % Solve displacement in blocks
                    n = size(UV, 1);
                    for i = 1:self.block_sz:n
                        % Block indices
                        I = [i, min(i + self.block_sz - 1, n)];
                        
                        % Calculate displacement
                        XY(I(1):I(2), :) = self.findG(UV(I(1):I(2), :)) * self.W;
                    end
                    
                    % Calculate final points
                    XY = UV * self.s + ... % scaled original points
                         XY + ... % displacement
                         repmat(self.shift, size(UV, 1), 1); % translation
                     
                case 'parblock'
                    % Same as block but in parallel
                    
                    % Prepare for parallelization
                    n = size(UV, 1);
                    sz = self.block_sz;
                    idxA = 1:sz:n;
                    idxB = min(idxA + sz - 1, n);
                    num_blocks = length(idxA);
                    XY = arrayfun(@(ia, ib) UV(ia:ib, :), idxA, idxB, 'UniformOutput', false);
                    G = @self.findG;
                    W = self.W;
                    
                    % Solve displacement in blocks
                    parfor i = 1:num_blocks
                        % Calculate displacement
                        XY{i} = G(XY{i}) * W;
                    end
                    
                    % Merge points
                    XY = vertcat(XY{:});
                    
                    % Calculate final points
                    XY = UV * self.s + ... % scaled original points
                         XY + ... % displacement
                         repmat(self.shift, size(UV, 1), 1); % translation
                     
                case 'fgt'
                    % Use Fast Gaussian Transform to approximate G*W
                    XY = UV * self.s + ... % scaling
                        self.fgt(UV) + ... % approximation to G*W
                        repmat(self.shift, size(UV, 1), 1); % translation
            end
        end
        
        function varargout = transformPointsInverse(self,varargin)
            %transformPointsInverse Apply inverse geometric transformation
            %
            %   [u,v] = transformPointsInverse(tform,x,y)
            %   applies the inverse transformation of tform to the input 2-D
            %   point arrays x,y and outputs the point arrays u,v. The
            %   input point arrays x and y must be of the same size.
            %
            %   U = transformPointsInverse(tform,X)
            %   applies the inverse transformation of tform to the input
            %   Nx2 point matrix X and outputs the Nx2 point matrix U.
            %   transformPointsFoward maps the point X(k,:) to the point
            %   U(k,:).
            
            if numel(varargin) > 1
                x = varargin{1};
                y = varargin{2};
                
                validateattributes(x,{'single','double'},{'real','nonsparse'},...
                    'transformPointsInverse','X');
                
                validateattributes(y,{'single','double'},{'real','nonsparse'},...
                    'transformPointsInverse','Y');
                
                if ~isequal(size(x),size(y))
                    error(message('images:geotrans:transformPointsSizeMismatch','transformPointsInverse','X','Y'));
                end
                
                inputPointDims = size(x);
                
                x = reshape(x,numel(x),1);
                y = reshape(y,numel(y),1);
                X = [x,y];
                
                % Apply transform inverse mapping to input points
                U = self.apply_tform(X);
                
                % If class was constructed from single control points or if
                % points passed to transformPointsInverse are single,
                % return single to emulate MATLAB Math casting rules.
                if isa(X,'single')
                    U = single(U);
                end
                varargout{1} = reshape(U(:,1), inputPointDims);
                varargout{2} = reshape(U(:,2), inputPointDims);
                
            else
                X = varargin{1};
                
                validateattributes(X,{'single','double'},{'real','nonsparse','2d'},...
                    'transformPointsInverse','X');
                
                if ~isequal(size(X,2),2)
                    error(message('images:geotrans:transformPointsPackedMatrixInvalidSize',...
                        'transformPointsInverse','X'));
                end
                
                % Apply transform inverse mapping to input points
                U = self.apply_tform(X);
                
                % If class was constructed from single control points or if
                % points passed to transformPointsInverse are single,
                % return single to emulate MATLAB Math casting rules.
                if isa(X,'single')
                    U = single(U);
                end
                varargout{1} = U;
            end
        end
        
        function [xLimitsOut,yLimitsOut] = outputLimits(self,xLimitsIn,yLimitsIn)
            %outputLimits Find output limits of geometric transformation
            %
            %   [xLimitsOut,yLimitsOut] = outputLimits(tform,xLimitsIn,yLimitsIn) estimates the
            %   output spatial limits corresponding to a given geometric
            %   transformation and a set of input spatial limits.
            
            [xLimitsOut,yLimitsOut] = outputLimits@images.geotrans.internal.GeometricTransformation(self,xLimitsIn,yLimitsIn);
            
        end
        
        
                                                                      
    end
        
end