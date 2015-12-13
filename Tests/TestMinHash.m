[Set,users] = usersMovies('u.data');

Nu = length(users);

k = 1000; %Number of hashfunctions

coefA = coef_a_b(k); % k A coeficient to use in universal hashfunction
coefB = coef_a_b(k); % k B coeficient to use in universal hashfunction

N = 1682*100000; %Number of users times a 10 power to make the range of buckets
                 %way big to avoid colisions

p = 169300007;   %Prime number bigger than N

threshold = 0.4;
tic;
Docs_Signatures = minhashSignatures(Set,Nu,k,coefA,coefB,p,N);

JDist = minhashDistances(Nu,k,Docs_Signatures);

SimilarUsers = findSimilarMinhash(threshold,JDist,users);

toc;
SimilarUsers