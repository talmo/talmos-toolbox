function txt = MEPV_SELECTEDTXT(txt)
%MEPV_SELECTEDTXT Returns the currently selected text in the active Editor.
% 
% API: https://github.com/GavriYashar/Matlab-Editor-Plugin/blob/master/src/at/mep/editor/EditorWrapper.java
% 
% See also: MEPV_THIS

txt = char(at.mep.editor.EditorWrapper.getSelectedTxt(at.mep.editor.EditorWrapper.gae()));

end