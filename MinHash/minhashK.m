function JDist=minhashK(Set,users,Docs_signatures,k) 


Nu = length(users);

JDist=zeros(Nu);
for n1 = 1:Nu% Get the MinHash signature for document i.
  signature1 = Docs_signatures(n1,1:k);
    
  %For each of the other test documents...
  for n2= n1+1:Nu
    
    % Get the MinHash signature for document j.
    signature2 = Docs_signatures(n2,1:k);
    
    count = 0;
    %Count the number of positions in the minhash signature which are equal.
    
    for t = 1:k
      count = count + (signature1(t) == signature2(t));
    
    % Record the percentage of positions which matched.    
    end
     JDist(n1,n2) = 1-(count / k);
  end
end
end