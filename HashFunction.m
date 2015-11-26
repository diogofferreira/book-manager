function [x]= HashFunction(str,size)
  h=0;
  for i= 1:length(str)
    char=str(i)+33;
    h= bitshift(h,3)+bitshift(h,-28) + char;
  endfor
  x= int32(mod(h,size)+1);
endfunction