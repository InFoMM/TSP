% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     A simple tests that the basics of the code suite works. Simple run
%     the folling commands. 


[c, M] = spain_example();

disp(sprintf('\n\nPerformance of:\n\t\tPurmuation searching algorithm.'))
[p, d, t] = search_permutations(M);
disp(sprintf('Time taken:\n\t%s', t))
disp(sprintf('Total distance:\n\t%g', d))
disp(sprintf('Paths taken:\n\t[%d, %d, %d, %d, %d, %d, %d, %d, %d, %d]\n', p))
disp(sprintf('Routes taken:\n\t[%s, %s, %s, %s, %s, %s, %s, %s, %s, %s]\n', c(p)))
