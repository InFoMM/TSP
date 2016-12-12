function [ idx, cycles, no_cycles, cycle_lengths ] = find_cycles( sol, cities )
% Author: Ana Osojnik
% Date: December 2016
% Description:
%   Finds cycles and paths given a sequence of edges sol.

% Input:
%     sol: Array, row vector of permutation of the order of cities to visit
%          or an n x n matrix of edges.
%     cities: String array, names of cities.
% Output:
%     idx: Matrix, 2 x n matrix containing i and j indices of all edges in
%          the path, ordered
%     cycles: Array, row vector of cycles and paths, ordered to start at city 1
%             and the rest as in sol
%     no_cycles: Float, number of cycles found
%     cycle_lengths: 
%     d: Float, total distance travelled in a round trip.
%     t: Float, execution time for algorithm.

if nargin < 2
    cities = string({'Alicante','Barcelona','Granada','Madrid','Malaga',...
        'Pamplona','Salamanca','Santander','Sevilla','Valencia'});
end

n = size(sol,2);
if size(sol,1) > 1
    idx_lin = 1:(n^2);
    idx_lin = idx_lin( abs(sol(:)-1) < 1e-8 );
    [idx_i, idx_j] = ind2sub(size(sol),idx_lin);
    idx = [idx_i;idx_j];
else
    idx = [sol;sol([2:end,1])];
end

start = find(idx(1,:) == 1);
if start > 1
    idx = idx(:,[start:end,1:(start-1)]);
end

N = size(idx,2);
k = 0;
no_cycles = 0;
cycle_lengths = [];
cycles = [];

for j = 1:N
    k = k + 1;
    next_vertex = find(idx(1,:)==idx(2,j));
    
    if size(next_vertex,2) == 0
        no_cycles = no_cycles + 1;
        
        idx_cycle_edges = idx(:,(j-k+1):j);
        curr_cycle = unique(idx_cycle_edges(:),'stable')';
        curr_cycle_cities = cities(curr_cycle);
        curr_cycle_length = size(curr_cycle_cities,2);
        
        cycles = [cycles, curr_cycle];
        cycle_lengths = [cycle_lengths,curr_cycle_length];
        
        fprintf('PATH: ')
        for m = 1:curr_cycle_length
            fprintf('%s',curr_cycle_cities(m))
            if m < curr_cycle_length
                fprintf(' - ')
            else
                fprintf('\n')
            end
        end
        
        k = 0;
        continue
    elseif next_vertex < j+1
        no_cycles = no_cycles + 1;
        
        idx_cycle_edges = idx(:,(j-k+1):j);
        curr_cycle = unique(idx_cycle_edges(:),'stable')';
        curr_cycle_cities = cities(curr_cycle);
        curr_cycle_length = size(curr_cycle_cities,2);
        
        cycles = [cycles, curr_cycle];
        cycle_lengths = [cycle_lengths,curr_cycle_length];
        
        fprintf('CYCLE: ')
        for m = 1:curr_cycle_length
            fprintf('%s',curr_cycle_cities(m))
            if m < curr_cycle_length
                fprintf(' -- ')
            else
                fprintf('\n')
            end
        end
        
        k = 0;
        continue
    else
        idx(:,[j+1,next_vertex]) = idx(:,[next_vertex,j+1]);
    end
end

end

