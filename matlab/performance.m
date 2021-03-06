% Author: 
% 
%     Oliver Sheridan-Methven, December 2016.
% 
% Description: 
% 
%     Displays the performance of various algorithms to find a path for the
%     travelling salesman problem, usind the question data available from
%     spain_example.m.
% 
% Baseline:
% 
%     The optimal route so far seems to take distance 2999km, and one such
%     route with this performance is 
%         [1, 3, 5, 9, 7, 4, 8, 6, 2, 10]
%         [Alicante, Granada, Malaga, Sevilla, Salamanca, Madrid, 
%          Santander, Pamplona, Barcelona, Valencia]
%     and the counter-clockwise counterpart is
%         [1, 10, 2, 6, 8, 4, 7, 9, 5, 3]
%         [Alicante, Valencia, Barcelona, Pamplona, Santander, Madrid,
%          Salamanca, Sevilla, Malaga, Granada]

[c, M] = spain_example();

algo_stats(M, @increasing_loop, 'Increasing loop algorithm.')
% algo_stats(M, @forcefully_increasing_loop, 'Forcefully increasing loop algorithm.')
% algo_stats(M, @twoopt, '2-Opt algorithm.')
% algo_stats(M, @greedy_algorithm_TSP, 'Greedy algorithm.')
% algo_stats(M, @optimal_greedy_TSP, 'Greedy algorithm minimiser.')
% algo_stats(M, @stochastic_TSP, 'Basic stochastic checker.')
% algo_stats(M, @search_permutations, 'Permutation searcher.')
algo_stats(M, @tsp_ip_no_cut_set_oliver, 'Integer solution allowing loops.')
algo_stats(M, @tsp_lp_no_cut_set_oliver, 'Linear solution allowing loops and partial edges.')
algo_stats(M, @tsp_ip_cut_set_oliver, 'Integer solution not allowing loops.')


%%%%%% For more comprehensive statistics %%%%%%%
algo_stats_comp(@increasing_loop, 'Increasing loop algorithm.')
algo_stats_comp(@forcefully_increasing_loop, 'Forcefully increasing loop algorithm.')
algo_stats_comp(@tsp_ip_no_cut_set_oliver, 'Integer solution allowing loops.')
algo_stats_comp(@tsp_lp_no_cut_set_oliver, 'Linear solution allowing loops.')
algo_stats_comp(@tsp_ip_cut_set_oliver, 'Integer solution not allowing loops.')





% Shows the performance on a random matrix.
for m=[3, 6, 10, 12, 14, 16, 18, 20, 30, 40, 50]
M = make_rand_dist(m, 1);
%algo_stats(M, @increasing_loop, 'Increasing loop algorithm.')
%algo_stats(M, @forcefully_increasing_loop, 'Forcefully increasing loop algorithm.')
%algo_stats(M, @twoopt, '2-Opt algorithm.')
%algo_stats(M, @greedy_algorithm_TSP, 'Greedy algorithm.')
%algo_stats(M, @optimal_greedy_TSP, 'Greedy algorithm minimiser')
%algo_stats(M, @stochastic_TSP, 'Basic stochastic checker.')
%algo_stats(M, @search_permutations, 'Permutation searcher.')
%algo_stats(M, @tsp_ip_no_cut_set_oliver, 'Integer solution allowing loops.')
%algo_stats(M, @tsp_lp_no_cut_set_oliver, 'Linear solution allowing loops and partial edges.')
%algo_stats(M, @tsp_ip_cut_set_oliver, 'Integer solution not allowing loops.')
end

