function J=calcDistancesJ(Set)

Nu=length(Set); %Number of uses

J = zeros(Nu); %Array to keep distances between each pair

h = waitbar(0,'Calculating Distances');
for n1= 1:Nu
  waitbar(n1/Nu,h);
  for n2= n1+1:Nu
    J(n1,n2)=1-(length(intersect(Set{n1},Set{n2}))/length(union(Set{n1},Set{n2}))); % Jaccard Distance Formula 
  end
 end
close(h);
end