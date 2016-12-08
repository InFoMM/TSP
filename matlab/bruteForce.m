function [ path, cost, time ] = bruteForce( A, cityNames )
%	Solves TSP using a brute force algorithm. 
%	The algorithm works recursively. Starting from node 1, it excludes it
%	from the list of covered nodes and recursively invokes a function on all
%	other nodes. The function returns the cost of the path built up so far,
%	and stores the one with minimum cost.
% Caveat: it is damn slow, since it explores all possible n! paths.
% Moreover, it might run quickly out of memory, as it keeps on passing the
% cost matrix.
%
%
% INPUT:
% -A: graph matrix. Aij contains cost of connection (distance) between
%			nodes i and j. Should be lower triangular.
% -cityNames: Names of the cities corresponding to node i.
%
% OUTPUT:
% -cost: minimum total distance found by the algorithm
% -path: optimal path found by the algorithm
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
elseif size(A,1)~=size(A,2)
	error('LPTSP:InvalidParameter','Input a square distance matrix')	
end

if nargin < 2 || isempty( cityNames )
	if size(A,1) == 10
		cityNames = {'Alicante','Barcelona', 'Granada', 'Madrid', 'Malaga',...
								 'Pamplona', 'Salamanca', 'Santander', 'Sevilla', 'Valencia'};
	else
		cityNames = cell(1,size(A,1));
		for i=1:size(A,1)
			cityNames{i} = int2str(i);
		end
	end
end

A = tril(A,-1);
A = A + A';

tic
cities = 1:size( A, 1 );


[ cost, path ] = bruteForceRec( A, cities, 1, A(:,1) );
path = [ path, 1 ];

time = toc;

disp( cityNames( path ) );

end

