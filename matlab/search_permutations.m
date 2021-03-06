function [ p, d, t ] = search_permutations( M )
%search_permutations algorithm performs an exhaustive search by checking all possible permutations of paths
% Author: Ana Osojnik
% Date: December 2016.
% Description:
%     Checks all possible permutations of cities to find the shortest path.
%     First city to visit is fixed to be 1.
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
tic;
n = size(M,1);

% Find all permutations of cities visited after the first one
% Includes clockwise and anticlockwise paths
possible_paths_i = perms(2:n);
no_perms = size(possible_paths_i,1);

% Add that the first city is 1 and compute row entries
possible_paths_i = [ones(no_perms,1),possible_paths_i];
% Column entries are possible_paths_i(:,[2:end,1])

% Find linear index in M given row and column numbers
idx = n*(possible_paths_i-1) + possible_paths_i(:,[2:end,1]);

% Column sum to obtain path lengths
path_lengths = sum(M(idx'));

% Find the shortest paths
d = min(path_lengths);
p = possible_paths_i(path_lengths==d,:);

t = toc;

end
