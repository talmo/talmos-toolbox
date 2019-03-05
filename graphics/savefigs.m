function paths = savefigs(figs, varargin)
%SAVEFIGS Saves multiple figures.
% Usage:
%   savefigs % saves all open figs
%   savefigs(figure_handles)
%   savefigs(..., 'Name', Val)
%   paths = savefigs(...)
%
% Parameters:
%   'Formats': cell array of formats accepted by saveas (default = {'fig'})
%   'Filenames': filenames for the figures. Uses the figure titles if not
%       specified (default = {})
%   'Path': path to directory where figures should be saved.
%
% See also: saveas, print

if nargin < 1 || ~any(isfig(figs))
    if nargin > 0; varargin = [{figs} varargin]; end
    figs = findobj('Type', 'figure');
end
if isempty(figs)
    error('No figures open or specified.')
end

% Parse parameters
defaults.formats = {'fig'}; % all supported by saveas
defaults.filenames = {}; % uses figure title if available
defaults.path = '';
params = parse_params(varargin, defaults);

% Save figures
fig_paths = cell(numel(figs), numel(params.formats));
for i = 1:numel(figs)
    % Figure out filename to use
    filename = '';
    if numel(params.filenames) < i || isempty(params.filenames{i})
        ax = get(figs(i), 'CurrentAxes');
        if ~isempty(ax) && ishghandle(ax)
            filename = get(get(ax, 'title'), 'string');
        end
    else
        filename = params.filenames{i};
    end
    if isempty(filename)
        filename = 'Figure';
    end
    
    % Save in each format
    for j = 1:numel(params.formats)
        % Build absolute path to figure
        ext = ['.' params.formats{j}];
        path = get_new_filename(GetFullPath(fullfile(params.path, filename, ext)));
        
        try
            % Save figure
            saveas(figs(i), path);
            
            % Save path
            fig_paths{i, j} = path;
        catch ex
            warning('Unable to save figure: %s\n%s', path, ex.getReport())
        end
    end
end

% Return paths
if nargout > 0
    paths = fig_paths(:);
end

end

