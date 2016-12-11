function [ d ] = find_distance( p, M )
% Author: Ana Osojnik
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

n = size(M,2);
idx = [p;p([2:end,1])];

idx_lin = (idx(1,:)-1)*n+idx(2,:);
d = sum(M(idx_lin));


end

