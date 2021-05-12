function varargout = membseg2(varargin)
%MEMBSEG2 M-file for membseg2.fig
%      MEMBSEG2, by itself, creates a new MEMBSEG2 or raises the existing
%      singleton*.
%
%      H = MEMBSEG2 returns the handle to a new MEMBSEG2 or the handle to
%      the existing singleton*.
%
%      MEMBSEG2('Property','Value',...) creates a new MEMBSEG2 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to membseg2_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MEMBSEG2('CALLBACK') and MEMBSEG2('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MEMBSEG2.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help membseg2

% Last Modified by GUIDE v2.5 10-May-2021 17:02:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @membseg2_OpeningFcn, ...
                   'gui_OutputFcn',  @membseg2_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before membseg2 is made visible.
function membseg2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% UIWAIT makes membseg2 wait for user response (see UIRESUME)
% uiwait(handles.membAnnotatorGUI);

global cur_state;
global curs;
global la;
global hfig;

% Initialization
la = 0;
cur_state = 0;
curs = datacursormode(hObject);
hfig = -1;

% Get possible inputs
handles.inTomoFile = '';
if ~isempty(varargin)
    inVarNames = {'inTomoFile', 'outFilename'};
    for i = 1:numel(inVarNames)
        cVar = inVarNames{i};
        ind = ismember(varargin, cVar);
        if any(ind)
            handles.(cVar) = varargin{circshift(ind, 1)};
        else
            handles.(cVar) = '';
        end  
    end
end

% Choose default command line output for membseg2
handles.output = hObject;

% Parse input
openFileTool_ClickedCallback(hObject, eventdata, handles)
% Remove the incoming tomogram flag for possible next data loading during
% this session
handles.inTomoFile = '';

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = membseg2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

if (isfield(handles,'closeFigure') && handles.closeFigure)
      mainGUI_CloseRequestFcn(hObject, eventdata, handles)
end

function mainGUI_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);

% --- Executes on slider movement.
function sldr_zs_Callback(hObject, eventdata, handles)
% hObject    handle to sldr_zs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function sldr_zs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldr_zs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function sldr_thres_Callback(hObject, eventdata, handles)
% hObject    handle to sldr_thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global F;
global T;
% global M;

% % Update density threshold
% if get(handles.chck_clft,'Value')
%     thr = get( handles.sldr_thres, 'Value' );
%     T = M > thr;
%     set( handles.ed_th, 'String', num2str(thr) );
%     set( handles.rbtn_thr, 'Value', 1 );
%     rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);
% else
thr = get( handles.sldr_thres, 'Value' );
T = F > thr;
set( handles.ed_th, 'String', sprintf('%.2f',thr) );
set( handles.rbtn_thr, 'Value', 1 );
rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);
% end


% --- Executes during object creation, after setting all properties.
function sldr_thres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldr_thres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ed_sz_thr_Callback(hObject, eventdata, handles)
% hObject    handle to ed_sz_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_sz_thr as text
%        str2double(get(hObject,'String')) returns contents of ed_sz_thr as a double

% --- Executes during object creation, after setting all properties.
function ed_sz_thr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_sz_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_erode.
function btn_erode_Callback(hObject, eventdata, handles)
% hObject    handle to btn_erode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global L;
global T;
global la;

if get(handles.chck_clft,'Value')
    H = (L>0) + (T>0);
    T = fmorph( H, 1, 1 );
else
    if la > 0
        H = (L>0) + (L==la);
        T = fmorph( H, 1, 1 );        
    else
        warndlg( 'No Presynaptic membrane selected.' );
    end
end
T = T == 2;
set( handles.rbtn_thr, 'Value', 1 );
rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);

% --- Executes on button press in btn_diate.
function btn_diate_Callback(hObject, eventdata, handles)
% hObject    handle to btn_diate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global L;
global T;
global la;

if get(handles.chck_clft,'Value')
    H = (L>0) + (T>0);
    T = fmorph( H, 1, 2 );
else
    if la > 0
        H = (L>0) + (L==la);
        T = fmorph( H, 1, 2 );        
    else
        warndlg( 'No Presynaptic membrane selected.' );
    end
end
T = T == 2;
set( handles.rbtn_thr, 'Value', 1 );
rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);


% --- Executes on button press in btn_sv_lbl.
function btn_sv_lbl_Callback(hObject, eventdata, handles)
% hObject    handle to btn_sv_lbl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global L;
isMaterial = false;

if get(handles.rd_btn_mrc,'Value')
    if ~isempty(handles.outFilename)
        outputFile = checkOutputFilename(handles, isMaterial);
        tom_mrcwrite(L, 'name', outputFile);
    else
        tom_mrcwrite(L);
    end
else
    if ~isempty(handles.outFilename)
        outputFile = checkOutputFilename(handles, isMaterial);
        tom_emwrite(L, 'name', outputFile);
    else
        tom_emwrite(L);
    end
end
msg = 'Labels were correctly saved';
updateLog(handles, msg);


% --- Executes on button press in btn_sv_clft.
function btn_sv_clft_Callback(hObject, eventdata, handles)
% hObject    handle to btn_sv_clft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global C;

if get(handles.rd_btn_mrc,'Value')
    tom_mrcwrite( C );
else
    tom_emwrite( C );
end

% --- Executes on button press in rbtn_flt.
function rbtn_flt_Callback(hObject, eventdata, handles)
% hObject    handle to rbtn_flt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbtn_flt


% --- Executes on button press in rbtn_thr.
function rbtn_thr_Callback(hObject, eventdata, handles)
% hObject    handle to rbtn_thr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbtn_thr


% --- Executes on button press in rbtn_lbl.
function rbtn_lbl_Callback(hObject, eventdata, handles)
% hObject    handle to rbtn_lbl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbtn_lbl


% --- Executes on button press in rbtn_dflt.
%function rbtn_dflt_Callback(hObject, eventdata, handles)
% hObject    handle to rbtn_dflt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbtn_dflt


% --- Executes on button press in rbtn_clft.
% function rbtn_clft_Callback(hObject, eventdata, handles)
% hObject    handle to rbtn_clft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbtn_clft


% --- Executes on button press in btn_get_mb.
function btn_get_mb_Callback(hObject, eventdata, handles)
% hObject    handle to btn_get_mb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Diplay a cursor for catching a point from pre-synaptic membrane

global cur_state;
global curs;
global la;
global pa;
global L;

if get(handles.rbtn_lbl,'Value')
    if cur_state == 2
        % Check if the point is a membrane
        st = getCursorInfo( curs );
        x = st.Position(2);
        y = st.Position(1);
        z = round( get(handles.sldr_zs,'Value') );
        la = L(x,y,z);
        if la>0
            pa = [x; y; z];
            datacursormode off;
            cur_state = 0;
            set( hObject, 'String', 'Get Mb. Pt.' );
        else
            warndlg('A Mb. point must be part of the presynaptic membrane.' );
        end    
    elseif cur_state == 0
        datacursormode on;
        cur_state = 2;
        set( hObject, 'String', 'Capture' );
    else
        warndlg( 'Another cursor activated, stop it first.' );
    end
else
    warndlg( 'This cursor only work on "Label" view.' );
end

% --- Executes on button press in btn_get_psr.
function btn_get_psr_Callback(hObject, eventdata, handles)
% hObject    handle to btn_get_psr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Diplay a cursor for catching a point from pre-synaptic membrane

global cur_state;
global curs;
global pc;
global L;

if (get(handles.rbtn_lbl,'Value')) 
    if cur_state == 3
        % Check if the point is a membrane
        st = getCursorInfo( curs );
        x = st.Position(2);
        y = st.Position(1);
        z = round( get(handles.sldr_zs,'Value') );
        lc = L(x,y,z);
        if lc==0
            pc = [x; y; z];
            datacursormode off;
            cur_state = 0;
            set( hObject, 'String', 'Get PSR Pt.' );
        else
            warndlg('A PSR point must be part of the presynaptic region.' );
        end    
    elseif cur_state == 0
        datacursormode on;
        cur_state = 3;
        set( hObject, 'String', 'Capture' );
    else
        warndlg( 'Another cursor activated, stop it first.' );
    end
else
    warndlg( 'This cursor only work on "Label" view.' );
end    

% --- Executes on button press in btn_get_orien.
function btn_get_orien_Callback(hObject, eventdata, handles)
% hObject    handle to btn_get_orien (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global L;
global N;
global No;
global pc;
global pa;

h = helpdlg('Getting membrane orientation, it can take some time...','memblabel Info');
v = pc - pa;
v = v / sqrt(sum(v.*v));
No = spreador( L>0, N, pa, v );
close( h );

% --- Executes on button press in btn_up_lbl.
function btn_up_lbl_Callback(hObject, eventdata, handles)
% hObject    handle to btn_up_lbl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global L;
global T;

% Update object labels according to its size
L = clrpartf2( T>0, 6 ); 
set( handles.rbtn_lbl, 'Value', 1 );
rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);

% --- Executes on button press in btn_disp_cur.
function btn_disp_cur_Callback(hObject, eventdata, handles)
% hObject    handle to btn_disp_cur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cur_state;

if (get(handles.rbtn_lbl,'Value')) %|| (get(handles.rbtn_clft,'Value'))
    if cur_state == 1
        datacursormode off;
        cur_state = 0;
        set( hObject, 'String', 'Display Cursor' );
    elseif cur_state == 0
        datacursormode on;
        cur_state = 1;
        set( hObject, 'String', 'Stop Cursor' );
    else
        warndlg( 'Another cursor activated, stop it first.' );
    end
else
    warndlg( 'This cursor only work on "Label" or "Cleft" view.' );
end

function ed_crop_x_low_Callback(hObject, eventdata, handles)
% hObject    handle to ed_crop_x_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_crop_x_low as text
%        str2double(get(hObject,'String')) returns contents of ed_crop_x_low as a double

xl = str2double( get(handles.ed_crop_x_low,'String') );
xh = str2double( get(handles.ed_crop_x_high,'String') );

if xl < 1
    xl = 1;
    set( handles.ed_crop_x_low, 'String', num2str(xl) );
elseif xl > xh
    xl = xh;
    set( handles.ed_crop_x_low, 'String', num2str(xl) );
end

% --- Executes during object creation, after setting all properties.
function ed_crop_x_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_crop_x_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_crop_x_high_Callback(hObject, eventdata, handles)
% hObject    handle to ed_crop_x_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_crop_x_high as text
%        str2double(get(hObject,'String')) returns contents of
%        ed_crop_x_high as a double

global T;

[Nx,~,~] = size( T );
xl = str2double( get(handles.ed_crop_x_low,'String') );
xh = str2double( get(handles.ed_crop_x_high,'String') );

if xh > Nx
    xh = Nx;
    set( handles.ed_crop_x_high, 'String', num2str(xh) );
elseif xh < xl
    xh = xl;
    set( handles.ed_crop_x_high, 'String', num2str(xh) );
end


% --- Executes during object creation, after setting all properties.
function ed_crop_x_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_crop_x_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_crop_y_low_Callback(hObject, eventdata, handles)
% hObject    handle to ed_crop_y_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_crop_y_low as text
%        str2double(get(hObject,'String')) returns contents of ed_crop_y_low as a double

yl = str2double( get(handles.ed_crop_y_low,'String') );
yh = str2double( get(handles.ed_crop_y_high,'String') );

if yl < 1
    yl = 1;
    set( handles.ed_crop_y_low, 'String', num2str(yl) );
elseif yl > yh
    yl = yh;
    set( handles.ed_crop_y_low, 'String', num2str(yl) );
end


% --- Executes during object creation, after setting all properties.
function ed_crop_y_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_crop_y_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ed_crop_y_high_Callback(hObject, eventdata, handles)
% hObject    handle to ed_crop_y_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_crop_y_high as text
%        str2double(get(hObject,'String')) returns contents of ed_crop_y_high as a double
global T;

[~,Ny,~] = size( T );
yl = str2double( get(handles.ed_crop_y_low,'String') );
yh = str2double( get(handles.ed_crop_y_high,'String') );

if yh > Ny
    yh = Ny;
    set( handles.ed_crop_y_high, 'String', num2str(yh) );
elseif yh < yl
    yh = yl;
    set( handles.ed_crop_y_high, 'String', num2str(yh) );
end

% --- Executes during object creation, after setting all properties.
function ed_crop_y_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_crop_y_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_crop_z_low_Callback(hObject, eventdata, handles)
% hObject    handle to ed_crop_z_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_crop_z_low as text
%        str2double(get(hObject,'String')) returns contents of ed_crop_z_low as a double
zl = str2double( get(handles.ed_crop_z_low,'String') );
zh = str2double( get(handles.ed_crop_z_high,'String') );

if zl < 1
    zl = 1;
    set( handles.ed_crop_z_low, 'String', num2str(zl) );
elseif zl > zh
    zl = zh;
    set( handles.ed_crop_z_low, 'String', num2str(zl) );
end


% --- Executes during object creation, after setting all properties.
function ed_crop_z_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_crop_z_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_crop_z_high_Callback(hObject, eventdata, handles)
% hObject    handle to ed_crop_z_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_crop_z_high as text
%        str2double(get(hObject,'String')) returns contents of ed_crop_z_high as a double

global T;

[~,~,Nz] = size( T );
zl = str2double( get(handles.ed_crop_z_low,'String') );
zh = str2double( get(handles.ed_crop_z_high,'String') );

if zh > Nz
    zh = Nz;
    set( handles.ed_crop_z_high, 'String', num2str(zh) );
elseif zh < zl
    zh = zl;
    set( handles.ed_crop_z_high, 'String', num2str(zh) );
end

% --- Executes during object creation, after setting all properties.
function ed_crop_z_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_crop_z_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_up_flt.
function btn_up_flt_Callback(hObject, eventdata, handles)
% hObject    handle to btn_up_flt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global O;
global L;
global M;
global No;

ro = str2double( get(handles.ed_dist,'String') );
s = str2double( get(handles.ed_sens,'String') );
if (ro>=0) && (s>=0)
    J = genstickgflt( ro, s*ro );
    Id = logical( L > 0 );
    C = mask2coord( L>0 );
    [p,c] = linmap( min(min(min(O))), max(max(max(O))), 1, 0 );
    Oc = O*p + c;
    Oc(Oc<0) = 0;
    Oc(Oc>1) = 1;
    M = dirfiltersparse( Oc, C, No(:,:,:,1), No(:,:,:,2), No(:,:,:,3), J );
    Id2 = M(Id);
    p = prctile( Id2, [3;97] );
    [p,c] = linmap( p(1), p(2), 0, 100 );
    Id2 = Id2*p + c;
    M(Id) = Id2;
    M(M<0) = 0;
    M(M>100) = 100;
%     set( handles.rbtn_dflt, 'Value', 1 );
    rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);
else
    warndlg( 'The distance and sensitivity must be greater than 0.' );
end

function ed_dist_Callback(hObject, eventdata, handles)
% hObject    handle to ed_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_dist as text
%        str2double(get(hObject,'String')) returns contents of ed_dist as a double


% --- Executes during object creation, after setting all properties.
function ed_dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_sens_Callback(hObject, eventdata, handles)
% hObject    handle to ed_sens (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_sens as text
%        str2double(get(hObject,'String')) returns contents of ed_sens as a double


% --- Executes during object creation, after setting all properties.
function ed_sens_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_sens (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_up_dst.
function btn_up_dst_Callback(hObject, eventdata, handles)
% hObject    handle to btn_up_dst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global L;
global N;
global C;

% Update object labels according to its size
lv = str2double( get(handles.ed_min,'String') );
hv = str2double( get(handles.ed_max,'String') );
C = synclft3d( L>0, N, lv, hv ); 
%set( handles.rbtn_clft, 'Value', 1 );
rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);


function ed_min_Callback(hObject, eventdata, handles)
% hObject    handle to ed_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_min as text
%        str2double(get(hObject,'String')) returns contents of ed_min as a double


% --- Executes during object creation, after setting all properties.
function ed_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in rbtn_group.
function rbtn_group_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in rbtn_group 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

global F;
global T;
global L;
% global M;
% global C;
global O;
global Q;

% Selected the image for being displayed
axes( handles.ax_disp );
slider_value = round( get( handles.sldr_zs, 'Value' ) );
set( handles.ed_zs, 'String', sprintf('%i', slider_value));
% if get( handles.rbtn_clft, 'Value' )
%     Ih = C(:,:,slider_value);
%     mx = max(max(Ih));
%     if mx <= 0
%         imshow( Ih, [] );
%     else
%         imshow( Ih, jet(max(max(Ih))) );
%     end
if get( handles.rbtn_thr, 'Value' )
    imshow( T(:,:,slider_value), [] );
elseif get( handles.rbtn_lbl, 'Value' )
    Ih = L(:,:,slider_value);
    imshow( Ih, jet(max(max(Ih))) );
% elseif get( handles.rbtn_dflt, 'Value' )
%     imshow( M(:,:,slider_value), [] );    
elseif get( handles.rbtn_flt, 'Value' )
    imshow( F(:,:,slider_value), [] );
elseif get( handles.rbtn_mat, 'Value' )
    imshow( Q(:,:,slider_value), lines(256) ); 
else
    imshow( O(:,:,slider_value), [] );
end


% --- Executes on button press in btn_dc_lbl.
function btn_dc_lbl_Callback(hObject, eventdata, handles)
% hObject    handle to btn_dc_lbl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global L;
% global C;
global Q;
global cur_state;
global curs;

if (get(handles.rbtn_lbl,'Value')) %|| (get(handles.rbtn_clft,'Value'))
    if cur_state == 4
        % Get current lablel
        st = getCursorInfo( curs );
        x = st.Position(2);
        y = st.Position(1);
        z = round( get(handles.sldr_zs,'Value') );
%         if get(handles.rbtn_clft,'Value')
%             lc = C(x,y,z);
%         else
        lc = L(x,y,z);
%         end
        if lc>0
            % Change the label
            lh = round( str2double(get(handles.ed_lbl,'String')) );
            if lh >= 1
%                 if get(handles.rbtn_clft,'Value')
%                     Id = C == lc;
%                 else
                Id = L == lc;
%                 end
                Q(Id) = lh;
                % Turn cursor mode off
                datacursormode off;
                cur_state = 0;
                set( hObject, 'String', 'Display Cursor' );
                set( handles.rbtn_mat, 'Value', 1 );
                rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);
                msg = sprintf('Membrane annotated with label %i', lh);
                updateLog(handles, msg);
            else
                warndlg( 'The label must be equal or greater than 1.' );
            end
        else
            warndlg( 'No labeled object selected.' );
        end
    elseif cur_state == 0
        datacursormode on;
        cur_state = 4;
        set( hObject, 'String', 'Change Lbl.' );
    else
        warndlg( 'Another cursor activated, stop it first.' );
    end
else
    warndlg( 'This cursor only work on "Label" or "Cleft" view.' );
end

function ed_lbl_Callback(hObject, eventdata, handles)
% hObject    handle to ed_lbl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_lbl as text
%        str2double(get(hObject,'String')) returns contents of ed_lbl as a double


% --- Executes during object creation, after setting all properties.
function ed_lbl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_lbl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_max_Callback(hObject, eventdata, handles)
% hObject    handle to ed_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_max as text
%        str2double(get(hObject,'String')) returns contents of ed_max as a double


% --- Executes during object creation, after setting all properties.
function ed_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_th_Callback(hObject, eventdata, handles)
% hObject    handle to ed_th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_th as text
%        str2double(get(hObject,'String')) returns contents of ed_th as a double

set(handles.sldr_thres, 'Value', str2double(get(hObject,'String')))
sldr_thres_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ed_th_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_th (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_zs_Callback(hObject, eventdata, handles)
% hObject    handle to ed_zs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_zs as text
%        str2double(get(hObject,'String')) returns contents of ed_zs as a double
set(handles.sldr_zs, 'Value', str2double(get(hObject,'String')))
sldr_zs_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function ed_zs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_zs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_up_crop.
function btn_up_crop_Callback(hObject, eventdata, handles)
% hObject    handle to btn_up_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global T;

xl = str2double( get(handles.ed_crop_x_low,'String') );
xh = str2double( get(handles.ed_crop_x_high,'String') );
yl = str2double( get(handles.ed_crop_y_low,'String') );
yh = str2double( get(handles.ed_crop_y_high,'String') );
zl = str2double( get(handles.ed_crop_z_low,'String') );
zh = str2double( get(handles.ed_crop_z_high,'String') );

T = cropt( T, [xl xh], [yl yh], [zl zh] );
set( handles.rbtn_thr, 'Value', 1 );
rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);


% --- Executes on button press in btn_sthr.
function btn_sthr_Callback(hObject, eventdata, handles)
% hObject    handle to btn_sthr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global L;
global C;

th = str2double( get(handles.ed_sz_thr,'String') );

if get( handles.rbtn_lbl, 'Value' );
    L = L .* (L>th);
    rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);
% elseif get( handles.rbtn_clft, 'Value' );
%     C = C .* (C>th);
%     rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);
end


% --- Executes on button press in chck_clft.
function chck_clft_Callback(hObject, eventdata, handles)
% hObject    handle to chck_clft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chck_clft

global F;

% Create density slide range depending on the mode
if get(hObject,'Value')
    mn = 0;
    mx = 100;
    slider_step(1) = 1 / (mx-mn);
    slider_step(2) = 5 / (mx-mn);
else
    mx = max(max(max( F )));
    mn = min(min(min( F )));
    slider_step(1) = .1 / (mx-mn);
    slider_step(2) = .5 / (mx-mn);
end
set( handles.sldr_thres,'sliderstep', slider_step, 'max', mx, 'min', mn );
set( handles.sldr_thres, 'Value', mn );



function ed_2ds_xy_Callback(hObject, eventdata, handles)
% hObject    handle to ed_2ds_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_2ds_xy as text
%        str2double(get(hObject,'String')) returns contents of ed_2ds_xy as a double


% --- Executes during object creation, after setting all properties.
function ed_2ds_xy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_2ds_xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_2ds_xz_Callback(hObject, eventdata, handles)
% hObject    handle to ed_2ds_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_2ds_xz as text
%        str2double(get(hObject,'String')) returns contents of ed_2ds_xz as a double


% --- Executes during object creation, after setting all properties.
function ed_2ds_xz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_2ds_xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_2ds_yz_Callback(hObject, eventdata, handles)
% hObject    handle to ed_2ds_yz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_2ds_yz as text
%        str2double(get(hObject,'String')) returns contents of ed_2ds_yz as a double


% --- Executes during object creation, after setting all properties.
function ed_2ds_yz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_2ds_yz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_2ds_up.
function btn_2ds_up_Callback(hObject, eventdata, handles)
% hObject    handle to btn_2ds_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global T;

mxy = str2double( get(handles.ed_2ds_xy,'String') );
mxz = str2double( get(handles.ed_2ds_xz,'String') );
myz = str2double( get(handles.ed_2ds_yz,'String') );
h = waitbar( 0, '2D size thresholding' );
waitbar( .25, h );
if mxy > 0
    Hxy = vol3d( T, 3, 8 );
else
    Hxy = T;
end
waitbar( .50, h );
if mxz > 0
    Hxz = vol3d( T, 2, 8 );
else
    Hxz = T;
end
waitbar( .75, h );
if myz > 0
    Hyz = vol3d( T, 1, 8 );
else
    Hyz = T;
end
close( h );
T = (Hxy>mxy) .* (Hxz>mxz) .* (Hyz>myz);
set( handles.rbtn_thr, 'Value', 1 );
rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);
clear Hxy;
clear Hxz;
clear Hyz;


% --- Executes on button press in btn_sv_mat.
function btn_sv_mat_Callback(hObject, eventdata, handles)
% hObject    handle to btn_sv_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Q;
isMaterial= true;

if get(handles.rd_btn_mrc,'Value')
    if ~isempty(handles.outFilename)
        outputFile = checkOutputFilename(handles, isMaterial);
        tom_mrcwrite(Q, 'name', outputFile);
    else
        tom_mrcwrite(Q);
    end
        
else
    if ~isempty(handles.outFilename)
        outputFile = checkOutputFilename(handles, isMaterial);
        tom_emwrite(Q, 'name', outputFile);
    else
        tom_emwrite(Q);
    end
end
msg = 'Materials were correctly saved';
updateLog(handles, msg);


% --- Executes on button press in btn_figure.
function btn_figure_Callback(hObject, eventdata, handles)
% hObject    handle to btn_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global F;
global T;
global L;
% global M;
% global C;
global O;
global Q;

% Close previous figure
close(findobj('type','figure','name','membseg2 figure'));
str = 'membseg2 figure';

% Selected the image for being displayed
slider_value = round( get( handles.sldr_zs, 'Value' ) );
set( handles.ed_zs, 'String', num2str(slider_value) );
% if get( handles.rbtn_clft, 'Value' );
%     Ih = C(:,:,slider_value);
%     mx = max(max(Ih));
%     if mx <= 0
%         figure('name',str), imshow( Ih, [] );
%     else
%         figure('name',str), imshow( Ih, jet(max(max(Ih))) );
%     end
if get( handles.rbtn_thr, 'Value' )
    figure('name',str), imshow( T(:,:,slider_value), [] );
elseif get( handles.rbtn_lbl, 'Value' )
    Ih = L(:,:,slider_value);
    figure('name',str), imshow( Ih, jet(max(max(Ih))) );
% elseif get( handles.rbtn_dflt, 'Value' )
%     figure('name',str), imshow( M(:,:,slider_value), [] );    
elseif get( handles.rbtn_flt, 'Value' )
    figure('name',str), imshow( F(:,:,slider_value), [] );
elseif get( handles.rbtn_mat, 'Value' )
    figure('name',str), imshow( Q(:,:,slider_value), lines(256) ); 
else
    figure('name',str), imshow( O(:,:,slider_value), [] );
end


% --- Executes on mouse press over axes background.
function ax_disp_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ax_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in pnl_fmt.
function pnl_fmt_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in pnl_fmt 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rd_btn_mrc.
function rd_btn_mrc_Callback(hObject, eventdata, handles)
% hObject    handle to rd_btn_mrc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rd_btn_mrc


% --------------------------------------------------------------------
function openFileTool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openFileTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global O;
global F;
global T;
global L;
global M;
global C;
global Q;

% Load input tomogram
closeRequest = true;
if isempty(handles.inTomoFile)
    [fname, idir] = uigetfile( {'*.mrc';'*.rec';'*.*'}, 'Stem name of input data' );    
    if fname == 0
        handles.closeFigure = true;
    else
        [~, fstem, fext] = fileparts(fname);
        closeRequest = false;
        % TODO: This is provisional I do not why but 'tom_mrcread' sometimes has
        % problems with tomograms processed with Pyto and 3dmod
    end
else
    closeRequest = false;
    [idir, fstem, fext] = fileparts(handles.inTomoFile);
end

if ~closeRequest
    file = sprintf( '%s/%s%s', idir, fstem, fext);
    set(handles.tomoName, 'String', file);
    msg = sprintf('Reading %s...', file);
    done = 'Done';
    fprintf('\n%s\n', msg);
    updateLog(handles, msg)
    O = tom_mrcread(file).Value;
    fprintf('%s\n', done)
    updateLog(handles, done);

    file = sprintf( '%s/%s_flt%s', idir, fstem, fext );
    msg = sprintf('Reading %s...', file);
    fprintf('\n%s\n', msg);
    updateLog(handles, msg)
    F = tom_mrcread(file).Value;
    fprintf('Done\n')
    updateLog(handles, done);
    [Nx,Ny,Nz] = size( F );

    T =  false(Nx,Ny,Nz);
    L = uint32( zeros(Nx,Ny,Nz) );
    M = single( zeros(Nx,Ny,Nz) );
    C = uint32( zeros(Nx,Ny,Nz) );
    Q = uint8( zeros(Nx,Ny,Nz) );
    mn = min(min(min( F )));
    mx = max(max(max( F )));

    set( handles.sldr_thres,'SliderStep', [0.001 0.1], 'max', mx, 'min', mn );
    set( handles.sldr_thres, 'Value', mn);

    % Create slice slide range
    slider_step(1) = 1/Nz;
    slider_step(2) = 5/Nz;
    set(handles.sldr_zs,'SliderStep', slider_step, 'max', Nz, 'min', 1 );
    set( handles.sldr_zs, 'Value', round(Nz/2) );

    % Update crop panel
    set( handles.ed_crop_x_high, 'String', num2str(Nx) );
    set( handles.ed_crop_y_high, 'String', num2str(Ny) );
    set( handles.ed_crop_z_high, 'String', num2str(Nz) );

    % Show input image
    set( handles.rbtn_org, 'Value', 1 );
    rbtn_group_SelectionChangeFcn(hObject, eventdata, handles);

    % Set .mrc as default format
    set( handles.rd_btn_mrc, 'Value', 1 );
end

% Remove the incoming tomogram flag for possible next data loading during
% this session
handles.inTomoFile = '';

% Update handles structure
guidata(hObject, handles);


function outputFile = checkOutputFilename(handles, isMaterial)
[fpath, fname, ~] = fileparts(handles.outFilename);
if isMaterial
    materials = '_materials';
    if ~endsWith(fname, materials)
        fname = [fname, materials];
    end
else
    labels = '_labels';
    if ~endsWith(fname, labels)
        fname = [fname, labels];
    end
end
if get(handles.rd_btn_mrc,'Value')
    fext = '.mrc';
else
    fext = '.em';
end
outputFile = fullfile(fpath, [fname, fext]);



function cmd_list_Callback(hObject, eventdata, handles)
% hObject    handle to cmd_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmd_list as text
%        str2double(get(hObject,'String')) returns contents of cmd_list as a double


% --- Executes during object creation, after setting all properties.
function cmd_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmd_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function updateLog(handles, msg)
prevMsg = get(handles.cmd_list, 'String');
if isempty(prevMsg)
    prevMsg = {datestr(now)};
end
newMsg = [{[datestr(now), ' ----> ', msg]}; prevMsg];
set(handles.cmd_list, 'String', newMsg);
