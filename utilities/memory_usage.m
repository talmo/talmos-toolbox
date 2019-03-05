function varargout = memory_usage(units)
%MEMORY_USAGE Returns the free memory and a structure with detailed 
% information about memory usage of the system.
%
% Usage:
%   MEMORY_USAGE        % Prints free memory
%   MEMORY_USAGE(units) % Sets the units of the reported free memory
%   free_mem = MEMORY_USAGE(...)
%   [free_mem, mem_details] = MEMORY_USAGE(...)
%
% Notes:
%   - The units match any of: 'bytes', 'KB', 'MB', 'GB'
%   - Default units: 'MB'
% Warning: This function returns different structures for mem_details
% depending on the OS.

% Set up units
unit_strs = {'bytes', 'KB', 'MB', 'GB'};
bytes2X = cell2struct(num2cell(1024 .^ -(0:length(unit_strs) - 1))', unit_strs);

if nargin < 1
    units = 'MB';
end

% Parse inputs
units = validatestring(units, unit_strs);

if isunix
    % Useful references:
    %   http://www.redhat.com/advice/tips/meminfo.html
    %   http://www.cyberciti.biz/faq/linux-check-memory-usage/
    
    [~, meminfo_string] = system('cat /proc/meminfo');
        
    % Parse output
    names = regexp(meminfo_string, '^(?<field>\w*):\s*(?<val>\d+)\s*(?<units>\w*)$', 'names', 'lineanchors');
    data = squeeze(struct2cell(names))';
    data(strcmp(data(:, 3), ''), 3) = {'bytes'};
    for i = 1:length(names)
        field_units = validatestring(data{i, 3}, unit_strs);
        mem_details.(data{i, 1}) = str2double(data{i, 2}) / bytes2X.(field_units);
    end

    % Pull out the free memory
    free_mem = mem_details.MemFree;
    
    % Alternatives:
    %[~, free_string] = system('free -b');
    %[~, top_string] = system('top -n 1 | grep -E ''Mem|Swap''');
    
    
elseif ispc
    [mem_details.user, mem_details.sys] = memory;
    
    free_mem = mem_details.sys.PhysicalMemory.Available; % bytes
end

% Convert units
free_mem = free_mem * bytes2X.(units);

% Output
if nargout < 1
    fprintf('Free memory: %f %s\n', free_mem, units)
else
    varargout = {free_mem, mem_details};
end

end