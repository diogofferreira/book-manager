function [ret] = isMember(table, key, k)
    
    i=0;
    do
      i+=1;
      key=[key num2str(i)];
      h = HashFunction(key,length(table));
    until( i==k || table(h)==0)
    
    if(i==k)
      ret=table(h);
    else
      ret=0;
    endif
    
endfunction


