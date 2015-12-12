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
[Set,users1000] = usersBooks(ratings);
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
SimilarUsers= zeros(1,3);
k= 1;
  for n1= 1:Nu,
  for n2= n1+1:Nu,
    if (JDist(n1,n2)<threshold)
      SimilarUsers(k,:)= [str2double(users1000{n1}) str2double(users1000{n2}) JDist(n1,n2)];
      fprintf('%-10d        %-10d        %-.5f\n',str2double(users1000{n1}),str2double(users1000{n2}),JDist(n1,n2))
      k= k+1;
    end
  end
  waitbar(n1/Nu,wb);
  end
 close(wb);
 SimilarUsers