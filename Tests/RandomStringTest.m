L=1e4;  % Set Length
n=8e4;  % Filter Length

wb=waitbar(0,'Computing ...');

%%Generate Random String Cell
set_string= RandomStringGenerator(40,L);

%%Generate New Random String Cell Different From The Previous
set_test= unique(setdiff(RandomStringGenerator(40,L),set_string));

%% Calculate False Positives k= 1-15

tFp=zeros(1,15);
pFp=zeros(1,15);
count=0;
for k=1:15
  tic
  bloom_filter = BloomFilter(n,k,set_string);
  tFp(k)=(1-exp((-k*L)/(n)))^k;
  for i=1:L
    if(isMember(bloom_filter,set_test{i},k))
      count=count+1;
    end
  end
  pFp(k)=count/L;
  count = 0;
  wb=waitbar(k/15,wb,sprintf('Computing ... (K=%d)',k));
  toc
end
close(wb);

plot(pFp','-+g');
hold on;
plot(tFp','-+r');
axis('tight');
title('False Positive Probability');

