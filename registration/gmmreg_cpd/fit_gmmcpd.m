function [registered, params, config] = fit_gmmcpd(fixed, moving, varargin)
%FIT_GMMCPD Fit two sets of point clouds using the GMM CPD algorithm.
% Usage:
%   registered = fit_gmmcpd(fixed, moving, ...)
%   [registered, params, config] = fit_gmmcpd(_)
% 
% See also: gmmreg_cpd

% Defaults
defaults = struct();
defaults.ctrl_pts = [];
defaults.num_ctrl_pts = 5;
defaults.lambda = 1; % trade off btwn data fitting and smoothness
defaults.beta = 1; % strength btwn points (small = smooth deformation, large = translation)
defaults.init_sigma = 0.5; % size of Gaussian mixture component (small = fine, large = coarse)
defaults.outliers = 1;
defaults.anneal_rate = 0.97;
defaults.tol = 1e-18;
defaults.emtol = 1e-15;
defaults.max_iter = 100;
defaults.max_em_iter = 10;
defaults.motion = 'grbf'; % 'tps' or 'grbf'
defaults.init_param = [];

% Parse args
config = parse_params(varargin, defaults);

% Point sets
config.scene = fixed;
config.model = moving;

% Default control points
if isempty(config.ctrl_pts)
    if size(fixed,2) == 2
        bounds = boundingBox(cat(1,config.scene,config.model));
        [xx,yy] = meshgrid(linspace(bounds(1),bounds(2),config.num_ctrl_pts), ...
            linspace(bounds(3),bounds(4),config.num_ctrl_pts));
        config.ctrl_pts = [xx(:) yy(:)];
    elseif size(fixed,2) == 3
        bounds = boundingBox(cat(1,config.scene,config.model));
        [xx,yy,zz] = meshgrid(...
            linspace(bounds(1),bounds(2),config.num_ctrl_pts), ...
            linspace(bounds(3),bounds(4),config.num_ctrl_pts), ...
            linspace(bounds(5),bounds(6),config.num_ctrl_pts));
        config.ctrl_pts = [xx(:) yy(:) zz(:)];
    end
end

% Default initial parameters for control points
if isempty(config.init_param)
    config.init_param = zeros(size(config.ctrl_pts));
end

% Solve
[params, registered] = gmmreg_cpd(config);

end

