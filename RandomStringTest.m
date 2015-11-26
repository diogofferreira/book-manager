L=1000;  % Set Length
n=8000;  % Filter Length

%%Generate Random String Array
set_string=cellstr(RandomString(40,L));

%%Generate New Random String Array
set_test=cellstr(RandomString(40,L));

%% Calculate False Positives k= 1-15

tFp=[];
pFp=[];
count=0;
for k=1:15
  %fprintf("----------------------%g----------------\n",k);
  bloom_filter=BloomFilter(n,k,set_string);
  tFp=[tFp ((1-e^((-k*L)/(n)))^k)];
  for i=1:L
    mem=isMember(bloom_filter,set_test{i},k);
    %fprintf("%s-%g\n",set_test{i},mem);
    if(mem && length(find(ismember(set_string,set_test{i})))==0)
      count+=1;
    endif
  endfor
  pFp=[pFp count/L];
endfor

plot(pFp,'g'),hold on,plot(tFp,'r');

axis([0 15 0 1]);