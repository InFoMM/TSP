function [c, M] = spain_example()
% Author: 
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Produces a matrix M which represents the distance information for the
%     travelling salesman problem.
% Input: 
%     None.
% Output:
%     c: String Array, spanish cities.
%     M: Matrix, distances between spanish cities indexed according to c,
%         with distances in km.

% The cities.
c = {'Alicante', 'Barcelona', 'Granada', 'Madrid', 'Malaga', ... 
    'Pamplona', 'Salamanca', 'Santander', 'Sevilla', 'Valencia'};
c = string(c);

% The distance matrix (km).
M = zeros(length(c));
M(1, 2:end) = [515, 353, 422, 482, 673, 634, 815, 609, 166];
M(2, 3:end) = [868, 621, 997, 437, 778, 693, 1046, 349];
M(3, 4:end) = [434, 129, 841, 631, 827, 256, 519];
M(4, 5:end) = [544, 407, 212, 393, 538, 352];
M(5, 6:end) = [951, 756, 937, 219, 648];
M(6, 7:end) = [440, 267, 945, 501];
M(7, 8:end) = [363, 474, 564];
M(8, 9:end) = [837, 673];
M(9, 10:end) = [697];
M = M + M';

end