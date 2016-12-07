function [p] = compute_paths_with_loops(P)
% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Computes the path vector showing terminating stops to allow for
%     looped paths. 
% Input:
%     P: Matrix, 2*N edge matrix.
% Output:
%     p: Array, indices visited.
% Example:
%         P =
%              1    10
%              2     1
%              3     5
%              4     7
%              5     9
%              6     8
%              7     4
%              8     6
%              9     3
%             10     2
%     gives 
%         p = 
%             [1, 10, 2, 1, 3, 5, 9, 3, 4, 7, 4, 6, 8, 6];
V = P(:, 1)';
p = zeros(floor(2*V(end) + 2), 1)';
i = 1;
j = 1;
in_loop = 0;
while ~isempty(V)
    if ~in_loop
        p(i) = min(V);
%         p(i) = P(min(V), 2);
        i = i+1;
        in_loop = 1;
    else
        pm = p(i-1);
        p(i) = P(pm, 2);
        if p(i) == min(V)
            in_loop = 0;
            for z=p(p>0)
                V(V==z) = [];
            end
        end
        i = i+1;
    end
end
p = p(p>0);
end

