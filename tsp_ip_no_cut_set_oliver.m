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


t = toc;
end

