function chave = RandomStringGenerator(len,size)
    symbols= ['a':'z' 'A':'Z' '0':'9'];
    chave = symbols(randi(numel(symbols),size,len));
    chave= cellstr(chave);
end