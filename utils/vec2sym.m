function [ A ] = vec2sym( Avec )
%VEC2SYM Takes in Input a vector of elements of a symmetric matrix, and
%gives as output a symmetric n x n matrix
%ordered in the following way:
%                                           |a1        |
%     A_vec = [a1 a2 ... av]'   -->   A =   |a2 \      |
%                                           |..   \    |
%                                           |an  .. av |


n       = (-1 + sqrt(1+8*length(Avec)))/2;
A       = zeros(n,n);
smm     = 0;

for i=1:n
    lth         = n - i + 1;
    A(i:n,i)  = Avec(smm + 1:smm  + lth)';
    smm         = smm + lth;
end

A = A + A' - diag(diag(A));


end
