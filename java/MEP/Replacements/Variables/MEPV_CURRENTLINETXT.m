function txt = MEPV_CURRENTLINETXT(txt)
%MEPV_CURRENTLINETXT Returns the currently the text in the current line in the active Editor.
% 
% API: https://github.com/GavriYashar/Matlab-Editor-Plugin/blob/master/src/at/mep/editor/EditorWrapper.java
% 
% See also: MEPV_THIS

txt = char(at.mep.editor.EditorWrapper.getCurrentLineText(at.mep.editor.EditorWrapper.gae()));

end