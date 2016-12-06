function [path_array, cost, time] = stochastic_TSP(A, n)
% Author: Joseph Field
% Date:   December 2016.
%
% Description:
%     Finds the 'shortest' path for the travelling salesman problem, using
%     a sequence of randomly generated paths. The final solution is the
%     path which is shorter than the following 'n' paths.
% Input: 
%     A: Any chosen distance matrix.
%     n: Number of 'wins' that a path must have before being chosen as the
%     'shortest'.
% Output:
%     path_array: Optimal path, given numerically.
%     cost: Total cost for for the chosen solution.
%     time: Time taken to find the solution.

%%
format compact;

% Holder matrix to find the end connecting cost
A_original  = A;

% Check the size of the problem
[~,N] = size(A);

% Counter of unbeaten record
winner_count = 0;

% Stochastic path choice
path_to_check = randperm(N,N);
ptc = path_to_check;
current_path = ptc;

% Calculate the initial cost
cost = 0;
for j = 1:N-1
    cost = cost + A(ptc(j),ptc(j+1));
end
cost = cost + A(ptc(end),ptc(1))

% Start the timer after the initialisations
tic;

% Optimal choice must be unbeaten for 'n' trials
while winner_count < n
     
    % Find a new path and then check against the current
    ptc = randperm(N,N);
    
    % Calculate the initial cost
    new_cost = 0;
    for j = 1:N-1
        new_cost = new_cost + A(ptc(j),ptc(j+1));
    end
    new_cost = new_cost + A(ptc(end),ptc(1));
    
    % If the new cost is cheaper, update the cost and the path
    if new_cost < cost
        current_path = ptc;
        cost = new_cost;
        winner_count = 0;
    else
        winner_count = winner_count + 1;
    end
end

path_array = current_path;
path_array = path_array(1:end-1)';
time = toc;


end
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