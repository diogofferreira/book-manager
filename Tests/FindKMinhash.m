%% This function computes the max error between Jaccard Distance using the formula and
%% the MinHash technique with different number of hashfunctions (k)
%% The execution of this file takes a lot of time so we tested it during implementation and save the 
%% matrix with the max values per k in the file Dif_Matrix.mat to make it easier to plot

[Set,users] = usersMovies('u.data');

Nu=length(users);

%% Computing Jaccard Distance using the formula
J=zeros(Nu);
h= waitbar(0,'Calculating');
for n1= 1:Nu
  waitbar(n1/Nu,h);
  for n2= n1+1:Nu
  J(n1,n2)=1-(length(intersect(Set{n1},Set{n2}))/length(union(Set{n1},Set{n2})));
  end
 end
delete (h)

%% Computing Signatures
k=1000;
coefA = coef_a_b(k);
coefB = coef_a_b(k);

N = 1682*100000;
p = 16930000;

tic;
Docs_signatures = zeros(Nu,k);
for i = 1:Nu
    signature = zeros(1,k);
    for t = 1:k
        min = N+1;
        for j = 1:length(Set{i})
            hash_code = mod(mod(coefA(t) * Set{i}(j) + coefB(t),p),N);
            
            if hash_code < min
                min = hash_code;
            end
        end
    signature(1,t) = min;
    end
    Docs_signatures(i,:) = signature;
end
toc;

%% For each k find the max error and plot it
dif = zeros(1,k);
for i = 1:k
    JDist = minhashK(users,Docs_signatures,i);
    difDistances = JDist-J;
    dif(1,i) = abs(max(difDistances(:)));
    plot(dif(1:i))
    drawnow
end