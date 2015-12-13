function Docs_signatures = minhashSignatures(Set,Nu,k,coefA,coefB,p,N)

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
end