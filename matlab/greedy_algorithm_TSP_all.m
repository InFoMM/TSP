function [path_array, cost] = greedy_algorithm_TSP_all(A,point)
% Author: Joseph Field 
% Date:   December 2016.
%
% Description:
%     This is the same as the greedy algorithm, but uses a specific
%     starting point. This algorithm is used to check the greedy algorithm
%     for all possible starting nodes.
% Input: 
%     A: Any chosen distance matrix.
%     point: Starting node to begin the algorithm.
% Output:
%     path_array: Optimal path, using this algorithm.
%     cost: Total cost for for the chosen solution.

%%
% Holder matrix to find the end connecting cost
A_original  = A;

% Check the size of the problem
[~,N] = size(A);

% Choose a random node to start with
start_node = point;

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
    
    % Node replacement
    current_node = next_node;
    path_array(t) = current_node;
    
end

path_array;
cost = cost + A_original(path_array(end),path_array(end-1));
path_array = path_array(1:end-1)';

end