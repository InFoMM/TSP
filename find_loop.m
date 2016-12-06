function [l] = find_loop(p)
% Author:
%     Oliver Sheridan-Methven, December 2016. 
% Description:
%     Finds a the first loop in a sequence of cities.
% Input:
%     p: Array, city indices visitied, including looped entries.
% Output:
%     l: Array, sub-loop.
% Example:
%         p =
%          1    10     2     1     3     5     9     3
%     gives
%         l = 
%          1    10     2     1    
p1 = find(p==p(1));
p2 = p1(2) - 1;
p1 = p1(1);
l = p(p1:p2);
end

