set_string = {'Filipa';'Leticia';'Ana';'Rita'};
set_test = {'Diogo';'leticia';'ola';'Ana'};
n=100;
k=3;

%% Create Bloom Filter
bloom_filter= BloomFilter(n,k,set_string);


%% Test Membership


% The Inserted Set

for i=1:length(set_string)
  test=isMember(bloom_filter,set_string{i},k);
  if test==1
    fprintf(" %s is Probably a Member\n",set_string{i});
  else
    fprintf(" %s is Not a Member\n",set_string{i});
  endif
endfor

% Another Set
fp=0;
for i=1:length(set_test)
  test=isMember(bloom_filter,set_test{i},k);
  if test==1 && ~strmatch(set_test{i},set_string) 
    fprintf(" %s is Probably a Member\n",set_test{i});
    fp+=1;
  elseif(test==1 && strmatch(set_test{i},set_string))
    fprintf(" %s is Probably a Member\n",set_test{i});
  else
    fprintf(" %s is Not a Member\n",set_test{i});
  endif
endfor

pFpT=((1-e^((-k*4)/(n)))^k);
pFpP=fp/length(set_test);

fprintf("False Positives (T) = %g\n",pFpT);
fprintf("False Positives (P) = %g\n",pFpP);
