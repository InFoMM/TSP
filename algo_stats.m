function [] = algo_stats(M, f, t)
% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Prints various performance statistics for an algorithm.
% Input:
%     M: Matrix, distance matrix. 
%     f: Function handle, algorithm to implement.
%     t: String, name of algorithm.
% Output:
%     None.
disp(sprintf('\n\nPerformance of:\n\t\t%s', t))
[p, d, t] = f(M);
disp(sprintf('Time taken:\n\t%s', t))
disp(sprintf('Total distance:\n\t%g', d))
disp(sprintf('Path taken:\n\t[%d, %d, %d, %d, %d, %d, %d, %d, %d, %d]', p))
% disp(sprintf('Route taken:\n\t[%s, %s, %s, %s, %s, %s, %s, %s, %s, %s]', c(p)))
end

