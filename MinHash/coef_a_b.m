function [coef] = coef_a_b(k)
%udata=load('u.data');  % Carrega o ficheiro dos dados dos filmes
 
% Fica apenas com as duas primeiras colunas
%u= udata(1:end,1:2);
%unique(udata(:,2))
%m = max(udata(:,2))%---retorna o maximo valor do filmes para assim escolhermos
% o numero primo a seguir valor de c = 1693
m=1682;
%c = 1693;
%Create a list of 'k' random values.
coef = zeros(1,k);
  
while k > 0
    %Get a random shingle ID.
    randcoef = floor(1 + rand()*m);
  
    %Ensure that each random number is unique.
    while isempty(find(coef==randcoef, 1))==0
      randcoef = floor(1 + rand()*m);
    end
    % Add the random number to the list.
    coef(1,k)=randcoef;
    k = k - 1;
end