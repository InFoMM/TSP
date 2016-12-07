function [p, d, t] = tsp_lp_no_cut_set_oliver(M)
% Author: 
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Solves the travelling salesman problem using linear programming
%     without the cut-set constraint (i.e. allows loops).
% Input:
%     M: Matrix, distance matrix between cities.
% Output:
%     p: Array, row vector of permutation of the order of cities to visit.
%     d: Float, total distance travelled in a round trip.
%     t: Float, execution time for algorithm.
if range(size(M))
    error('Input a square distance matrix.')
elseif ~issymmetric(M)
    error('Input a symmetric distance matrix.')
end
tic

n = size(M, 1);
f = M; % Ensuring we move to/from different cities.
f = f(:);
n2 = n^2;
Aeq = spalloc(2*n, n2, 2*n2);
beq = ones(2*n, 1);
% Making all the rows sum to one.
for i=1:n
    Aeq(i, n*(i-1) + (1:n)) = 1;
end
% Making all the columns sum to one.
for i=1:n
   Aeq(i+n, i + n*(0:n-1)) = 1;
end
% full(Aeq)
lb = zeros(n2, 1);
ub = ones(n2, 1);
ub((1:n)+(0:n-1)*n) = 0;
warning('off') % This is not an ideal fix.
X = linprog(f, [], [], Aeq, beq, lb, ub, optimoptions('linprog','Display', 'off'));
warning('on')
X = reshape(X, n, n);
X(X<1e-10) = 0;
% Past this point X begins to have non-integer entries, corresponding to
% partial edges. This is unphysical, and so we now return NaN results. 
% P = p_matrix(X);
d = [nan];
p = [nan];
t = toc;
end

