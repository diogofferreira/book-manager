function [ret] = isMember(table, key, k)
    i = 1;
    h = 0;
    while (1)
      key=[key num2str(i)];
      h = HashFunction(key,length(table));
      if(i==k || table(h)==0)
          break;
      end
      i=i+1;
    end
    
    if(i==k)
      ret=table(h);
    else
      ret=0;
    end
end


