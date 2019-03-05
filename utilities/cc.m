function cc(~)
%CC Clears the workspace, globals, command window and closes figures.
% Usage:
%   cc
%   cc(true) % clears globals

evalin('base', 'clear all')
if nargin > 0; evalin('base', 'clear -global'); end
close all force;
clc;

end

