function [ Avec ] = sym2vec( A )
%SYM2VEC converts a symmetric matrix A [n x n] to a vector Avec which 
% contains only the symmetric elements

n       = size(A,1);
Avec    = [];
vl      = n;

for i = 1:n
    Avec = [Avec; A(i:end,i)];
end

