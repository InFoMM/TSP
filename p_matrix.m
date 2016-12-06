function [P] = p_matrix(X)
% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Computes an edge matrix from a transition matrix. This reduces a this
%     reduces the full transition matrix from vertex i to j into a list of
%     which vertices are connected.
% Input:
%     X: Matrix, transition matrix.
% Output:
%     P: Matrix, 2*N matrix showing the edges.
% Example:
%         X =
%              0     1     0
%              0     0     1
%              1     0     0
%     gives
%         P =
%              1     2
%              2     3
%              3     1

P = [(1:size(X, 1))', zeros(size(X, 1), 1)];
for i=P(:, 1)'
    l = X(i, :);
    P(i, 2) = find(l);
end

end

