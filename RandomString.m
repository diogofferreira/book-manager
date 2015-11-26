function [string] = RandomString(len)
  simbolos= ['a':'z' 'A':'Z' '0':'9'];
  string='';
  for i=1:len
    simb=  floor(rand()*length(simbolos))+1;
    string(i)=char(simbolos(simb));
  endfor
endfunction
  