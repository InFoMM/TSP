%%
% Author: Joseph Field 
% Date:   December 2016.
%
% Description:
%     This is the same as the greedy algorithm, but uses a specific
%     starting point. This algorithm is used to check the greedy algorithm
%     for all possible starting nodes.
% Input: 
%     A: Any chosen distance matrix.
% Output:
%     best_path: Optimal path over ALL possible greedy algorithm solutions.
%     minimal_cost: Cost of the optimal path.
%     time: Time taken to find the solution.

%%
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
%  A = A + A'

%%
function [minimal_cost, best_path, time] = optimal_greedy_TSP(A)

tic;

[~,N] = size(A);

% Holder for the best path and minimal cost
best_path = zeros(N+1,1);
minimal_cost = 0;

% Run 'greedy_algorithm_TSP_all' over all possible starting nodes
for i = 1:N
    [path_array,cost] = greedy_algorithm_TSP_all(A,i);
    
    % Check to see if we are running the algorithm for the first time
    if minimal_cost == 0
        minimal_cost = cost;
    end
    
    % Replace the path if the cost is smaller
    if cost < minimal_cost
        minimal_cost = cost;
        best_path = path_array;
    end
end

time = toc;
    