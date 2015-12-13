function JDist=minhashK(users,Docs_signatures,k) 

%This function returns an array with the values of Jaccard Distance
%calculated using MinHash between each pair of users who rated the movies.
%Docs_signatures represent the MinHash Signatures of length defined in the
%file FindKMinhash
%Here the argument k is the number of hashfunctions that will be used to
%compare the signatures.


Nu = length(users);

JDist = zeros(Nu);

for n1 = 1:Nu 
  signature1 = Docs_signatures(n1,1:k); %Chooses only the first k values for comparison
    
  for n2 = n1 + 1:Nu
    
  signature2 = Docs_signatures(n2,1:k); %Chooses only the first k values for comparison
    
    count = 0;  %Count the number of positions in the minhash signature that agree
    
    for t = 1:k
      count = count + (signature1(t) == signature2(t));
       
    end
     JDist(n1,n2) = 1-(count / k); %Saves Jaccard Distance
  end
end
end