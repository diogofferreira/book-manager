L=100000;  % Set Length
n=800000;  % Filter Length

%%Generate Random String Array
set_string = unique(cellstr(RandomString(40,L)));
%%Generate New Random String Array Different From The Previous
set_test = unique(setdiff(cellstr(RandomString(40,L)),set_string));

%% Calculate False Positives k= 1-15

tFp=[];
pFp=[];
count=0;
for k=1:15
  fprintf('Computing to K = %g\n',k);
  bloom_filter = BloomFilter(n,k,set_string);
  tFp=[tFp ((1-exp((-k*L)/(n)))^k)];
  for i=1:L
    if(isMember(bloom_filter,set_test{i},k))
      count=count+1;
    end
  end
  pFp=[pFp count/L];
  count = 0;
end


plot(pFp,'-+g');
hold on;
plot(tFp,'-+r');
axis('tight');
title('False Positive Probability');

