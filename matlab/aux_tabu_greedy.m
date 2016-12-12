% Auxiliary code for tabu search, that finds an initial greedy path

p = [start,zeros(1,n-1)];
cities_visited = zeros(1,n); cities_visited(p(1)) = 1;
for j = 1:(n-1)
    [~,idx_min_tmp] = min( M( ~cities_visited, p(j) ) );
    idx_min = 1:n; idx_min = idx_min(~cities_visited);
    idx_min = idx_min(idx_min_tmp);
    p(j+1) = idx_min;
    cities_visited(idx_min) = 1;
end
d = find_distance( p, M );
fprintf('%d\n',d)
p = [p,p(1)];