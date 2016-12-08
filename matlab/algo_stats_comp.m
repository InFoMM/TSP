function [] = algo_stats_comp(f, t)
% Author:
%     Oliver Sheridan-Methven, December 2016. 
% Description:
%     Gives a comprehensive set of statistics of how a algorithm for
%     solving the travelling salesman problem. Will continue to run until
%     all statistics are computed or until an algorithm crashes.
% Input:
%     f: Function handle, algorithm to implement.
%     t: String, name of algorithm.
% Output:
%     None.

% First we compute the average time for a function to execute over 100
% trials and the average error (as a distance fraction).
% t = 'increasing loop algorithm';
disp(sprintf('\nFor the:\n\t\t\t %s\n', t))
[c, M] = spain_example();
t = 0;
d = 0;
disp(sprintf('For the Spanish data:\n'))
for i=1:100
    [p, d1, t1] = f(M);
    t = t + t1;
    d = d + d1;
end
t_av = t/100;
d_av = d/100;
d_er = 100*(d_av - 2999)/2999;
disp(sprintf('Average execution time (s):\n\t\t%f', t_av))
disp(sprintf('Average percentage error (s):\n\t\t%f', d_er))

for m = [6, 8, 10, 12, 15, 20, 30, 40]
M = make_rand_dist(m, 0);
t = 0;
disp(sprintf('\n\n\n\nFor a random formation with %i cities\n', m))
for i=1:10
    [p, d1, t1] = f(M);
    t = t + t1;
end
t_av = t/10;
disp(sprintf('Average execution time (s):\n\t\t%e', t_av))
end

end

