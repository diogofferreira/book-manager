function bloom=insert(bloom,str,k)
  L=length(bloom);
  for i=1:k
    str= [str num2str(i)];
    bloom(HashFunction(str,L))=1;
  end  
end
