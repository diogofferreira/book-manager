function [string] = RandomString(len)
    symbols= ['a':'z' 'A':'Z' '0':'9'];
    string='';
    for i=1:len
        simb= floor(rand()*length(symbols))+1;
        string(i)=char(symbols(simb));
    end
end
  