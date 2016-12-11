function [ idx, cycles, no_cycles, cycle_lengths ] = find_cycles( sol, cities )
%find_cycles function finds cycles given the output from intlinprog

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

