%% Travelling Salesman Problem (GRAPHS)
%
% Author: Raquel Gonzalez Farina, December 2016
%
% It solves the TSP from the graph theoretical side (1)
%
% ALGORITHM: Stochastic
%
% 1. Generate a random path (permutation of n elements)
% 2. Compute the cost and if it is less than the previous cost calculated
%    save it and save the route.
% 3. Repeat for a chosen number of iterations
%
% Input: 
%   iter:   Number of iterations or random permutations to generate.
%   D:      Symmetric matrix containing distances between cities.
%
% Output:
%   opt_v:      Vertices of the optimal route.
%   opt_cost:  Total cost/distance of the optimal path found.
%   time:      Computational time.
%
% Use [~, D]=distances to generate the matrix for distances between cities
% in Spain
%
function [opt_v, opt_cost, time]=RG_stochastic(iter, D)

tic

n=size(D,1);
cost0=Inf;

for i=1:iter
   v=randperm(n); 
   cost=0;
   for j=1:n-1
       cost=cost+D(v(j),v(j+1));
   end
   cost=cost+D(v(end),v(1));
   if cost < cost0
       opt_cost=cost;
       opt_v=v;
   end
   cost0=cost;
   
   time=toc;
end
