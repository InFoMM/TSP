function [ cycles ] = printCycle( x, cityNames )
% Fancy printing of the cycles in the solution of the TSP
%
% INPUT:
% -x: solution of the TSP as provided by LPTSP.m. Basically a (weirdly 
%			indexed) vector of edges.
% -cityNames: a cell containing the names of the cities. In order.
%
% OUTPUT:
% -It prints the cities in each cycle, in the order they're visited
% -cycles: cell containing all the cycles found in the algorithm. Each
%					 element of the cell is a vector of indices of the cities in the
%					 cycle.
%
% Author:
%     Federico Danieli, December 2016.


% Here follows the ugliest code ever written. It's convoluted and it's
% messed up, so, really, don't look at it. Just trust it.
n = size( cityNames, 2 );
m = size( x, 1 );
cycles = {};

% First, let's transform the ugly vector of edges in a proper graph matrix:
idx = find( x(1:m) > 0 ); % find nonzero elements identifying edges
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
		%store the newly found cycle
		cycles{size(cycles,1)+1} = [ path, path(1) ];
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