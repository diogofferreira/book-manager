function varargout = gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%% Read and Slice Data

[titles,ratings,users] = ReadData();
handles.titles= titles(1:5e4,:);
[handles.Set,users1000] = usersBooks(ratings);

Set = handles.Set;
%% Insert Book Names into Bloom Filter
L = length(titles);

% Find Optimal P, N and K
p = 1e-4;                        % False Positives Probability
n = ceil((L*log(1/p))/log(2)^2); % Bloom Filter Length
handles.k = round(n/L * log(2)); % HashFunctions Length


handles.bloom = BloomFilter(n,handles.k,handles.titles(:,2));


%c = cellfun(@(x)str2double(x), users(8000:9000,1));
c = cellfun(@(x)str2double(x), users1000);
set(handles.listbox1,'String',sort(handles.titles(:,2)));
set(handles.listbox2,'String',c);
%% Computing Jaccard Distances
Nu = length(users1000);

k = 1000;
coefA = coef_a_b_books(k);
coefB = coef_a_b_books(k);

N=271379000000;%nº de livros multiplicado por uma potência de 10
p=271379000033;%primo maior que N


Books_signatures = zeros(2,k);

wb=waitbar(0,'Computing Signatures ...');
for i = 1:Nu
    signature = zeros(1,k);
    for t = 1:k
        min = N + 1;
        
        for j = 1:length(Set{i})
            string2hash = HashFunction(Set{i}{j},N);
            hash_code = mod(mod(coefA(t) * string2hash + coefB(t),p),N);
            
            if hash_code < min
                min = hash_code;
            end
        end
        signature(1,t) = min;
    end
    Books_signatures(i,:) = signature;
    waitbar(i/Nu,wb);
end
close(wb);

wb=waitbar(0,'Computing Distances ...');
%Nu=2;
JDist=zeros(Nu);
for n1 = 1:Nu% Get the MinHash signature for document i.
  signature1 = Books_signatures(n1,:);
    
  %For each of the other test documents...
  for n2= n1+1:Nu
    
    % Get the MinHash signature for document j.
    signature2 = Books_signatures(n2,:);
    
    count = 0;
    %Count the number of positions in the minhash signature which are equal.
    
    for k = 1:1000
      count = count + (signature1(k) == signature2(k));
    
    % Record the percentage of positions which matched.    
    end
     JDist(n1,n2) = 1-(count / k);
  end
  waitbar(n1/Nu);
end
close(wb);

wb=waitbar(0,'Paring Signatures ...');
threshold =0.5;  % limiar de decisao
% Array para guardar pares similares (user1, user2, distancia)
handles.SimilarUsers= zeros(1,3);
k= 1;
  for n1= 1:Nu,
  for n2= n1+1:Nu,
    if (JDist(n1,n2)<threshold)
      handles.SimilarUsers(k,:)= [str2double(users1000{n1}) str2double(users1000{n2}) JDist(n1,n2)];
      %fprintf('%-10d        %-10d        %-.5f\n',str2double(users1000{n1}),str2double(users1000{n2}),JDist(n1,n2))
      k= k+1;
    end
  end
  waitbar(n1/Nu,wb);
  end
 close(wb);
guidata(hObject, handles);


% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
if strcmp(get(gcf,'selectiontype'),'open')
   seltype = get(handles.listbox1,'String');
   seltype = seltype{get(handles.listbox1,'Value')};
   idx = find(ismember(handles.titles(:,2),seltype));
   figure
   handles.titles{idx(1),3}
   imshow(imread(handles.titles{idx(1),3},'jpg')); 
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
z=[];
if strcmp(get(gcf,'selectiontype'),'open')
   seltype = get(gcbo,'value');
   x = handles.Set{seltype};
   for i=1:length(x)
       idx=find(ismember(handles.titles(:,1),x(i)));
       for j=1:length(idx)
            z=[z handles.titles(idx(j),2)];
       end
   end
end
set(handles.listbox1,'String',sort(z));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    val = get(handles.edit1,'String');
    val=val{1};
    if (isMember(handles.bloom,val,handles.k))
        msgbox('It is very likely that the book exists');
    else
        msgbox('The book definitely does not exist');
    end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout = guiSimilar(figure(guiSimilar));
H = findall(0,'tag','listbox1Similar');
set(H,'string',num2str(handles.SimilarUsers()));


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listbox1,'String',sort(handles.titles(:,2)));