function [ p, d, t ] = tabu_search( M )
% Author: Ana Osojnik
% Date: December 2016
% Description:
%     Performs a metaheuristic search which is initialised by greedy
%     algorithm and further improved by a selective 2-opt search. In case of
%     failure of improvement, search restarts itself from various points as it
%     keeps short, intermediate and long memory in specific lists.

% Input:
%     M: Matrix, distance matrix between cities.
% Output:
%     p: Array, row vector of permutation of the order of cities to visit.
%     d: Float, total distance travelled in a round trip.
%     t: Float, execution time for algorithm.


tic;
n = size(M,1);

% Initial best guess obtained with greedy algorithm
start = randi([1 10]); start_prev = start;
aux_tabu_greedy
d_new = sum(sum(M));

% Find all possible combinations of edges that are allowed to be permuted
possible_moves = nchoosek(1:n,2);
possible_moves = possible_moves( (possible_moves(:,1)==1) + ...
    (possible_moves(:,2)==10) ~= 2, : );
possible_moves = possible_moves( diff(possible_moves') > 1, : );

% Set counts to 0
count = 0;
overall_count = 0;
iter = 0;
count_intermediate = 0;
count_long = 0;

% Set maximum counts
max_count = size(possible_moves,1);
batch_size = floor(max_count/5);
max_overall_count = 300*max_count;

% Set size of memory lists
tabu_size = 50; % short-term memory size
max_count_intermediate = 1; % intermediate-term memory size
max_count_long = 1; % long-term memory size

% Initialise lists
intermediate_list = zeros(max_count_intermediate,n+1);
tabu_list = zeros(tabu_size,n+1);

while overall_count <= max_overall_count
    iter = iter+1;
    fprintf('Iteration %d:\n',iter)
    
    % Permute moves to randomize search  
    permute_moves = randperm( max_count );
    iter_tabu = 0;
    while (d_new >= d) && (count < max_count)
        % Number of moves to consider in this batch
        size_candidates = min(batch_size,max_count-count);
        % Extract moves
        candidate_moves = possible_moves( permute_moves(count + (1:size_candidates)), : );
        % Initialise an indicator vector of moves that aren't in the tabu list
        not_tabu = true(1,size_candidates);
        
        % Initialise candidates to be permuted
        candidates = repmat(p, size_candidates, 1);
        count = count + size_candidates;
        for j = 1:size_candidates
            % Permute candidate j
            candidates(j,(candidate_moves(j,1)+1):candidate_moves(j,2)) = ...
                candidates(j,(candidate_moves(j,2)):(-1):(candidate_moves(j,1)+1));
            % Check if it is in tabu list, and indicate if so
            is_in_tabu = any(all((tabu_list == candidates(j,:))'));
            if is_in_tabu
                not_tabu(j) = false;
            end
        end
        
        % Disregard candidates in tabu list
        if  sum(not_tabu) > 0
            candidate_moves = candidate_moves(not_tabu,:);
            candidates = candidates(not_tabu,:);
        else
            fprintf('No non-tabu\n')
            continue
        end
        
        % Calculate paths of non-tabu candidates
        d_candidates = d - M(sub2ind([n,n],p(candidate_moves(:,1)),p(candidate_moves(:,1)+1)));
        d_candidates = d_candidates - M(sub2ind([n,n],p(candidate_moves(:,2)),p(candidate_moves(:,2)+1)));
        d_candidates = d_candidates + M(sub2ind([n,n],p(candidate_moves(:,1)),p(candidate_moves(:,2))));
        d_candidates = d_candidates + M(sub2ind([n,n],p(candidate_moves(:,1)+1),p(candidate_moves(:,2)+1)));
        
        % Find the minimum path
        [d_new,new_id] = min(d_candidates);
        
        % Add the minimum path to tabu list
        tabu_list = [candidates(new_id,:);tabu_list(1:(end-1),:)];
        iter_tabu = iter_tabu + 1;
        
        fprintf('%d\n',d_new)
        
    end
    
    % Keep track of overall number of candidates processed
    overall_count = overall_count + count;
    
    if (count == max_count) && (count_intermediate < max_count_intermediate) ...
            && any(intermediate_list(:,1)~=0)
        % If stuck, restart from the previous best candidate
        p = intermediate_list(1,:);
        d = find_distance(p(1:(end-1)),M);
        tabu_list = [tabu_list((iter_tabu+1):end,:);zeros(iter_tabu,n+1)];
        fprintf('Search restarted from the previous iteration\n')
        count = 0;
        count_intermediate = count_intermediate + 1;
        d_new = d + 1;
        continue
        
    elseif (count == max_count) && (count_long < max_count_long)
        % If really stuck after restarting from previous best candidate,
        % restart from the beginning with a different origin city for the
        % greedy initial path
        start = randi([1, 10]);
        % Check we haven't started from this point before
        while any(start_prev == start)
            start = randi([1, 10]);
        end
        % Keep track of origin cities
        start_prev = [start_prev, start];
        aux_tabu_greedy
        count = 0;
        count_long = count_long + 1;
        count_intermediate = 0;
        d_new = d + 1;
        fprintf('Search restarted with a different initial route\n')
        continue
        
    elseif (count == max_count) && (count_intermediate == max_count_intermediate) ...
           && (count_long == max_count_long)
        % If multiple restarts from various points haven't helped, declare
        % the solution as your minimum
        fprintf('Cannot find a shorter path than %d. All permutations from the last configuration considered (%d).\n',d,count)
        break
        
    else
        % If improvement of the currrent best path is found, update the
        % current best candidate and path length, and got to the next
        % iteration
        fprintf('***Improvement found***\n')
        % Perform swap of edges
        d = d_new; d_new = d + 1;
        a = candidate_moves(new_id,1); b = candidate_moves(new_id,2);
        p((a+1):b) = p(b:(-1):(a+1));
        intermediate_list = [p;intermediate_list(1:(end-1),:)];
        count = 0;
    end
end
fprintf('There were %d outer iterations and %d permutations considered overall.\n', iter, overall_count)

% Cut off the final city that concludes the cycle as its repeated
p = p(1:(end-1));

t = toc;

end
