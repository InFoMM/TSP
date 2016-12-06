function [ p, d, t ] = search_permutations( M )
% Author:
%     Ana Osojnik, December 2016.
% Description:
%     Checks all possible permutations of cities to find the shortest path.
%     First city to visit is fixed to be 1.
% Warning:
%     Uses huge amounts of memory, prone to causing memory crashes when
%     using beyond 10 cities. 
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
% Compute column entries
possible_paths_j = possible_paths_i(:,[2:end,1]);

% Find linear index in M given row and column numbers
idx = n*(possible_paths_i-1)+possible_paths_j;

% Column sum to obtain path lengths
path_lengths = sum(M(idx'));

% Find the shortest paths
d = min(path_lengths);
p = possible_paths_i(path_lengths==d,:);

t = toc;

end
