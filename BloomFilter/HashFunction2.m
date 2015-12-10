function [x]= HashFunction2(str,size)
  % P2 HashFunction
  for i= 1:length(str)
    char=str(i)+33;
    h= bitshift(h,3)+bitshift(h,-28) + char;
  end
  x= int32(mod(h,size)+1);
end