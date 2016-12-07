function [p, d, t] = forcefully_increasing_loop(M)
% Author:
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Given a loop of some cities, computes how to forcefully add a city
%     into the path, and then increases the path
%     accordingly. Note this gives a stochastic performance.
% Input:
%     M: Matrix, distance matrix between cities.
% Output:
%     p: Array, row vector of permutation of the order of cities to visit.
%     d: Float, total distance travelled in a round trip.
%     t: Float, execution time for algorithm.
if range(size(M))
    error('Input a square distance matrix.')
elseif ~issymmetric(M)
    error('Input a symmetric distance matrix.')
end
tic
d = realmax;
d = 0.0; % the total distance.
U = zeros(1, size(M, 1)); % Indices in graph.
V = 1:length(U); % Initialising V, the complement of U;
P = [V; U]'; % We store the path P as a matrix:
% We intialise U with 3 random points from V.
ui = randperm(length(V), 3);
U(1:3) = ui;
V(ui) = []; % remove the indices from V.
V = V(randperm(numel(V))); % Shuffle the indices we will search though.
up = circshift(ui, 1);
for i=1:3
    P(ui(i), 2) = up(i); % Update P
end
d = compute_d(M, P);
while ~isempty(V)
    d_min = realmax;
    d_old = compute_d(M, P);
    u = P(all(P, 2), :);
    v = V(1);
    for i=1:size(u, 1)
        u1 = u(i, 1);
        u2 = u(i, 2);
        d_new = d_old;
        d_loss = M(u1, u2);
        d_gain = M(u1, v) + M(v, u2);
        d_new = d_new + d_gain - d_loss;
        if d_new < d_min
           d_min = d_new;
           u1_new = u1;
           u2_new = v;
           u3_new = u2;
        end
    end
    P(u1_new, 2) = u2_new;
    P(u2_new, 2) = u3_new;
    V(V==u2_new) = [];
end
d = compute_d(M, P);
p = get_permutation(P);
t = toc;
end