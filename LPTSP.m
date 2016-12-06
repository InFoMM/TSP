function [ ] = LPTSP( C, cityNames )
%	Solves TSP using an integer linear programming approach
%
% INPUT:
% -A: graph matrix. Aij contains cost of connection (distance) between
% nodes i and j. Should be lower triangular.
% -cityNames: Names of the cities corresponding to node i.
%
% OUTPUT:
% -minCost: minimum total distance found by the algorithm
% -minPath: optimal path found by the algorithm
%
% Author:
%     Federico Danieli, December 2016.


if nargin < 1 || isempty( C )
	C = [	0		0			0		0		0		0		0		0		0		0;...
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

% C = [	0		0			0		0;...
% 			515	0			0		0;...
% 			353	868		0		0;...
% 			422	621		434	0 ...
% 		];	cityNames = cityNames(1:size(C,1));
% C = [	0		0			0		0		0		0		0		0;...
% 			515	0			0		0		0		0		0		0;...
% 			353	868		0		0		0		0		0		0;...
% 			422	621		434	0		0		0		0		0;...
% 			482	997		129	544	0		0		0		0;...
% 			673	437		841	407	951	0		0		0;...
% 			634	778		631	212	756	440	0		0;...
% 			815	693		827	393	937	267	363	0 ...
% 		];	cityNames = cityNames(1:size(C,1));
%% Cost functional
f = C( C~= 0 );	%remove the zero entries, consider them columnwise

n = size(C,1);	% number of cities
m = size(f,1);	% size of x




%% Constraints

% Equalities
% - Sum of edges leaving from a node is 1
% - Sum of edges arriving at a node is 1
% --> The graph is undirected, so we can combine the two imposing that the
%			sum of edges attached to a node must be 2
%
% The tricky part here is that there is a weird indexing of the variables x


Aeq = zeros( n, m );	% we will have an equation for each city
for j=1:n
	cont = n-1:-1:0;
	% fill column in graph matrix
	for i = 1:cont( j )		
		Aeq( j, sum(cont(1:j-1)) + i ) = 1;
	end
	% fill row in graph matrix
	start = sum(cont(1:j-2))+1;
	for i = j-1:-1:1
		Aeq( j, start ) = 1;
		start = start - cont(i);
	end
end

% rhs equals 2
beq = 2*ones( n, 1 );



% Inequalities
% - x in [0,1]
lb = zeros( m, 1 );
ub = ones( m, 1 );

%% Solve problem
x = intlinprog(f,1:m,[],[],Aeq,beq,lb,ub);
cycles = printCycle( x(1:m), cityNames(1:n) );






%% 
% Now, If we want to include the additional constraint:
% - Only one cycle
% This translates into (see Wikipedia) ui-uj+nxij <= n-1

% We need to introduce n more variables u
% First we re-arrange the previous matrices:

% expand cost functional
f = [ f; zeros( n, 1 ) ];
m = size( f, 1 );

% u can be in [-Inf, +Inf]
lb = [ lb; -Inf*ones(n,1)];
ub = [ ub;  Inf*ones(n,1)];

% u is not involved in the equality contraints
Aeq = [ Aeq, zeros( n ) ];

% Now the interesting bit
A = n * eye( m-n );
temp = zeros( m-n, n );
for i=1:n-1
	cont = [0,n-1:-1:1];
	temp(1+sum(cont(1:i)):sum(cont(1:i+1)),i) = ones( sum(cont(1:i+1)) - sum(cont(1:i)), 1 );
	temp(1+sum(cont(1:i)):sum(cont(1:i+1)),i+1:end) = -eye( sum(cont(1:i+1)) - sum(cont(1:i)) );
end
%A = [ A, -temp ];
A = [ A, temp;...
			A,-temp ];
b = (n-1) * ones( 2*(m-n), 1 );




%% Solve problem
x = intlinprog(f,1:m,A,b,Aeq,beq,lb,ub);
printCycle( x(1:m), cityNames(1:n) );



					 



end