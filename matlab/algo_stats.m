function [] = algo_stats(M, f, t, varargin)
% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Prints various performance statistics for an algorithm.
% Input:
%         M: Matrix, distance matrix. 
%         f: Function handle, algorithm to implement.
%         t: String, name of algorithm.
%  varargin: Optional argument, indicating whether the problem being
%               solved is the 'Spanish problem'
% Output:
%     None.
nVarargs = length(varargin);
disp(sprintf('\n\nPerformance of:\n\t\tPurmuations searching algorithm.'))
[p, d, t] = f(M);
disp(sprintf('Time taken:\n\t%s', t))
disp(sprintf('Total distance:\n\t%g', d))
disp(sprintf('Path taken:\n\t[%d, %d, %d, %d, %d, %d, %d, %d, %d, %d]', p))
if nVarargs>0
    [c, M] = spain_example();
disp(sprintf('Route taken:\n\t[%s, %s, %s, %s, %s, %s, %s, %s, %s, %s]', c(p)))
end
end

