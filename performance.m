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
%     route with this performance is [1, 3, 5, 9, 7, 4, 8, 6, 2, 10].

[c, M] = spain_example();
disp(sprintf('\n\nPerformance of:\n\t\tincreasing loop algorithm'))
[p, d, t] = increasing_loop(M);
disp(sprintf('Time taken:\n\t%s', t))
disp(sprintf('Total distance:\n\t%g', d))
disp(sprintf('Path taken:\n\t[%d, %d, %d, %d, %d, %d, %d, %d, %d, %d]', p))


