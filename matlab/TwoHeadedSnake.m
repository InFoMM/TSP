function [ p, d, t ] = TwoHeadedSnake(M)
%Author
%       Jonathan Peters
%Description:
%       Given set of cities, and the distances between each pair of
%       citites, this algorithm attempts to find a hamiltonian cycle of
%       minimal length. 
%       The approach taken is a two headed greedy algorithm. A city is
%       randomly selected as the starting point. Then the two nearest
%       cities are selected to be adjacent to the initial city on the path.
%       From this point, we expend our path in both directions, always by
%       choosing the nearest (unexplored) city. Finally, for the final
%       step, we force the two ends of the loop to join.
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
    
    %start the clock!
    tic
        
    n = size(M, 1);
    
    %initialise the permutation vector;
    p = zeros(1, n);
        
    %initialise the 'unexplored vector'. By default, only the starting city
    %is explored.
    unexplored = ones(1,n);
    
    %randomly determine the starting point;
    k = randi([1 n], 1, 1);
    
    %update the explored matrix, as the starting city has been explored.
    unexplored(k)=Inf;
    
    %update the permutating matrix to indicate the starting point:
    p(1) = k;
    
    
    %First iteration
    %   the first iteration is outside the loop as it functions
    %   differently. Instead of picking the nearest city to each end of the
    %   'snake', we instead pick the two closest cities to the starting
    %   point.
    
    [~, city_ind] = min(unexplored.*M(k,:), [], 2);
    unexplored(city_ind) = Inf;
    p(2) = city_ind;
        
    [~, city_ind] = min(unexplored.*M(k, :), [], 2);
    unexplored(city_ind) = Inf;
    p(end) = city_ind;
        
    %begin loop
    for i=1:floor(n/2)-1
        %find the nearest city to the front of the snake
        [~, city_ind] = min(unexplored.*M(p(i+1),:), [], 2);
        unexplored(city_ind) = Inf;
        p(i+2) = city_ind;
                
        if(min(unexplored)==1)
            %find the nearest city to the back end of the snake
            [~, city_ind] = min(unexplored.*M(p(end+1-i),:), [], 2);
            unexplored(city_ind) = Inf;
            p(end-i) = city_ind;
        end
    end
    
    %finally, compute the distance travelled
    d = compute_d_from_route(M, p);
    
    t = toc;
end

