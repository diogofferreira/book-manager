function [x]= HashFunction3(str,s)
    %x= rem(length(str),s); 
    x = 0;
    for i = 1:size(str)
        x = 32 * x + str(:,i);
    end
    x=mod(x,s);
end