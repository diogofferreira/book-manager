function SimilarUsers=findSimilar(distJ,threshold,ids)
%%  Based on distance finds similar pairs bellow a limit
Nu=length(ids);
threshold = 0.4;  % limit

SimilarUsers= zeros(1,3);% Array to savesimilar pairs (user1, user2, distance)
k= 1;
h = waitbar(0,'Calculating Similars');
for n1= 1:Nu,
    waitbar(n1/Nu,h);
    for n2= n1+1:Nu,
        if (distJ(n1,n2) < threshold)
            SimilarUsers(k,:)= [ids(n1) ids(n2) distJ(n1,n2)];
            k= k+1;
        end
    end
end
close(h);
end