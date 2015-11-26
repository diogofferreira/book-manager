function bloom=insert(bloom,str,k)
  L=length(bloom);
  for i=1:1:k
    m=num2str(i);  
    str=[str m];
    h=HashFunction(str,L);
    bloom(h)=1;
  end  
endfunction
