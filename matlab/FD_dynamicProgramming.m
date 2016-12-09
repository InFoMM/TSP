function [ path, cost, time ] = FD_dynamicProgramming( A, cityNames )
%	Solves TSP using a brute force algorithm. But since power is nothing
%	without control, the brute force is applied quite cleverly. The algorithm
%	follows a dynamic programming approach, and computes the costs associated
%	to cover a subset of cities starting from any city in there, and
%	terminating in 1. Starting from subsets of size 2 (in the form Si={1,i}),
%	for which the cost is trivially D(Si,i)=A(1,i), it increases the subset
%	size at each iteration, and it computes the corresponding cost using the
%	recursive formula:
% D(S,k) = min_{ii=\in S, ii\neq 1}( d_{ii,k} + C(S\{k}, ii ) )
%
% For additional info, check the Held-Karp algorithm:
%	https://en.wikipedia.org/wiki/Held%E2%80%93Karp_algorithm
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
% -time: total time to complete the algorithm
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

% % larger matrix for testing
% A = [	0		0			0		0		0		0		0		0		0		0		0		0		0		0		0;...
% 			515	0			0		0		0		0		0		0		0		0		0		0		0		0		0;...
% 			353	868		0		0		0		0		0		0		0		0		0		0		0		0		0;...
% 			422	621		434	0		0		0		0		0		0		0		0		0		0		0		0;...
% 			482	997		129	544	0		0		0		0		0		0		0		0		0		0		0;...
% 			673	437		841	407	951	0		0		0		0		0		0		0		0		0		0;...
% 			634	778		631	212	756	440	0		0		0		0		0		0		0		0		0;...
% 			815	693		827	393	937	267	363	0		0		0		0		0		0		0		0;...
% 			609	1046	256	538	219	945	474	837	0		0		0		0		0		0		0;...		
% 			166	349		519	352	648	501	564	673	697	0		0		0		0		0		0;...		
% 			700	92		347	116	170	944	102 666	842	357	0		0		0		0		0;...		
% 			829	1020	223	313	873	619	828	177	849	172 655	0		0		0		0;...		
% 			617	1520	123	525	277	976	674	433	848	617 423	715	0		0		0;...		
% 			829	1012	223	313	873	619	828	177	849	172 655	171 451	0		0;...		
% 			172	1610	324	167	901	562	412	972	728	647 102	241 365	578 0 ...		
% 		];
% cityNames = {'Alicante','Barcelona', 'Granada', 'Madrid', 'Malaga',...
% 						 'Pamplona', 'Salamanca', 'Santander', 'Sevilla', 'Valencia',...
% 						 'Vattelappesca', 'Trinciapolli', 'Melville', 'Fedeland', 'Clintopia'};

A = tril(A,-1);
A = A + A';

tic
n = size(A,1);

%% Initialize some relevant variables:
% (as of now they're not really meaningful: description in the for loop)

% subsets of size 1 not containing 1
S = ( 2:n )';
% distance to cover i,1
D = A(2:n,1);
% optimal subpath
P = S;


%% Main Loop: compute costs of covering subsets of larger size
% For each possible size of subsets
for i=3:n
	
	% update old variables
	prevS = S;
	prevD = D;
	prevP = P;
	
	% Initialize new relevant variables:
	
	% Each row is a list of indeces of cities. They correspond to one of the 
	% subsets of size i not containing 1
	S = nchoosek( 2:n, i-1 );
	
	% Each element (j,k) is the minimum distance to cover each city in S(j,:)
	% starting from city S(j,k). This will be filled later on, initialize it
	% in the meantime
	D = zeros( size( S ) );
	
	% Each hyper-row P(j,k,:) gives the (ordered) optimal path to cover the
	% subset S(j,:) staring from city S(j,k). This will be filled later on,
	% initialize it in the meantime.
	P = zeros( [ size( S ), i-1 ] );
	
	
	
	% For each of these subsets
	for j = 1:size( S, 1 )
		% For each city in the subset
		for k = 1:size( S, 2 )
			% Take the reduced subset without the city in position k
			SminusK = setxor( S(j,:), S(j,k) );	% SminusK is ordered!
			
			% Now, for each city ii in the reduced subset, we should find the min
			% distance we need to travel in order to cover that reduced subset
			% starting from ii. But since everything is nicely ordered, that is
			% just given by prevD( idx, : ), where idx is the index at wich the
			% reduced subset appears in prevS: prevS(idx, :) == SminusK. This is
			% given by this very handy function down here
			idx = findSubset( SminusK, prevS );
			
			% To update the cost to cover subset S(j,:) starting from a city k in
			% S(j,:), we follow the recursive relation:
			% D(S(j),k) = min_{ii=\in S(j)}( d_{ii,k} + D(S\{k}, ii ) )
			[ D(j,k), minCityIdx ] = min( A(S(j,k),prevS(idx,:)) + prevD(idx,:) );
			
			% Finally, keep track of the optimal path:
			% the starting city is the one in position k of the subset S(j,:)
			P(j,k,i-1) = S(j,k);
			% the rest follows from the previous iteration
			P(j,k,1:i-2) = prevP( idx, minCityIdx, : );
					
		end
	end
	
	%At the very last iteration, add the cost to move to 1 again
	if i==n
		% same relation as before, but now we should be left with only one set
		% (the actual complete set of cities), so no need for a bunch of for
		% loops
		[ D, minCityIdx ] = min( A(1,S) + D );
		
		% Reorganize P to get rid of the annoying extra dimension
		P = reshape( P( 1, minCityIdx, : ), [1, size(P,3)] );
		P = [ 1, P, 1 ];
	end
end

%  and that's it, mate: you've done it!
path = P;
cost = D;
time = toc;

disp( cityNames( path ) );

end




function [ idx ] = findSubset( SminusK, prevS )
%	Auxiliary function: it finds in which row of prevS the set SminusK is
%	stored. This is done pretty easily, since the sets are nicely ordered: we
%	just check the first column of prevS, extract those rows that have the
%	same element in SminusK(1), check the second column in these rows,
%	extract those that have the same element in SminusK(2), and so on and so
%	forth...
%
% Author:
%     Federico Danieli, December 2016.

% initialize the rows indices in which to look to the whole set of rows
lookIn = ( 1:size(prevS,1) );
	
for i = 1:size(SminusK,2)
	% subsequently remove rows that do not share the correct elements
	lookIn = lookIn( prevS( lookIn, i ) == SminusK(i) );
end

% hopefully at the end of the day only one index is left
idx = lookIn;

end








