function [ret] = isMember(table, key, k)
    i=0;
    
    do
      i+=1;
      key=[key num2str(i)];
      h = HashFunction(key,length(table));
    until( i==k || ~isSet(table(h)))
    
    if(i==k)
      ret=isSet(table(h));
    else
      ret=0;
    endif
    
endfunction
