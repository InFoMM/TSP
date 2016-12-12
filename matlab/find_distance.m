function [ d ] = find_distance( p, M )
% Author: Ana Osojnik
% Date: December 2016
% Description:
%   Finds the length of the path given a sequence of cities p

% Input:
%     p: Array, row vector of permutation of the order of cities to visit.
%     M: Matrix, distance matrix between cities.
% Output:
%     d: Float, total distance travelled in a round trip.

n = size(M,2);
idx = [p;p([2:end,1])];

idx_lin = (idx(1,:)-1)*n+idx(2,:);
d = sum(M(idx_lin));


end

