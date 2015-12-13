function [r] = UniversalHash(x)
    p=primes(x*ceil(rand()*5));
    p=p(length(p));
    N=ceil(p/(rand()*6));
    a=ceil(rand()*x);
    b=ceil(rand()*x);
    r= rem(rem((a*x+b),p),N);
end

