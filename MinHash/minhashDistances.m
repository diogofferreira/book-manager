function JDist = minhashDistances(Nu,num_hash_functions,Docs_signatures)
    % Compute Jaccard Distances
    JDist=zeros(Nu);    
    for n1 = 1:Nu
        signature1 = Docs_signatures(n1,:);
        for n2= n1+1:Nu
        signature2 = Docs_signatures(n2,:);
        count = 0;
            for k = 1:num_hash_functions
                count = count + (signature1(k) == signature2(k));   
            end
        JDist(n1,n2) = 1-(count / k);
        end
    end
end
