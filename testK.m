L=1000;

%%Generate Random String Array
set_string=[];
for i=1:L
  set_string=[set_string;RandomString(40)];
endfor
set_string=cellstr(set_string);

%% Initialize Filter
n=8000;
bloom_filter = initialize(n);

%% Insert Filter
k=15;
for i=1:L
  bloom_filter=insert(bloom_filter,set_string{i},k);
endfor

%%Generate New Random String Array
set_test=[];
for i=1:L
  set_test=[set_test;RandomString(40)];
endfor
set_test=cellstr(set_test);


%%Calculate False Positives
%count=0;
%for i=1:L
%  if(isMember(bloom_filter,set_test{i},k) && sum(cellfun(@(k) ~isempty(strfind(set_test{i},k)),set_string))==0)
%    count+=1;
%  endif
%endfor
%pFp=count/L;

%% Insert   
for i=1:L
  bloom_filter=insert(bloom_filter,set_string{i},k);
endfor


%%
 
tFp=[];
pFp=[];
for k=1:15
  count=0;
  tFp=[tFp (1-(1-(1/n))^(k*L))^k];
  for i=1:L
    if(isMember(bloom_filter,set_test{i},k) && length(find(ismember(set_string,set_test{i})))==0)
      count+=1;
    endif
  endfor
  pFp=[pFp count/L];
endfor

plot(pFp,'g'),hold on,plot(tFp,'r');
