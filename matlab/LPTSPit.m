function [ cost ] = LPTSPit( C, cityNames, maxIt )
%	Solves TSP using an integer linear programming approach that ignores
%	cut-set constraints. However, multiple sub-cycle are borken in an
%	iterative faction. At each iteration, a constraint is imposed to connect
%	the (eventually more than) two subcycles found.
%
%
% INPUT:
% -A: graph matrix. Aij contains cost of connection (distance) between
%			nodes i and j. Should be lower triangular.
% -cityNames: cell containing names of the cities corresponding to node i.
% -maxIt: maximum number of times the algorithm should try to break
%					subcycles.
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

if nargin < 3 || isempty( maxIt )
	maxIt = 10;
end

% other small matrices C used for testing...
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
opts = optimoptions('intlinprog','Display','off'); % to suppress annoying overly verbose output
[ x, cost ] = intlinprog(f,1:m,[],[],Aeq,beq,lb,ub, opts);
cycles = printCycle( x(1:m), cityNames(1:n) );




%% Now, to break multiple cycles
% The solution given above completely ignores the possibility of subcycles
% being created. One way to get rid of multiple cycles, is to run the 
% solution iteratively, each time adding a constraint that breaks the
% subcycles.

% the constraint will be in the form sum xij >= 1 for those ij such that ij
% is an edge connecting the first two cycles found
it = 1;
A = [];
while size( cycles, 2 ) > 1 && it <= maxIt
	disp(strcat('Multiple cycles detected. Trying to break them (it=',num2str(it),')'));
	it = it + 1;
	
	newConstraint = zeros( 1, m );
	
	% find edges that connect first and second cycle
	cycleFrom = cycles{1};
	cycleTo		= cycles{2};
	for i=1:length( cycleFrom )
		from = cycleFrom( i );
		for j=1:length( cycleTo )
			to = cycleTo( j );
			% consider only one direction (the graph is undirected anyway) and
			% order it so to take only the subdiagonal part of the graph matrix
			ii = 0; jj = 0;
			if from > to
				ii = from;
				jj = to;
			elseif from < to
				ii = to;
				jj = from;
			else
				error('LPTSPit:nonDistinctCycles','Something went wrong: two distinct cycles share the same city. Abort')
			end
			% convert idx from (ii,jj) to weird indexing used for x
			cont = n-1:-1:1;
			idx = ii-jj + sum(cont(1:jj-1));
			% turn on coefficient for that edge
			newConstraint( idx ) = -1;
			
		end
	end
	
	A = [ A; newConstraint ];
	b = - ones( size(A,1), 1 );
	
	[ x, cost ] = intlinprog(f,1:m,A,b,Aeq,beq,lb,ub,opts);
	cycles = printCycle( x(1:m), cityNames(1:n) );

end



if size( cycles, 2 ) > 1
	disp( 'There are still multiple cycles, but I give up, mate' );
else
	disp( 'Single Hamiltonian cycle found.')
end







					 



end