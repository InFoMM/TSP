function [path_array,cost, time] = greedy_algorithm_TSP(A)
% Author: Joseph Field 
% Date:   December 2016.
%
% Description:
%     Finds the shortest path to solve the travelling salesman problem,
%     using a local greedy algorithm. For each node, the algorithm moves
%     along the shortest edge, and removes all other connecting edges, to
%     make sure that sub-loops do not occur. The final connection is then
%     built once the final node is known.
% Input: 
%     A: Any chosen distance matrix.
% Output:
%     path_array: Optimal path, using this algorithm.
%     cost: Total cost for for the chosen solution.
%     time: Float, time taken for function execution.

%%
tic;
% Holder matrix to find the end connecting cost
A_original  = A;

% Check the size of the problem
[~,N] = size(A);

% Choose a random node to start with
start_node = randperm(N,1);

% Initialise the path
path_array = zeros(N+1,1);

path_array(1) = start_node;
path_array(end) = start_node;

% Initialise holders for nodes and current cost
current_node = start_node;
cost = 0;

for t = 2:N
    
    i = current_node;

    % Find the minimum cost node from this point, assuming we cannot return
    % to a node already visited
    index = find(A(i,:) ~= 0);
    min_cost = min(A(i,index));
    
    % If there are multiple paths with the same cost, this condition
    % chooses the first one in the (arbitrary) ordering
    next_node = find(A(i,:) == min_cost);
    next_node = min(next_node);
    
    cost = cost + min_cost;
    
    % This ensures that the point cannot be reached again
    A(i,:) = 0;
    A(:,i) = 0;
    
    current_node = next_node;
    path_array(t) = current_node;
    
end

path_array;
cost = cost + A_original(path_array(end),path_array(end-1));
path_array = path_array(1:end-1)';
time = toc;

%% 
% The adjacency matrix for the Spain Assignment is below.
%
% A = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0
%      515, 0, 0, 0, 0, 0, 0, 0, 0, 0
%      353, 868, 0, 0, 0, 0, 0, 0, 0, 0
%      422, 621, 434, 0, 0, 0, 0, 0, 0, 0
%      482, 997, 129, 544, 0, 0, 0, 0, 0, 0
%      673, 437, 841, 407, 951, 0, 0, 0, 0, 0
%      634, 778, 631, 212, 756, 440, 0, 0, 0, 0
%      815, 693, 827, 393, 937, 267, 363, 0, 0, 0
%      609, 1046, 256, 538, 219, 945, 474, 837, 0, 0
%      166, 349, 519, 352, 648, 501, 564, 673, 697, 0];
%  
%  A = A + A';

%%
end