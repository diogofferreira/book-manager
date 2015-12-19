function SimilarUsers = findSimilarMinhash(threshold,JDist,users)
Nu = length(users);

SimilarUsers= zeros(1,3); % Array to keep similar pairs(user1, user2, distance)

k = 1;
  for n1= 1:Nu,
      for n2= n1+1:Nu,
        if (JDist(n1,n2) < threshold) %save only those with distance inferior
            SimilarUsers(k,:)= [users(n1) users(n2) JDist(n1,n2)];
        k= k+1;
        end
      end
  end