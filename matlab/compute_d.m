function [d] = compute_d(M, P)
% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Computes the round trip distance for a given path.
% Warning:
%     Assumes there is only one looped path.
% Input:
%     M: Matrix, distance matrix.
%     P: Matrix, index and next index matrix.
% Output:
%     d: Float, round trip distance. 

p = P(all(P, 2), :);
l = size(p, 1);
p = p(1, 1);
d = 0.0;
for j=1:l
    q = P(p, 2);
    d = d + M(p, q);
    p = q;
end
end

