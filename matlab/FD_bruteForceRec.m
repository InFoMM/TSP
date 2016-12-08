function [ cost, path ] = FD_bruteForceRec( A, cities, k, final )
%	Recursive function for solving TSP using a brute force approach.
% At each step, the cost of completing the path by moving following any
% path originating from city k (the one I'm currently in) is computed, and
% the minimum is kept.
%
%
% INPUT:
% -A: graph matrix. Aij contains cost of connection (distance) between
%			nodes i and j. Should be lower triangular.
% -cities: indices of the cities yet to visit.
%	-k: city I'm currently in
% -final: list of cost of returning to the very first city visited
%
% OUTPUT:
% -cost: minimum total distance found by the algorithm
% -path: optimal path found by the algorithm
%
% Author:
%     Federico Danieli, December 2016.


n = size(A,1) - 1;

% Base case
% compute how much it costs to return to the city I started from
if n==0
	path = cities(k);
	cost = final( path );
	return;
end

% Recursion step
% remove the city I'm currently in from the list of cities
Apart = A;
Apart(k,:) = [];
Apart(:,k) = [];
citiesPart = cities;
citiesPart( k ) = [];

partialCost = zeros( n, 1 );
partialPath = zeros( n, n );

% compute the cost of each path that passes by any of the next cities
for i=1:n
	[ partialCost( i ), partialPath( i, : ) ] = FD_bruteForceRec( Apart, citiesPart, i, final );
end
% update cost with the cost of moving from my current cuty
addedCost = A( :, k );
addedCost(k) = [];
% only store the minimum
[ cost, newK ] = min( partialCost + addedCost );
path = [ cities( k ), partialPath( newK, : ) ];


%newK = newK + ( newK >= k );
%cost = cost + A( k, newK );


end