function varargout = gui(varargin)

%% Initialization Code
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

function gui_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%% Set a Background Image
% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('bg.jpg'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');

%% Read and Slice Data

[titles,ratings,users] = ReadData();
handles.titles= titles(1:5e4,:);
[handles.Set,users1000] = usersBooks(ratings);

Set = handles.Set;
%% Insert Book Names into Bloom Filter
L = length(titles);

%% Find Optimal P, N and K
p = 1e-4;                        % False Positives Probability
n = ceil((L*log(1/p))/log(2)^2); % Bloom Filter Length
handles.k = round(n/L * log(2)); % HashFunctions Length

%% Insert Set into Bloom Filter

handles.bloom = BloomFilter(n,handles.k,handles.titles(:,2));

%% Set Listbox Data

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
      k= k+1;
    end
  end
  waitbar(n1/Nu,wb);
  end
 close(wb);
guidata(hObject, handles);

function varargout = gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function listbox1_Callback(hObject, eventdata, handles)

%% Show Books Cover Image
if strcmp(get(gcf,'selectiontype'),'open')
   seltype = get(handles.listbox1,'String');
   seltype = seltype{get(handles.listbox1,'Value')};
   idx = find(ismember(handles.titles(:,2),seltype));
   % When the Image is Empty, Show an Error Image
   try
      figure
      imshow(imread(handles.titles{idx(1),3},'jpg'));
   catch ME
       imshow(imread('unavailable','png'));
   end
end
guidata(hObject, handles);


function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function listbox2_Callback(hObject, eventdata, handles)
%% Show Ratings of each User
z=[];
seltype = get(gcbo,'value');
x = handles.Set{seltype};
for i=1:length(x)
   idx=find(ismember(handles.titles(:,1),x(i)));
   for j=1:length(idx)
        z=[z handles.titles(idx(j),2)];
   end
end
% When the Book doesnt exists, Show an Default String
if(length(z)<1)
    z = '*** Unavailable Books ***';
else
    z = sort(z);
end
set(handles.listbox1,'String',z,'Value',1);
guidata(hObject, handles); 


function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1_Callback(hObject, eventdata, handles)


function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton1_Callback(hObject, eventdata, handles)
%% Search for Book in the Dataset
    val = get(handles.edit1,'String');
    if (isMember(handles.bloom,val,handles.k))
        msgbox('It is very likely that the book exists');
    else
        msgbox('The book definitely does not exist');
    end

function pushbutton2_Callback(hObject, eventdata, handles)

%% Open Similar Users Windows
varargout = guiSimilar(figure(guiSimilar));
a = findall(0,'tag','listbox1Similar');
b = findall(0,'tag','listbox2Similar');
c = findall(0,'tag','listbox3Similar');
set(a,'string',num2str(handles.SimilarUsers(:,1)));
set(b,'string',num2str(handles.SimilarUsers(:,2)));
set(c,'string',num2str(handles.SimilarUsers(:,3)));

function pushbutton3_Callback(hObject, eventdata, handles)

%% Show the Initial Book List
set(handles.listbox1,'String',sort(handles.titles(:,2)));
