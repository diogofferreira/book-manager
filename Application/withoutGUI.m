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
coefA = coef_a_b_books(k); % k A coeficient to use in universal hashfunction
coefB = coef_a_b_books(k); % k B coeficient to use in universal hashfunction

N=271379000000; %Number of users times a 10 power to make the range of buckets
                %way big to avoid colisions
p=271379000033; %Prime number bigger than N


Books_signatures = zeros(1,k);

wb=waitbar(0,'Computing Signatures ...');
for i = 1:Nu
    signature = zeros(1,k);
    for t = 1:k
        min = N + 1;
        
        for j = 1:length(Set{i})
            string2hash = HashFunction(Set{i}{j},N); %Maps string into integer within range N
            hash_code = mod(mod(coefA(t) * string2hash + coefB(t),p),N); %Universal hashfunction
            
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

JDist=zeros(Nu);
for n1 = 1:Nu
  signature1 = Books_signatures(n1,:);
    
  for n2= n1+1:Nu
    
    signature2 = Books_signatures(n2,:);
    
    count = 0;
        
    for t = 1:k
      count = count + (signature1(t) == signature2(t));
    
    % Record the percentage of positions which matched.    
    end
     JDist(n1,n2) = 1-(count / k);
  end
  waitbar(n1/Nu);
end
close(wb);

wb=waitbar(0,'Paring Signatures ...');

threshold = 0.5; 

SimilarUsers= zeros(1,3);
fprintf('%-10s\t%-10s\t%-10s\t%-10s\n','User 1','User 2','Distance','Expected Distance')

k= 1;
  for n1= 1:Nu,
    for n2= n1+1:Nu,
         if (JDist(n1,n2)<threshold)
            SimilarUsers(k,:)= [str2double(users1000{n1}) str2double(users1000{n2}) JDist(n1,n2)];
         fprintf('%-10d\t%-10d\t%-10.5f\t%-10.5f\n',str2double(users1000{n1}),str2double(users1000{n2}),JDist(n1,n2),1-(length(intersect(Set{n1},Set{n2}))/length(union(Set{n1},Set{n2}))))
         k= k+1;
         end
    end
  waitbar(n1/Nu,wb);
  end
  
close(wb);
SimilarUsers;