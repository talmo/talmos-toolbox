% MIRT_GUI Medical Image Registration Toolbox (MIRT) GUI for group-wise non-rigid image registration/stabilization.
% 
% Copyright (C) 2007-2010 Andriy Myronenko (myron@csee.ogi.edu)
%
%     This file is part of the Medical Image Registration Toolbox (MIRT).
%
%     The source code is provided under the terms of the GNU General Public License as published by
%     the Free Software Foundation version 2 of the License.
function varargout = MIRT_GUI(varargin)

global maindata;

%global maindata;
% MIRT_GUI M-file for MIRT_GUI.fig
%      MIRT_GUI, by itself, creates a new MIRT_GUI or raises the existing
%      singleton*.
%
%      H = MIRT_GUI returns the handle to a new MIRT_GUI or the handle to
%      the existing singleton*.
%
%      MIRT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MIRT_GUI.M with the given input
%      arguments.
%
%      MIRT_GUI('Property','Value',...) creates a new MIRT_GUI or raises
%      the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MIRT_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MIRT_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to helpmenu MIRT_GUI

% Last Modified by GUIDE v2.5 06-May-2010 16:42:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MIRT_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MIRT_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MIRT_GUI is made visible.
function MIRT_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
global maindata;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MIRT_GUI (see VARARGIN)

% Choose default command line output for MIRT_GUI
handles.output = hObject;

%%%%%%%% Load Default Option Values %%%%%%%%%
[handles.prepro, handles.meshopt, handles.transopt]=mirtgui_setdefaultoptions;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MIRT_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MIRT_GUI_OutputFcn(hObject, eventdata, handles) 
global maindata;

% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% Change the current image accordingly to the slider
% --- Executes on slider movement. 
function slider1_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.maindata_k1=max(1,floor(handles.maindata_K*get(hObject,'Value')));
handles=drawall(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DRAWALL - draw current frame and its histogram in the main window
function handles=drawall(handles)
global maindata;

% update current image frame
axes(handles.axes1);
imshow(maindata(:,:,handles.maindata_k1));


% % update the histogram
% axes(handles.axes3);
% [y1,y2,x1,x2,imcut]=get_imcut(maindata(:,:,handles.maindata_k1), handles.maindata_corners(handles.maindata_k1,:));
% [n, xout]=hist(imcut(:),64);
% bar(xout,n/numel(imcut));

% update the frame number
set(handles.text1,'String', num2str(handles.maindata_k1));
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delete all processing. Get back to the original input data
% --- Executes on button press in pushbutton_remove.
function pushbutton_remove_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to pushbutton_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load saved data as a current data

%maindata=handles.maindatasave;
%maindata=mirtgui_loaddata(handles.mirt_filename);

[pathstr, name, ext, versn] = fileparts(handles.mirt_filename);

    switch lower(ext)
        case '.avi'
            maindata=mirt2D_avi2mat(handles.mirt_filename);
        case '.mat'
            vars = whos('-file', handles.mirt_filename);
            maindata=load(handles.mirt_filename, vars(1).name);
            maindata=getfield(maindata,vars(1).name);
            maindata=im2double(maindata);
            maindata(isnan(maindata))=0;

        otherwise
            error('Not a supported data file...')
    end

% update size and visible image corner positions
[handles.maindata_M,handles.maindata_N,handles.maindata_K]=size(maindata);
for i=1:handles.maindata_K
    [y1, y2, x1, x2, imcut]=imacro(maindata(:,:,i), 0);
    handles.maindata_corners(i,:)=[y1 y2 x1 x2];
end
% redraw
handles=drawall(handles);
guidata(hObject, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
global maindata;
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Preprocess all images
% --- Executes on button press in apply_to_all.
function apply_to_all_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to apply_to_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = waitbar(0,'Please wait...');
method=get(handles.popupmenu1,'Value');

% get the options
option=handles.prepro;

% for all images
for i=1:handles.maindata_K
    % get the corners
    [y1,y2,x1,x2,imcut]=get_imcut(maindata(:,:,i), handles.maindata_corners(i,:));
    % preprocess
    maindata(y1:y2,x1:x2,i)=preprocess(imcut, method, option);
    waitbar(i/handles.maindata_K);
end

close(h);
handles=drawall(handles);
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Preprocess the current image
% --- Executes on button press in pushbutton_apply.
function pushbutton_apply_Callback(hObject, eventdata, handles)
global maindata;

% hObject    handle to pushbutton_apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = waitbar(0,'Please wait...');
method=get(handles.popupmenu1,'Value');

[y1,y2,x1,x2,imcut]=get_imcut(maindata(:,:,handles.maindata_k1), handles.maindata_corners(handles.maindata_k1,:));
option=handles.prepro;
maindata(y1:y2,x1:x2,handles.maindata_k1)= preprocess(imcut, method, option);
close(h);

handles=drawall(handles);
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Preprocess one image

function im2=preprocess(imcut, method, option)
global maindata;

switch method
    case 1 % mat2gray
        im2=mat2gray(imcut);
    case 2 % imadjust
        im2=imadjust(imcut);
    case 3 % gradient through Sobel
        h = fspecial('sobel');
        gx = imfilter(imcut,h,'replicate'); gy = imfilter(imcut,h','replicate');
        im2=sqrt(gx.^2+gy.^2);
    case 4 % wiener
        im2=wiener2(imcut, [option.wiener  option.wiener]);
    case 5 % gaussian
        h = fspecial('gaussian', [option.gauss(1) option.gauss(1)] , option.gauss(2));
        im2=imfilter(imcut, h,'replicate');
 end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Preprocessing options
% --- Executes on button press in pushbutton_options.
function pushbutton_options_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to pushbutton_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

method=get(handles.popupmenu1,'Value');
pos_size = get(handles.figure1,'Position');

switch method
    case 1 % mat2gray
    case 2 % imadjust        
    case 3 % gradient through Sobel
    case 4 % wiener
        handles.prepro.wiener = wiener_opt(handles.prepro.wiener);
    case 5 % gaussian
        handles.prepro.gauss = gauss_opt(handles.prepro.gauss);
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton_exit.
function pushbutton_exit_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to pushbutton_exit (see GCBO)

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos_size = get(handles.figure1,'Position');
% Call modaldlg with the argument 'Position'.
user_response = modaldlg('Title','Confirm Close');
switch user_response
case {'No'}
    % take no action
case 'Yes'
    % Prepare to close GUI application window
    delete(handles.figure1)
end



% --- Executes on button press in croptheborder.
function croptheborder_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to croptheborder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=zeros(size(maindata));
n=5; % how much to crop the border

h = waitbar(0,'Please wait...');
for i=1:handles.maindata_K,
 
[y1,y2,x1,x2,imcut]=get_imcut(maindata(:,:,i), handles.maindata_corners(i,:),n);
a(y1:y2,x1:x2,i)=imcut;
handles.maindata_corners(i,:)=[y1 y2 x1 x2];

waitbar(i/handles.maindata_K);
end
maindata=a;
close(h);
handles=drawall(handles);
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% File menues start here
% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
global maindata;

% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Load the data and initialize everything
% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
    {'*.mat', 'All MAT-Files (*.mat)'; ...
    '*.avi','All Avi Files (*.avi)'
    '*.*','All Files (*.*)'}, ...
    'Select Mat or Avi file of image sequence. ');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
    % Otherwise construct the fullfilename and Check and load the file
else
    handles.mirt_filename = fullfile(pathname,filename);
  
   
    %maindata=mirtgui_loaddata(handles.mirt_filename);
    %handles.maindatasave=maindata;
    
    [pathstr, name, ext, versn] = fileparts(handles.mirt_filename);

    switch lower(ext)
        case '.avi'
            maindata=mirt2D_avi2mat(handles.mirt_filename);
        case '.mat'
            vars = whos('-file', handles.mirt_filename);
            maindata=load(handles.mirt_filename, vars(1).name);
            maindata=getfield(maindata,vars(1).name);
            maindata=im2double(maindata);
            maindata(isnan(maindata))=0;

        otherwise
            error('Not a supported data file...')
    end
    
    
    
    handles.maindata_k1=1;
    [handles.maindata_M,handles.maindata_N,handles.maindata_K]=size(maindata);

    % a heuristic to set the default spacing between B-spline control
    % points: 4% of original size. this can modified manually using mesh
    % options
    handles.meshopt(1)=round(0.02*(handles.maindata_M+handles.maindata_N));

    
    % find the where the actual image is
    for i=1:handles.maindata_K
        [y1, y2, x1, x2, imcut]=imacro(maindata(:,:,i), 0);
        handles.maindata_corners(i,:)=[y1 y2 x1 x2];
    end

    set(handles.draw_panel,'Visible','On');
    set(handles.infotext,'Visible','Off');
    
    set(handles.translation,'Enable','On');
    set(handles.start_meshgroupregistration,'Enable','On');
    set(handles.croptheborder,'Enable','On');
    set(handles.pushbutton_remove,'Enable','On');
    set(handles.pushbutton_apply,'Enable','On');
    set(handles.apply_to_all,'Enable','On');

    handles=drawall(handles);
    
%     remove

    guidata(hObject, handles);

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Save the result to avi file (uncompressed)
% --------------------------------------------------------------------
function save_avi_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to save_avi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile('*.avi','Save image sequence as');
if isequal([file,path],[0,0])
    return
% Otherwise construct the fullfilename and Check and load the file
else
    File = fullfile(path,file);
    a=maindata;
    F=mirt2D_mat2avi(a);
    movie2avi(F, File, 'compression', 'none', 'colormap', colormap(gray));
    guidata(hObject, handles);
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Save the result to mat file 
% --------------------------------------------------------------------
function save_mat_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to save_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path] = uiputfile('*.mat','Save image sequence as');
if isequal([file,path],[0,0])
    return
% Otherwise construct the fullfilename and Check and load the file
else
    File = fullfile(path,file);
    a=maindata;
    save(File,'a');
    guidata(hObject, handles);
   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Mesh-based non-rigid registration options
% --- Executes on button press in meshregistration_options.
function meshregistration_options_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to meshregistration_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos_size = get(handles.figure1,'Position');
handles.meshopt = registration_opt(handles.meshopt);
guidata(hObject, handles); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Main thing! Execute non-rigid registration :)
% --- Executes on button press in start_meshgroupregistration.
function start_meshgroupregistration_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to start_meshgroupregistration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = waitbar(0,'Please wait...');
% Set all parameters first
main.okno=handles.meshopt(1);
switch handles.meshopt(2)
      
    case 1
      main.similarity='RC';  % similarity measure
    case 2
      main.similarity='SSD';  % similarity measure   
    case 3
      main.similarity='SAD';  % similarity measure
    case 4
      main.similarity='CC';  % similarity measure
    case 5
      main.similarity='MI';  % similarity measure  
      
    otherwise
      main.similarity='SSD';  % similarity measure
end
      
main.subdivide = handles.meshopt(3);   
main.lambda = handles.meshopt(4); % regularization weight, 0 for non

optim.maxsteps = handles.meshopt(5); 
optim.fundif = handles.meshopt(6); 
optim.gamma = handles.meshopt(7); 
optim.anneal=handles.meshopt(8);
optim.imfundif=handles.meshopt(9);
optim.maxcycle=handles.meshopt(10);
optim.progressbar=1;


for i=1:handles.maindata_K
    
    % put nans around the border
    im=nan(handles.maindata_M,handles.maindata_N);
    [y1,y2,x1,x2,imcut]=get_imcut(maindata(:,:,i), handles.maindata_corners(i,:));
    im(y1:y2,x1:x2)=imcut;
    maindata(:,:,i)=im;

end

a=maindata;
save MIRT_GUI_TMPSAVE.mat a;
clear a;maindata=[];
% Start groupwise registration

close(h);

main.alpha=handles.meshopt(12);
if handles.meshopt(11)==1,  
        handles.res=mirt2Dgroup_sequence('MIRT_GUI_TMPSAVE.mat', main, optim);
else
        main.group = handles.meshopt(11)-1;
        handles.res=mirt2Dgroup_frame('MIRT_GUI_TMPSAVE.mat', main, optim);
end

set(handles.applytransform,'Enable','On');

load MIRT_GUI_TMPSAVE.mat;
maindata=a; clear a;

guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Play through the image sequence

% --- Executes on button press in pushbutton_play.
function pushbutton_play_Callback(hObject, eventdata, handles)
global maindata;

% hObject    handle to pushbutton_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% alternatively one can use matlab movie function, but that requires to convert the
%% sequence to the movie structure first

for i=1:handles.maindata_K
   
axes(handles.axes1);
imshow(maindata(:,:,i)); 


drawnow; pause(0.05);
end
handles=drawall(handles);
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Apply the found transform
% --- Executes on button press in applytransform.
function applytransform_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to applytransform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

maindata=mirt2Dgroup_transform(maindata, handles.res);
maindata(isnan(maindata))=0;

[handles.maindata_M,handles.maindata_N,handles.maindata_K]=size(maindata);

%% Corners don't do much if the transform is highly non-rigid.
%% Probably, at this point it is better to switch to some kind of mask.
%% find them anyway
for i=1:handles.maindata_K
    [y1, y2, x1, x2, imcut]=imacro(maindata(:,:,i), 0);
    handles.maindata_corners(i,:)=[y1 y2 x1 x2];
end

handles=drawall(handles);
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% GET imcut %%%%%%%
function [y1,y2,x1,x2,imcut]=get_imcut(im, corners, n)

if nargin<3, n=0; end;

y1=corners(1)+n;
y2=corners(2)-n;
x1=corners(3)+n;
x2=corners(4)-n;
imcut=im(y1:y2,x1:x2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Find actual image corners
function [y1, y2, x1, x2, im]=imacro(im, n)

[in1,in2] = find(im);
y1=min(in1)+n;
y2=max(in1)-n;
x1=min(in2)+n;
x2=max(in2)-n;
im=im(y1:y2, x1:x2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Groupwise translation options
% --- Executes on button press in translation_options.
function translation_options_Callback(hObject, eventdata, handles)
% hObject    handle to translation_options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos_size = get(handles.figure1,'Position');
handles.transopt = translation_opt(handles.transopt);
guidata(hObject, handles); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Groupwise translation compensation
% --- Executes on button press in translation.
function translation_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to translation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear some space
%rmfield(handles,'maindata');


optim.neighbor=handles.transopt(1);
optim.resize=handles.transopt(2);
optim.method=handles.transopt(3);
main.single=0;


switch optim.method
   case 1
     maindata = mirt2D_translation1(maindata,optim.resize,optim.neighbor,1);
   case 2
     maindata = mirt2D_translation2(maindata,optim.resize,optim.neighbor,1);
   otherwise
     maindata = mirt2D_translation1(maindata,optim.resize,optim.neighbor,1); 
end



[handles.maindata_M,handles.maindata_N,handles.maindata_K]=size(maindata);

% find the where the actual image is
for i=1:handles.maindata_K

    [y1, y2, x1, x2, imcut]=imacro(maindata(:,:,i), 0);
    handles.maindata_corners(i,:)=[y1 y2 x1 x2];
end


handles=drawall(handles);
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Remove current frame out of sequence, (e.g. if it's corrapted or uninformative)
% --- Executes on button press in remove_frame.
function remove_frame_Callback(hObject, eventdata, handles)
global maindata;
% hObject    handle to remove_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% remove from both original and processed data
%handles.maindatasave(:,:,handles.maindata_k1)=[];
maindata(:,:,handles.maindata_k1)=[];
handles.maindata_corners(handles.maindata_k1,:)=[];
[handles.maindata_M,handles.maindata_N,handles.maindata_K]=size(maindata);

handles.maindata_k1=max(1,handles.maindata_k1-1);
handles=drawall(handles);
guidata(hObject, handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Help submenues start here %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Experimental %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------------------
function Helpmenu_Callback(hObject, eventdata, handles)
% hObject    handle to Helpmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos_size = get(handles.figure1,'Position');
aboutfig();
guidata(hObject, handles); 

% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pos_size = get(handles.figure1,'Position');
% Call modaldlg with the argument 'Position'.
user_response = modaldlg('Title','Confirm Close');
switch user_response
case {'No'}
    % take no action
case 'Yes'
    % Prepare to close GUI application window
    delete(handles.figure1)
end
