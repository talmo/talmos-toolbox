function S = save2struct(varargin)
%SAVE2STRUCT Saves the caller's workspace variables into a struct as produced by the save function.
% Usage:
%   S = save2struct
%   S = save2struct('var1', 'var2', ...)
% 
% See also: save

varNames = evalin('caller', 'who');
if nargin > 0
    varNames = varNames(ismember(varNames, varargin));
end

S = cell2struct(cell(size(varNames)), varNames);
for i = 1:numel(varNames)
    S.(varNames{i}) = evalin('caller', varNames{i});
end

end

