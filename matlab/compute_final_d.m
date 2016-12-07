function [d] = compute_final_d(M, P)
% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Computes the round trip distance for a given path for a final path,
%     allowing for looped paths.
% Input:
%     M: Matrix, distance matrix.
%     P: Matrix, index and next index matrix.
% Output:
%     d: Float, round trip distance. 

p = P(all(P, 2), :);
l = size(p, 1);
d = 0.0;
for j=1:l
    q = p(j, 2);
    d = d + M(j, q);
end
end

