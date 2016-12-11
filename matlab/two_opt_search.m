function [ p, d, t ] = two_opt_search( M )
%tabu_search Summary of this function goes here
%   Detailed explanation goes here

tic;
n = size(M,1);
for j = 1:1
    start = randi([1,10]);
    greedy
end
d_new = sum(sum(M));

possible_moves = nchoosek(1:n,2);
possible_moves = possible_moves( (possible_moves(:,1)==1) + ...
    (possible_moves(:,2)==10) ~= 2, : );
possible_moves = possible_moves( diff(possible_moves') > 1, : );

iter = 0;
count = 0;
overall_count = 0;

max_count = size(possible_moves,1);
batch_size = floor(max_count/5);
max_overall_count = 300*max_count;

while overall_count <= max_overall_count
    iter = iter+1;
    fprintf('Iteration %d:\n',iter)
    
    % Check possible moves    
    permute_moves = randperm( max_count );
    while (d_new >= d) && (count < max_count)
        size_candidates = min(batch_size,max_count-count);
        candidate_moves = possible_moves( permute_moves(count + (1:size_candidates)), : );
        count = count + size_candidates;
 
        d_candidates = d - M(sub2ind([n,n],p(candidate_moves(:,1)),p(candidate_moves(:,1)+1)));
        d_candidates = d_candidates - M(sub2ind([n,n],p(candidate_moves(:,2)),p(candidate_moves(:,2)+1)));
        d_candidates = d_candidates + M(sub2ind([n,n],p(candidate_moves(:,1)),p(candidate_moves(:,2))));
        d_candidates = d_candidates + M(sub2ind([n,n],p(candidate_moves(:,1)+1),p(candidate_moves(:,2)+1)));
        
        [d_new,new_id] = min(d_candidates);
        fprintf('%d\n',d_new)
        
    end
    overall_count = overall_count + count;
    
    if count == max_count
        fprintf('Cannot find a shorter path than %d. All permutations from the last configuration considered (%d).\n',d,count)
        break
    else
        fprintf('***Improvement found***\n')
        % Perform swap of edges
        d = d_new; d_new = d + 1;
        a = candidate_moves(new_id,1); b = candidate_moves(new_id,2);
        p((a+1):b) = p(b:(-1):(a+1));
        count = 0;
    end
    
end
fprintf('Number of iterations is %d (%d).\n',iter,overall_count)
p = p(1:(end-1));

t = toc;

end
