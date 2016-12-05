function [p] = get_permutation(P)
% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Computes the route starting at index 1.
% Input:
%     P: Matrix, route's starting point and end point.
% Output:
%     p: List, route of path starting at 1, ignore the return journey to 1.
%         Notice this is a permutation.
% Example:
% 
%     P = 
%          1     3
%          2     1
%          3     2
% 
%     gives p = [1, 3, 2]
p = zeros(1, size(P, 1));
p(1) = 1;
for j=1:length(p)-1
    q = P(p(j), 2);
    p(j+1) = q;
end
end