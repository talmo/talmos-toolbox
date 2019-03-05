function new_varname = get_new_varname(varname)
%GET_NEW_VARNAME Returns an unused variable name in the workspace.
% Usage:
%   new_varname = get_new_varname(varname)

% Get workspace variable names
vars = evalin('base', 'who');

% Loop until an unused variable name is found
new_varname = varname;
i = 1;
while instr(new_varname, vars, 'ec')
    new_varname = [varname num2str(i)];
    i = i + 1;
end

end