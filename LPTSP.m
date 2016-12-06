function [ ] = LPTSP( A, cityNames )
%	Solves TSP using an integer linear programming approach
%
% INPUT:
% -A: graph matrix. Aij contains cost of connection (distance) between
% nodes i and j. Should be lower triangular.
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

% A = [	0		0			0		0;...
% 			515	0			0		0;...
% 			353	868		0		0;...
% 			422	621		434	0 ...
% 		];

%% Cost functional
f = A( A~= 0 );	%remove the zero entries, consider them columnwise

n = size(A,1);	% number of cities
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


A=[];b=[];







% 
% 
% % there must be only one closed cycle
% Aeq = [ Aeq, zeros( n, n ) ];
% 
% lb = [ lb; -Inf*ones(n,1)];
% ub = [ ub;  Inf*ones(n,1)];
% 
% A = n * eye( size(f,1) );
% temp = zeros( size(f,1), n );
% for i=1:n-1
% 	cont = [0,n-1:-1:1];
% 	temp(1+sum(cont(1:i)):sum(cont(1:i+1)),i) = ones( sum(cont(1:i+1)) - sum(cont(1:i)), 1 );
% 	temp(1+sum(cont(1:i)):sum(cont(1:i+1)),i+1:end) = -eye( sum(cont(1:i+1)) - sum(cont(1:i)) );
% 	
% 	%temp((sum(cont(1:i))+1):(sum(cont((1:(i+1))))+1),i) = ones( 1+sum(cont((1:(i+1)))) - sum(cont(1:i)), 1 );
% 	%temp((sum(cont(1:i))+1):(sum(cont((1:(i+1))))+1),(i+(1:(n-i+1)))) = eye(n-i+1);
% end
% %A = [ A, -temp ];
% A = [ A, temp;...
% 			A,-temp ];
% b = (n-1) * ones( 2*size(f,1), 1 );



% x = intlinprog(f,1:size(f,1),A,b,Aeq,beq,lb,ub);
x = intlinprog(f,1:m,[],[],Aeq,beq,lb,ub);

cityNames = {'Alicante','Barcelona', 'Granada', 'Madrid', 'Malaga',...
						 'Pamplona', 'Salamanca', 'Santander', 'Sevilla', 'Valencia'};


					 

%% Fancy printing of the cycle
% Here follows the ugliest code ever written. And this is all to have a
% nice output of the solution

% First, let's transform the ugly vector of edges in a proper graph matrix:
idx = find( x(1:size(f,1)) > 0 ); % find nonzero elements identifying edges
uga = zeros(n,n);	%initialize graph matrix
for k=1:length(idx)
	cont = [0,n-1:-1:1];
	part = cumsum(cont);
	for j=1:n-1
		if part(j) < idx(k) && idx(k)<=part(j+1)
			i = idx(k)-part(j)+j;	% map the edge index into a nice (i,j) index
			uga(i,j)=1;
		end
	end
end

% Now that the graph matrix is built, we can identify the path
i = 1;
path = 1;	% we start from Alicante
visitedNodes = 1;
% to cover all cities
while i <= n
	% starting from the last added node...
	k = path( end );
	% look connections to next node on the column/row of the graph matrix
	nextTemp = [ find( uga(:,k)~=0 ), find( uga(k,:)~=0 )'];
	% remove the nodes you've visited already
	for j = 1:length( path )
		nextTemp = nextTemp( nextTemp ~= path( j ) );
	end
	% if you're left with no nodes, then you've found a closed cycle
	if isempty( nextTemp )
		output = 'Found a cycle: ';
		for j = 1:length( path )
			output = [ output, char(cityNames( path(j) ) ), ' -> ' ];
		end
		output = [ output, char( cityNames( path(1) ) ) ];
		disp( output )
		% eventually, you'll need to restart the path from another node
		for ii = 2:n
			% pick the smallest that has not been visited yet
			if sum( visitedNodes ~= ii ) == length( visitedNodes )
				path = ii;
				break;
			end
		end
	else
		path = [ path, nextTemp(1) ];
		visitedNodes = [ visitedNodes, nextTemp(1) ];
	end
	
	i = i+1;
	
end	

end

