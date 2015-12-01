function [x]= HashFunction(str,s)
  % Djb2 Hash Function
  str = double(str);
  x = 5381*ones(size(str,1),1);
  for i= 1:size(str,2)
    x= mod(x * 33+str(:,i),2^32);
  end
  x= mod(x,s)+1;
end