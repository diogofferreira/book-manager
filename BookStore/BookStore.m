%% Get Data
tic
[titles,ratings,usersNames]= ReadData();

%% Insert Book Names into Bloom Filter

%L= length(titles);

%% Find Optimal P, N and K
%p = 1e-5; % False Positives Probability
%n = ceil((L*log(1/p))/log(2)^2); %Bloom Filter Length
%k = round(n/L * log(2)); %HashFunctions Length

%bloom= BloomFilter(n,k,titles(:,2));

%% Computing Jaccard Distances



k = 1000;
coefA = coef_a_b(k);
coefB = coef_a_b(k);

c = 94906001;
N = 900000;
[Set,users] = usersBooks(ratings);
Nu = length(users);
Books_signatures = zeros(Nu,k);

wb=waitbar(0,'Computing Signatures ...');
for i = 1:Nu
    signature = zeros(1,k);
    for t = 1:1000
        min = N*10;
        for j = 1:length(Set{i})
            
            % Replace Chars by Ascii Code in Book ID
            val=str2double(Set{i}{j});
            if(isnan(val))
                val='';
                for l=1:length(Set{i}{j})
                    if(isnan(str2double(Set{i}{j}(l))))
                        val=[val num2str(double(Set{i}{j}(l)))];
                    else
                        val=[val Set{i}{j}(l)];
                    end
                end
                val=str2double(val);
            end          
            
            hash_code = mod(mod(coefA(t) * val + coefB(t),c),N);
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
            for k = 1:1000
                count = count + (signature1(k) == signature2(k)); 
            end
            JDist(n1,n2) = 1-(count / k);
        end
    waitbar(n1/Nu);
end
close(wb);

threshold = 0.4;  % limiar de decisao
% Array para guardar pares similares (user1, user2, distancia)
SimilarUsers= zeros(1,3);
k= 1;
wb=waitbar(0,'Paring Signatures ...');
for n1= 1:Nu,
    for n2= n1+1:Nu,
        if (JDist(n1,n2)<0.4)
            SimilarUsers(k,:)= [str2double(users{n1}) str2double(users{n2}) JDist(n1,n2)];
            k= k+1;
        end
    end
    waitbar(n1/Nu,wb);
end
toc
close(wb);
SimilarUsers


