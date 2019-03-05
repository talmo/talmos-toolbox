function [tform, registered, corresp] = cpd_solve(fixed, moving, varargin)
%CPD_SOLVE Aligns ptsB to ptsA using CPD.
% Usage:
%   tform = cpd_solve(fixed, moving)
%   tform = cpd_solve(fixed, moving, opt)
%   tform = cpd_solve(fixed, moving, 'Name', Value)
%
% Parameters:
%   'method', 'affine': Transformation type. Can be 'rigid', 'affine', or
%       'nonrigid'.
%   'viz', false: displays visualization
%   'savegif', false: saves visualization into a gif
%   'verbosity', 0: outputs to console
%
% See also: align_z_pair_cpd, sp_lsq



% Default options
methods = {'rigid', 'affine', 'nonrigid', 'nonrigid_lowrank'};
defaults.method = 'affine'; 
defaults.viz = false;
defaults.savegif = false;
defaults.verbosity = 0;
% general:
defaults.corresp = nargout > 2; % estimate the correspondence vector at the end of the registration.
defaults.normalize = true; % normalize both point-sets to zero mean and unit
                           % variance before registration, and denormalize after.
defaults.max_it = 150; % Maximum number of iterations.
defaults.outliers = 0.1; % [0...1] The weight of noise and outliers
% rigid:
defaults.rot = true; % 1 - estimate strictly rotation. 0 - also allow for reflections.
defaults.scale = true; % 1 - estimate scaling. 0 - fixed scaling. 
% nonrigid:
defaults.beta = 2; % Gaussian smoothing filter size. Forces rigidity.
defaults.lambda = 3; % Regularization weight.
defaults.fgt = 0; % 0 - do not use. 1 - Use a Fast Gauss transform (FGT) to speed up some matrix-vector product.
                  % 2 - Use FGT and fine tune (at the end) using truncated kernel approximations.

% nonrigid_lowrank:
defaults.numeig = 30; % number of eigenvectors to leave to estimate G
defaults.eigfgt = true; % use FGT to find eigenvectors (avoids explicitly computing G)
defaults.sigma2 = 0;

if nargin < 3
    opt = defaults;
else
    if isstruct(varargin{1})
        opt = varargin{1};
    else
        opt = struct(varargin{:});
    end
    
    % Use defaults for any missing options
    for f = fieldnames(defaults)'
        if ~isfield(opt, f{1})
            opt.(f{1}) = defaults.(f{1});
        end
    end
    opt.method = validatestring(opt.method, methods, mfilename);
end

if opt.verbosity > 0; fprintf('Calculating alignment using CPD (%s)...\n', opt.method); end
total_time = tic;

switch opt.method
    case {'rigid', 'affine'}
        % Solve (ptsB -> ptsA)
        if opt.corresp
            [T, corresp] = cpd_register(fixed, moving, opt);
        else
            T = cpd_register(fixed, moving, opt);
        end
           
%         sigma2 = T.sigma2;
        registered = T.Y;
        
        % Return as affine transformation matrix
        tform = affine2d([[T.s * T.R'; T.t'] [0 0 1]']);
        
    case {'nonrigid', 'nonrigid_lowrank'}
        % Solve (inverse: ptsA -> ptsB)
        if opt.corresp
            [T, corresp] = cpd_register(fixed, moving, opt);
        else
            T = cpd_register(fixed, moving, opt);
        end
%         sigma2 = T.sigma2;
        registered = T.Y;
        
        tform = T;
        
        % Create CPDNonRigid class
%         tform = CPDNonRigid(T, opt.tform_method);
end

if opt.verbosity > 0
    fprintf('Done. Error: <strong>%fpx / match</strong> [%.2fs]\n', rownorm2(moving - tform.transformPointsInverse(fixed)), toc(total_time))
end
end

