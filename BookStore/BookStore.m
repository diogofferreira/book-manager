%% Get Data

[titles,ratings,users]= ReadData();

%% Insert Book Names into Bloom Filter

%L= length(titles);

%% Find Optimal P, N and K
%p = 1e-5; % False Positives Probability
%n = ceil((L*log(1/p))/log(2)^2); %Bloom Filter Length
%k = round(n/L * log(2)); %HashFunctions Length

%bloom= BloomFilter(n,k,titles(:,2));

%% Computing Jaccard Distances

Nu = length(users);

k = 1000;
coefA = coef_a_b(k);
coefB = coef_a_b(k);

c = 94906001;
N = 900000;
[Set,users] = usersBooks(ratings);
Books_signatures = zeros(Nu,k);

for i = 1:Nu
    signature = zeros(1,k);
    for t = 1:1000
        min = N*10;
        for j = 1:length(Set{i})
            hash_code = mod(mod(coefA(t) * str2double(Set{i}{j}) + coefB(t),c),N)
            if hash_code < min
                min = hash_code;
            end
            
        end
        signature(1,t) = min;
    end
    Books_signatures(i,:) = signature;
end

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
end
threshold =0.4  % limiar de decisao
% Array para guardar pares similares (user1, user2, distancia)
SimilarUsers= zeros(1,3);
k= 1;
  for n1= 1:Nu,
  for n2= n1+1:Nu,
    if (JDist(n1,n2)<0.4)
      SimilarUsers(k,:)= [users(n1) users(n2) JDist(n1,n2)];
      k= k+1;
    end
  end
  end
SimilarUsers


