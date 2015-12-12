function [coef] = coef_a_b_books(k)
    m=271379*1000000; % Gamma
    coef = zeros(1,k); %Create a list of 'k' random values.

    while k > 0
        randcoef = floor(1 + rand()*m);
        %Random Value must be unique
        while isempty(find(coef==randcoef, 1))==0
          randcoef = floor(1 + rand()*m);
        end

        coef(1,k)=randcoef;
        k = k - 1;
    end
end