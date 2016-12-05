function [p, d, t] = increasing_loop(M)
% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Given a loop of some cities, computes which would be the next
%     cheapest city to include in the path, and then increases the path
%     accordingly.
% Input:
%     M: Matrix, distance matrix between cities.
% Output:
%     p: Array, row vector of permutation of the order of cities to visit.
%     d: Float, total distance travelled in a round trip.
%     t: Float, execution time for algorithm.


tic
% Body of function
t = toc;
end