function [route,v,cost,time]=nearestneigh(cities, D, c_0)
% Author: Raquel Gonzalez Farina, December 2016
%
% It solves the TSP from the graph theoretical side (1)
%
% ALGORITHM: Nearest Neighbour (Greedy method) 
% 1. Start at any vertex.
% 2. Choose edge joined to the vertex with smallest weight
%    and traverse the chosen edge.
% 3. Repeat (2) until all vertices have been used.
% 4. Close circuit by going to starting vertex.
%
% Input: 
%   cities: Array with the names of the cities.
%   D:      Symmetric matrix containing distances between cities.
%   c_0:    Initial vertex/city.
% Output:
%   route:  Contains the names of the cities of the optimal route.
%   v:      Vertices of the optimal route.
%   cost:   Total cost/distance.
%   time:   Computational time.


% [cities, D]=distances;
% c_0=1;
tic;
% saving initial city and initial matrix of distances
a=c_0;
M=D;

count=0;
cost=0;
v=zeros(9,1);
while count<9
    count=count+1;
    % We set all the values in the column of the already chosen vertix
    % to zero so is not chosen again
    M(:,a)=Inf;  
    % Finding the minimum cost from the ath row
    v(count)=find(M(a,:)==min(M(a,:)));
    % Save the cost
    cost=cost+M(a,v(count));
    a=v(count);
end

% We need to add the cost from he last vertex to the first one
% and add the first vertex at the beginning and end of the array v.
cost=cost+D(v(end),c_0); 
v=[c_0;v;c_0]';

% Names of the cities in the optimal route.
route=cities(v);
time=toc;
end