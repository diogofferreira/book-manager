[Set,users] = usersMovies('u.data');

Nu = length(users);

k = 1000; %Number of hashfunctions

coefA = coef_a_b(k); % k A coeficient to use in universal hashfunction
coefB = coef_a_b(k); % k B coeficient to use in universal hashfunction

N = 1682*100000; %Number of users times a 10 power to make the range of buckets
                 %way big to avoid colisions

p = 169300007;   %Prime number bigger than N

tic;
%% Get Signatures for each User
Docs_signatures = zeros(Nu,k);
for i = 1:Nu
    signature = zeros(1,k);
    for k = 1:1000
        min = N + 1;
        for j = 1:length(Set{i})
            hash_code = mod(mod(coefA(k) * Set{i}(j) + coefB(k),p),N); %Universal hashfunction
            
            if hash_code < min
                min = hash_code;
            end
        end
    signature(1,k) = min; %Save minimum value hashed
    end
    Docs_signatures(i,:) = signature; %Save signature of user ID i
end
%% Compute Jaccard Distance

JDist=zeros(Nu);
for n1 = 1:Nu
  signature1 = Docs_signatures(n1,:);
    
    for n2= n1+1:Nu
    
    % Get the MinHash signature for document j.
    signature2 = Docs_signatures(n2,:);
    
    count = 0;
    %Count the number of positions in the minhash signature which are equal.
    
    for k = 1:1000
      count = count + (signature1(k) == signature2(k));
    
    % Record the percentage of hashfunctions that agree    
    end
     JDist(n1,n2) = 1-(count / k);
  end
end

%% Find Similar Users

threshold = 0.4  %Distance limiar

SimilarUsers= zeros(1,3); % Array to keep similar pairs(user1, user2, distance)

k= 1;
  for n1= 1:Nu,
  for n2= n1+1:Nu,
    if (JDist(n1,n2) < threshold) %save only those with distance inferior
      SimilarUsers(k,:)= [users(n1) users(n2) JDist(n1,n2)];
      k= k+1;
    end
  end
  end
toc;
SimilarUsers
