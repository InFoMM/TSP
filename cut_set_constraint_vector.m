function [c] = cut_set_constraint_vector(n, l1, l2)
% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Computes the entries in the constrain matrix for which a vertex must
%     exist, and vectorises the output. 
% Input:
%     n: Int, total number of indices. 
%     l1: Array, set of indices.
%     l2: Array, set of indices.
% Output:
%     c: Array, row vector for constraint matrix.
c = zeros(n);
for i=l1
    for j=l2
        c(i, j) = 1;
    end
end

for i=l2
    for j=l1
        c(i, j) = 1;
    end
end

c = c(:)';

end

