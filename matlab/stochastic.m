function [ minPath, minCost, time ] = stochastic( A, cityNames, maxIt, seed )
%	A stochastic heuristic algorithm for solving the TSP
%	At each iteration, a random permutation of the nodes is taken, and the
%	cost associated to the corresponding path is computed. If it improves the
%	current path, then it is stored.
% Caveat: the permutations taken can be repeated, so it is NOT guaranteed
% to converge to optimum in n! iterations.
%
% INPUT:
% -A: graph matrix. Aij contains cost of connection (distance) between
% nodes i and j. Should be lower triangular.
% -cityNames: Names of the cities corresponding to node i.
% -maxIt: maximum number of iterations of the algorithm.
% -seed: seed for random number generator
%
% OUTPUT:
% -minCost: minimum total distance found by the algorithm
% -minPath: optimal path found by the algorithm
%
% Author:
%     Federico Danieli, December 2016.


if nargin < 1 || isempty( A )
	A = [	0		0			0		0		0		0		0		0		0		0;...
				515	0			0		0		0		0		0		0		0		0;...
				353	868		0		0		0		0		0		0		0		0;...
				422	621		434	0		0		0		0		0		0		0;...
				482	997		129	544	0		0		0		0		0		0;...
				673	437		841	407	951	0		0		0		0		0;...
				634	778		631	212	756	440	0		0		0		0;...
				815	693		827	393	937	267	363	0		0		0;...
				609	1046	256	538	219	945	474	837	0		0;...		
				166	349		519	352	648	501	564	673	697	0 ...		
			];
end

if nargin < 2 || isempty( cityNames )
	cityNames = {'Alicante','Barcelona', 'Granada', 'Madrid', 'Malaga',...
							 'Pamplona', 'Salamanca', 'Santander', 'Sevilla', 'Valencia'};
end

if nargin < 3 || isempty( maxIt ) || maxIt<1
	maxIt = 100000;
end

if nargin < 4 || isempty( seed )
	seed = 1;
end

%initialize random number generator seed
rng(seed);

%adjust matrix
A = A+A';
n = size(A,1);

tic

%initialize path and minimum associated cost to something meaningful
minPath = 1;
minCost = sum(sum(A));

%for each iteration
for k = 1:maxIt
	%permute the nodes (start and finish at node 1)
	path = [ 1, randperm(n-1)+1, 1 ];
	
	%this does the same as below, just waaay more efficiently
	cost = sum( A( path(1:n) + n*( path(2:n+1)-1 ) ) );
% 	for i = 1:n
% 		cost = cost + A( path(i), path(i+1) );
% 	end
	
	%update cost and path if there's an improvement
	if cost < minCost
		%disp(strcat('Update at it=', int2str(k)));
		minPath = path;
		minCost = cost;
	end
end

time = toc;

%uncomment if you want to print a fancy series of names
%disp( strcat('Total distance =', num2str(minCost), ' best path found:'));
%disp(cityNames(minPath));
end