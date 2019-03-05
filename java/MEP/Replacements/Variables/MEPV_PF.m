function txt = MEPV_PF(txt)
%MEPV_PF Returns a parfor function template.
% 
% API:
%   https://github.com/GavriYashar/Matlab-Editor-Plugin/blob/master/src/at/mep/editor/EditorWrapper.java
%
% See also: MEPV_REV

pattern = '\${PF[\( ]?(?<args>[a-zA-Z0-9]+)?[\)]?}';
matches = regexp(txt,pattern,'names','once');
if ~isempty(matches)
    varname = matches.args;
    if isempty(varname); varname = 'x'; end
    
    txt = replace(strjoin({
        'parfor i = 1:numel(varname)'
        '    '
        'end'
        }, '\n'), 'varname', varname);
end

end