function [ p, d, t ] = tabu_search( M )
%tabu_search Summary of this function goes here
%   Detailed explanation goes here

tic;
n = size(M,1);
for j = 5:5
    start = randi([1 10]); start_prev = start;
    greedy
end
d_new = sum(sum(M));

%idx_p = [p;p([2:end,1])];
count = 0;
overall_count = 0;
iter = 0;

possible_moves = nchoosek(1:n,2);
possible_moves = possible_moves( (possible_moves(:,1)==1) + ...
    (possible_moves(:,2)==10) ~= 2, : );
possible_moves = possible_moves( diff(possible_moves') > 1, : );

max_count = size(possible_moves,1);
batch_size = floor(max_count/5);
max_overall_count = 300*max_count;

count_intermediate = 0;
count_long = 0;

tabu_size = 50;
max_count_intermediate = 1;
max_count_long = 1;

intermediate_list = zeros(max_count_intermediate,n+1);
tabu_list = zeros(tabu_size,n+1);

while overall_count <= max_overall_count
    iter = iter+1;
    fprintf('Iteration %d:\n',iter)
    
    % Check possible moves    
    permute_moves = randperm( max_count );
    iter_tabu = 0;
    while (d_new >= d) && (count < max_count)
        size_candidates = min(batch_size,max_count-count);
        candidate_moves = possible_moves( permute_moves(count + (1:size_candidates)), : );
        not_tabu = true(1,size_candidates);
        candidates = repmat(p, size_candidates, 1);
        count = count + size_candidates;
        for j = 1:size_candidates
            candidates(j,(candidate_moves(j,1)+1):candidate_moves(j,2)) = ...
                candidates(j,(candidate_moves(j,2)):(-1):(candidate_moves(j,1)+1));
            is_in_tabu = any(all((tabu_list == candidates(j,:))'));
            if is_in_tabu
                not_tabu(j) = false;
            end
        end
                
        if  sum(not_tabu) > 0
            candidate_moves = candidate_moves(not_tabu,:);
            candidates = candidates(not_tabu,:);
        else
            fprintf('No non-tabu\n')
            continue
        end
 
        d_candidates = d - M(sub2ind([n,n],p(candidate_moves(:,1)),p(candidate_moves(:,1)+1)));
        d_candidates = d_candidates - M(sub2ind([n,n],p(candidate_moves(:,2)),p(candidate_moves(:,2)+1)));
        d_candidates = d_candidates + M(sub2ind([n,n],p(candidate_moves(:,1)),p(candidate_moves(:,2))));
        d_candidates = d_candidates + M(sub2ind([n,n],p(candidate_moves(:,1)+1),p(candidate_moves(:,2)+1)));
        
        [d_new,new_id] = min(d_candidates);
        tabu_list = [candidates(new_id,:);tabu_list(1:(end-1),:)];
        iter_tabu = iter_tabu + 1;
        fprintf('%d\n',d_new)
        
    end
    overall_count = overall_count + count;
    
    if (count == max_count) && (count_intermediate < max_count_intermediate) ...
            && any(intermediate_list(:,1)~=0)
        p = intermediate_list(1,:);
        d = find_distance(p(1:(end-1)),M);
        tabu_list = [tabu_list((iter_tabu+1):end,:);zeros(iter_tabu,n+1)];
        fprintf('Search restarted from the previous iteration\n')
        count = 0;
        count_intermediate = count_intermediate + 1;
        d_new = d + 1;
        continue
    elseif (count == max_count) && (count_long < max_count_long)
        start = randi([1, 10]);%start + 1;
        while any(start_prev == start)
            start = randi([1, 10]);
        end
        start_prev = [start_prev, start];
        greedy
        count = 0;
        count_long = count_long + 1;
        count_intermediate = 0;
        d_new = d + 1;
        fprintf('Search restarted with a different initial route\n')
        continue
    elseif (count == max_count) && (count_intermediate == max_count_intermediate) ...
           && (count_long == max_count_long)
        fprintf('Cannot find a shorter path than %d. All permutations from the last configuration considered (%d).\n',d,count)
        break
    else
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
p = p(1:(end-1));

t = toc;

end
