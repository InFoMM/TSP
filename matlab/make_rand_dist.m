function [M] = make_rand_dist(n, s)
% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Makes a distance matrix.
% Input:
%     n: Int, size of matrix.
%     s: Int, random number generator seed. Default is 0 which does not
%          reset the seed.
% Output:
%     M: Matrix, distance matrix.
if s
    randn('seed', s)
end
M = randn(n);
M = M.^2;
M = M + M';
M = M - diag(diag(M));
end

