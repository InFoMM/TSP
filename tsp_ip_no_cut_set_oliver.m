function [p, d, t] = tsp_ip_no_cut_set_oliver(M)
% Author: 
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Solves the travelling salesman problem using integer programming
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
intcon = ones(n2, 1); % All entries of x must be integers.
lb = zeros(n2, 1);
ub = ones(n2, 1);
ub((1:n)+(0:n-1)*n) = 0;
X = intlinprog(f, intcon, [], [], Aeq, beq, lb, ub, optimoptions('intlinprog','Display','off'));
X = reshape(X, n, n);
P = p_matrix(X);
d = compute_final_d(M, P);
p = compute_paths_with_loops(P);
t = toc;
end

