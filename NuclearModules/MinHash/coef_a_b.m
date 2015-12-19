function [coef] = coef_a_b(k)
    m=168200000; % Range of the coeficients A and B from the universal hash
                 % We chose this value after several reading about the
                 % universal hash
    coef = zeros(1,k);
    
    %Create a list of 'k' random values all diferent

    while k > 0
        randcoef = floor(1 + rand()*m);
   
        while isempty(find(coef==randcoef, 1))==0
          randcoef = floor(1 + rand()*m);
        end

        coef(1,k)=randcoef;
        k = k - 1;
    end
end