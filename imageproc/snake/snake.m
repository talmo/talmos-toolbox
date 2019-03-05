function varargout = snake(varargin)
warning('off') 
% SNAKE M-file for snake.fig
%      SNAKE, by itself, creates a new SNAKE or raises the existing
%      singleton*.
%
%      H = SNAKE returns the handle to a new SNAKE or the handle to
%      the existing singleton*.
%
%      SNAKE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SNAKE.M with the given input arguments.
%
%      SNAKE('Property','Value',...) creates a new SNAKE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before snake_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to snake_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help snake

% Last Modified by GUIDE v2.5 10-Feb-2016 12:09:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @snake_OpeningFcn, ...
                   'gui_OutputFcn',  @snake_OutputFcn, ...
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


% --- Executes just before snake is made visible.
function snake_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to snake (see VARARGIN)

% Choose default command line output for snake
%Initialization Values
I = ones(300,400) ;
axes(handles.axes1);
cla;
imshow(I)    
handles.output = hObject;
handles.metricdata.Cur_We = 1;
handles.metricdata.Con_We = 1;
handles.metricdata.Gra_We = 1;
handles.metricdata.Cur_Th = 0.8;
%handles.metricdata.Con_Th = 1;
handles.metricdata.Ws = 3;
%handles.metricdata.Stop_Force = 0 ;
handles.metricdata.Max_Iter = 200 ;
handles.metricdata.Stop_Cr = 0.0001;


%initialize_gui(hObject, handles, false);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes snake wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = snake_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in setInitialPoints.
function setInitialPoints_Callback(hObject, eventdata, handles)
% hObject    handle to setInitialPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% I = imread('star.bmp') ;
% if(size(I,3) == 1)
%     handles.metricdata.I = rgb2gray(I) ;
% else
%     handles.metricdata.I = I ;
% end    
I = handles.metricdata.I  ;

axes(handles.axes1);
cla;
imshow(I) ;
[handles.metricdata.yp,handles.metricdata.xp] = getpts ;
guidata(hObject,handles) ;



function sizeOfLocalEnergyWindow_Callback(hObject, eventdata, handles)
% hObject    handle to sizeOfLocalEnergyWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sizeOfLocalEnergyWindow as text
%        str2double(get(hObject,'String')) returns contents of sizeOfLocalEnergyWindow as a double
Ws = str2double(get(hObject, 'String'));
cq = get(hObject, 'String') ;
% if isnan(Ws)
%     set(hObject, 'String', 0);
%     errordlg('Input must be a number','Error');
% end
set(handles.text2 ,'String',{['x  ' cq]}) ;

% Save the new density value
handles.metricdata.Ws = Ws ;
guidata(hObject,handles) ;


% --- Executes during object creation, after setting all properties.
function sizeOfLocalEnergyWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeOfLocalEnergyWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function continutyWeight_Callback(hObject, eventdata, handles)
% hObject    handle to continutyWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of continutyWeight as text
%        str2double(get(hObject,'String')) returns contents of continutyWeight as a double
Con_We = str2double(get(hObject, 'String'));
% if isnan(Con_We)
%     set(hObject, 'String', 0);
%     errordlg('Input must be a number','Error');
% end

% Save the new density value
handles.metricdata.Con_We = Con_We;
guidata(hObject,handles) ;


% --- Executes during object creation, after setting all properties.
function continutyWeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to continutyWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function curvatureWeight_Callback(hObject, eventdata, handles)
% hObject    handle to curvatureWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curvatureWeight as text
%        str2double(get(hObject,'String')) returns contents of curvatureWeight as a double
Cur_We = str2double(get(hObject, 'String'));
% if isnan(Cur_We)
%     set(hObject, 'String', 0);
%     errordlg('Input must be a number','Error');
% end

% Save the new density value
handles.metricdata.Cur_We = Cur_We ;
guidata(hObject,handles) ;


% --- Executes during object creation, after setting all properties.
function curvatureWeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curvatureWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gradientWeight_Callback(hObject, eventdata, handles)
% hObject    handle to gradientWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gradientWeight as text
%        str2double(get(hObject,'String')) returns contents of gradientWeight as a double
Gra_We = str2double(get(hObject, 'String'));
% if isnan(gra_We)
%     set(hObject, 'String', 0);
%     errordlg('Input must be a number','Error');
% end

% Save the new density value
handles.metricdata.Gra_We = Gra_We ;
guidata(hObject,handles) ;


% --- Executes during object creation, after setting all properties.
function gradientWeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gradientWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function curvatureThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to curvatureThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curvatureThreshold as text
%        str2double(get(hObject,'String')) returns contents of curvatureThreshold as a double
Cur_Th = str2double(get(hObject, 'String'));
handles.metricdata.Cur_Th = Cur_Th ;
 if (isnan(Cur_Th) | Cur_Th > 1 | Cur_Th < 0) 
     set(hObject, 'String', '0.8');
     handles.metricdata.Cur_Th = 0.8 ;
     errordlg('Input must be a number between 0 to 1','Error');
 end

% Save the new density value
guidata(hObject,handles) ;


% --- Executes during object creation, after setting all properties.
function curvatureThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curvatureThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%image_4.m
%handles.metricdata.Stop_Force = 0 ;
tic
I = handles.metricdata.I ;
xp = handles.metricdata.xp ;
yp = handles.metricdata.yp ;
Cur_We = handles.metricdata.Cur_We ;
Con_We = handles.metricdata.Con_We ;
Gra_We = handles.metricdata.Gra_We ;
cur_Tresh = handles.metricdata.Cur_Th ;
%con_Tresh = handles.metricdata.Con_Th ;
ws = handles.metricdata.Ws ;
max_iter = handles.metricdata.Max_Iter  ;
Stop_Cr = handles.metricdata.Stop_Cr ;

Cur_We = Cur_We/(Cur_We + Con_We + Gra_We) ;
Con_We = Con_We/(Cur_We + Con_We + Gra_We) ;
Gra_We = Gra_We/(Cur_We + Con_We + Gra_We) ;


gx = fspecial('sobel')/8 ;
gy = gx' ;
% cur_Tresh = 0.8 ;
% con_Tresh = 0.9 ; 
%I = imread('041_2_3.bmp') ;
max_I = max(I(:)) ;
rn = size(I,1) ;
cn = size(I,2) ;
It = double(I) ;
Itt = It ;

xs = length(xp) ;
ne1(1) = xs ;
ne2(1) = 2 ;
for i = 2:xs-1
    ne1(i) = i-1 ;
    ne2(i) = i+1 ;
end
ne2(xs) = 1 ;
ne1(xs) = xs-1 ;    

gradx = imfilter(It,gx,'same') ;
grady = imfilter(It,gy,'same') ;
Igrad = (gradx.^2 + grady.^2).^(1/2) ; 
% ws = 4 ;
Old_Etot = 100 ;
New_Etot = 1 ;
%for iter = 1:60
iter = 0 ;
Tuv = ones(1,xs) ;
Stop_Force = 0 ;
while(((abs(New_Etot - Old_Etot) > Stop_Cr) | (iter < 2)) & (iter < max_iter) & (Stop_Force == 0))
    iter = iter + 1 ;
    set(handles.text10 ,'String',{num2str(iter)}) ;
    Old_Etot = New_Etot ;
    Itt = It ;
    lix = [] ;
    liy = [] ;
    for i = 1:xs
        r1 = max([1 xp(i)-3]):min([rn xp(i)+3]) ;
        r2 = max([1 yp(i)-3]):min([cn yp(i)+3]) ;
        zIt = Itt(fix(r1),fix(r2)) ;
        mean_Itt = mean(zIt(:)) ;
        max_Itt = max(zIt(:)) ;
        min_Itt = min(zIt(:)) ;
        lix = [lix [yp(i) ; yp(ne1(i))]] ;
        liy = [liy [xp(i) ; xp(ne1(i))]] ;
        if(~isempty(r1) & ~isempty(r2))
    %         It(fix(r2),fix(r1)) = ones(length(r2),length(r1))*255 ;
%            Itt(fix(r1),fix(r2)) = ones(length(r1),length(r2))*double((255 - (mean_Itt))) ;
            Itt(fix(r1),fix(r2)) = 255 - Itt(fix(r1),fix(r2)) ;
        else
            Tuv(i) = 0 ;
        end
    end
    pause(0.02),
    axes(handles.axes1);
%    cla;
    imshow(Itt,[])    
    line(lix,liy,'Color',[1 0 0],'linewidth',1) ;
    
    for i =1:xs
        ac = [xp(i) yp(i)];
        n1 = ne1(i) ;
        d(i) = ((xp(n1) - ac(1))^2 + (yp(n1) - ac(2))^2)^(1/2) ;
    end
    d_mean = mean(d) ;
    Econ_Te = cell(1,xs) ; 
    Ecur_Te = cell(1,xs) ; 
    Egra_Te = cell(1,xs) ; 
    c_con = zeros(1,xs) ;
    c_cur = zeros(1,xs) ;
    c_gra = zeros(1,xs) ;
    Point_Ecur = zeros(1,xs) ;
    Etot = 0 ;    
    for i = 1:xs 
        if(Tuv(i) == 1)
            acc = fix([xp(i) yp(i)]);
            Econ = ones(5,5) ;
            Ecur = ones(5,5) ;
            Egra = ones(5,5) ;
            min_m = ws+2 ;
            max_m = -(ws+2) ;
            min_n = ws+2 ;
            max_n = -(ws+2) ;
            n1 = ne1(i) ;
            n2 = ne2(i) ;

            Point_Ecur(i) = ((xp(n1) - 2*acc(1) + xp(n2))^2 + (yp(n1) - 2*acc(2) + yp(n2))^2) ;
            Point_Econ(i) = (d_mean-((xp(n1) - acc(1))^2 + (yp(n1) - acc(2))^2)^(1/2))^2 ;
            Point_Egra(i) =  Igrad(acc(1),acc(2)) ;;

            for m = -ws:ws
                for n = -ws:ws
                    ac = acc + [m n] ;
                    ac = fix(ac) ;
                    if(ac(1) > 0 && ac(1) < rn && ac(2) > 0 && ac(2) < cn) 
                        Econ(m+ws+1,n+ws+1) = (d_mean-((xp(n1) - ac(1))^2 + (yp(n1) - ac(2))^2)^(1/2))^2 ;
                        Ecur(m+ws+1,n+ws+1) = ((xp(n1) - 2*ac(1) + xp(n2))^2 + (yp(n1) - 2*ac(2) + yp(n2))^2) ;
                        Egra(m+ws+1,n+ws+1) = Igrad(ac(1),ac(2)) ;
                        min_m = min([min_m m]) ;
                        max_m = max([max_m m]) ;
                        min_n = min([min_n n]) ;
                        max_n = max([max_n n]) ;
                    end
                end
            end
    %         min_m+ws+1:max_m+ws+1 ; min_n+ws+1:max_n+ws+1
            Econ = Econ(min_m+ws+1:max_m+ws+1,min_n+ws+1:max_n+ws+1) ;
            Ecur = Ecur(min_m+ws+1:max_m+ws+1,min_n+ws+1:max_n+ws+1) ;
            Egra = Egra(min_m+ws+1:max_m+ws+1,min_n+ws+1:max_n+ws+1) ;

            if(max(Econ(:)) ~= min(Econ(:)))
        %       Econ_Te{i} = (Econ)/max(Econ(:)) ;
                Econ_Te{i} = (Econ - min(Econ(:)))/(max(Econ(:)) - min(Econ(:))) ;
            else
                Econ_Te{i} = zeros(size(Econ)) ;
            end

            if(max(Ecur(:)) ~= min(Ecur(:)))
        %       Ecur_Te{i} = (Ecur)/max(Ecur(:)) ;
                Ecur_Te{i} = (Ecur - min(Ecur(:)))/(max(Ecur(:)) - min(Ecur(:))) ;
            else
                Ecur_Te{i} = zeros(size(Ecur)) ;
            end            
            if(max(Egra(:)) ~= min(Egra(:)))
                Egra_Te{i} = (Egra - min(Egra(:)))/(max(Egra(:)) - min(Egra(:))) ;
            else
                Egra_Te{i} = zeros(size(Egra)) ;
            end
        end
    end

    Point_Ecur = Point_Ecur / max(Point_Ecur(:)) ;
%    Point_Egra = Point_Egra / max(Point_Egra(:)) ;

    for i = 1:xs
        if(Tuv(i) == 1)
            n1 = ne1(i) ;
            n2 = ne2(i) ;
            c_con(i) = Con_We ; c_cur(i) = Cur_We ; c_gra(i) = Gra_We ;
                if((Point_Ecur(i) > Point_Ecur(n1)) & (Point_Ecur(i) > Point_Ecur(n2)) & (Point_Ecur(i) > cur_Tresh))
                    c_cur(i) = 0.2 ;
                end
        end
    end
    
    for i = 1:xs
        if(Tuv(i) == 1)
            Econ = Econ_Te{i} ;
            Ecur = Ecur_Te{i} ;
            Egra = Egra_Te{i} ;
            Eloc = c_con(i)*Econ + c_cur(i)*Ecur - c_gra(i)*Egra ;
            [nepx,nepy] = find(Eloc == min(Eloc(:))) ;
            xp(i) = nepx(1) + xp(i) - (ws+1) ;
            yp(i) = nepy(1) + yp(i) - (ws+1) ;
            Etot = Etot + min(Eloc(:)) ;
            if ( xp(i) < 1 | xp(i)> rn | yp(i) < 1 | yp(i) > cn )
                Tuv(i) = 0 ;
            end
        end
    end       
    New_Etot = Etot ;
end
                
time=toc;
set(handles.text18 ,'String',{num2str(time)}) ;


% --- Executes on button press in pushbutton3.
% function pushbutton3_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton3 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% handles.metricdata.Stop_Force = 1 ;
% guidata(hObject,handles) ;



function stopCriteria_Callback(hObject, eventdata, handles)
% hObject    handle to stopCriteria (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stopCriteria as text
%        str2double(get(hObject,'String')) returns contents of stopCriteria as a double
Stop_Cr = str2double(get(hObject, 'String'));
handles.metricdata.Stop_Cr = Stop_Cr ;
%  if (isnan(Con_Th) | Con_Th > 1 | Con_Th < 0) 
%      set(hObject, 'String', 1);
%      handles.metricdata.Con_Th = 1 ;
%      errordlg('Input must be a number between 0 to 1','Error');
%  end

% Save the new density value
guidata(hObject,handles) ;


% --- Executes during object creation, after setting all properties.
function stopCriteria_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stopCriteria (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in imageLoad.
function imageLoad_Callback(hObject, eventdata, handles)
% hObject    handle to imageLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
    {'*.jpg', 'All jpg-Files (*.jpg)'; '*.bmp','All bmp-Files (*.bmp)' ; '*.png' , 'All png-Files (*.png)' ; '*.*' , 'All Files'}, 'Select Address Book');
% If "Cancel" is selected then return
if isequal([filename,pathname],[0,0])
    return
% Otherwise construct the fullfilename and Check and load the file
else
    File = fullfile(pathname,filename);
    I = imread(File) ;
    if(size(I,3) ~= 1)
        handles.metricdata.I = rgb2gray(I) ;
    else
        handles.metricdata.I = I ;
    end    
    axes(handles.axes1);
    cla;
    imshow(I)    
%     % if the MAT-file is not valid, do not save the name
%     if Check_And_Load(File,handles)
%         handles.LastFIle = File;
%         guidata(hObject, handles)
%     end
end
guidata(handles.figure1, handles);




% --- Executes on key press over pushbutton3 with no controls selected.
% function pushbutton3_KeyPressFcn(hObject, eventdata, handles)
% % hObject    handle to pushbutton3 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% handles.metricdata.Stop_Force = 1 ;
% guidata(hObject,handles) ;
% 
% 
% 
% 
% % --- If Enable == 'on', executes on mouse press in 5 pixel border.
% % --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton3.
% function pushbutton3_ButtonDownFcn(hObject, eventdata, handles)
% % hObject    handle to pushbutton3 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% handles.metricdata.Stop_Force = 1 ;
% guidata(hObject,handles) ;





function maxIteration_Callback(hObject, eventdata, handles)
% hObject    handle to maxIteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxIteration as text
%        str2double(get(hObject,'String')) returns contents of maxIteration as a double
Max_Iter = str2double(get(hObject, 'String'));
handles.metricdata.Max_Iter = Max_Iter ;
%  if (isnan(Con_Th) | Con_Th > 1 | Con_Th < 0) 
%      set(hObject, 'String', 1);
%      handles.metricdata.Con_Th = 1 ;
%      errordlg('Input must be a number between 0 to 1','Error');
%  end

% Save the new density value
guidata(hObject,handles) ;




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox(['         This program is designed by          ' ; '                                              ' ; '                 Iman Moazzen                 ' ; '                                              '  ; '    for Digital Video Processing course by    ' ; '                                              ' ; '                 Prof P.Agathoklis            ' ; '               University of Victoria         ' ; '      Electrical Engineering Department       ']) ;
        
        
        
        
        
             


% --- Executes during object creation, after setting all properties.
function maxIteration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxIteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function text10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


