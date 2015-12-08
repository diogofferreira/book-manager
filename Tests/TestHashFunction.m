L = 1e4;   % Set Length
n = 8e4;   % Filter Length
k = 6;     % HashFunctions number

%%Generate Random String Cell
set_string= RandomStringGenerator(40,L);

%% Computing HashFunctions

% Djb2 HashFunction
matrix= zeros(L,k);
for i=1:L
    key= set_string{i};
    for j=1:k
        key=[key num2str(j)];
        matrix(i,j)= HashFunction(key,n);
    end   
end

% P2 HashFunction
matrix1= zeros(L,k);
for i=1:L
    key= set_string{i};
    for j=1:k
        key=[key num2str(j)];
        matrix1(i,j)= HashFunction2(key,n);
    end   
end

%% Creating Plots

for t=1:k
    tmp=ceil(k/2);
    subplot(2,tmp,t)
    plot(matrix(:,t));
    t=sprintf('K = %g',t);
    title(t);
end


%% Computing Correlation

% Djb2 HashFunction
correlation= zeros(k,k);
for i=1:k
    for j=1:k
        if(i==j)
            continue;
        else
            z= corrcoef([matrix(:,i) matrix(:,j)]);
            correlation(i,j)=z(2,1);
        end
    end
end

% P2 HashFunction
correlation1= zeros(k,k);
for i=1:k
    for j=1:k
        if(i==j)
            continue;
        else
            z= corrcoef([matrix1(:,i) matrix1(:,j)]);
            correlation1(i,j)=z(2,1);
        end
    end
end

%% Show Correlation Plot

figure
bar3(correlation)
title('Djb2 HashFunction'); 
figure
bar3(correlation1)
title('P2 HashFunction'); 