set_string = {'Filipa';'Leticia';'Ana';'Rita'};
set_test = {'Diogo';'leticia';'Luis';'Ana'};
n=100;
k=3;

%% Create Bloom Filter
bloom_filter= BloomFilter(n,k,set_string);


%% Test Membership

% The Inserted Set
fprintf('*** Inserted Set ***\n');
for i=1:length(set_string)
  test=isMember(bloom_filter,set_string{i},k);
  if test==1
    fprintf(' %s is Probably a Member\n',set_string{i});
  else
    fprintf(' %s is Not a Member\n',set_string{i});
  end
end

% Another Set
fprintf('\n*** Another Set ***\n');
fp=0;
for i=1:length(set_test)
  test=isMember(bloom_filter,set_test{i},k);
  if test==1 && ~strmatch(set_test{i},set_string) 
    fprintf(' %s is Probably a Member\n',set_test{i});
    fp=fp+1;
  elseif(test==1 && strmatch(set_test{i},set_string))
    fprintf(' %s is Probably a Member\n',set_test{i});
  else
    fprintf(' %s is Not a Member\n',set_test{i});
  end
end

pFpT=((1-exp((-k*4)/(n)))^k);
pFpP=fp/length(set_test);

%% Conclusions
fprintf('\nFalse Positives (T) = %g\n',pFpT);
fprintf('False Positives (P) = %g\n',pFpP);
