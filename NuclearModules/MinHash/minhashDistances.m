function JDist = minhashDistances(Nu,k,Docs_signatures)
   %% Compute Jaccard Distance

JDist=zeros(Nu);
for n1 = 1:Nu
  signature1 = Docs_signatures(n1,:);
    
    for n2= n1+1:Nu
    
    % Get the MinHash signature for document j.
    signature2 = Docs_signatures(n2,:);
    
    count = 0;
    %Count the number of positions in the minhash signature which are equal.
    
         for i = 1:k
          count = count + (signature1(i) == signature2(i));
    
        % Record the percentage of hashfunctions that agree    
        end
    JDist(n1,n2) = 1-(count / k);
    end
end
end