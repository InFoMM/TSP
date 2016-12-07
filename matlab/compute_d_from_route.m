function [ d ] = compute_d_from_route( M, route )
% Author:
%     Jonathan Peters
% Description:
%     Computes the round trip distance for a given path.
% Input:
%     M: Matrix, distance matrix.
%     route: vector, sequence of indicies corresponding to sequence of
%     cities
% Output:
%     d: Float, round trip distance. 
    
    d = 0;
    m = size(M, 2);
    
    %loop through the route, and calulate the distance from each point on
    %the route to the next.
    for i=1:m-1
       d = d+ M(route(i), route(i+1)); 
    end
    d = d+M(route(1), route(end));
end

