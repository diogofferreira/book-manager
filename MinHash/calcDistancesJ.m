function J=calcDistancesJ(Set)
Nu=length(Set);
J = zeros(Nu);  % array para guardar distancias
h = waitbar(0,'Calculating Distances');
for n1= 1:Nu
  waitbar(n1/Nu,h);
  for n2= n1+1:Nu
    J(n1,n2)=1-(length(intersect(Set{n1},Set{n2}))/length(union(Set{n1},Set{n2})));%%  Adicionar codigo aqui
  end
 end
close(h);
end