function [p, d, t] = tsp_ip_cut_set_oliver(M)
% Author: 
%     Oliver Sheridan-Methven, December 2016.
% Description:
%     Solves the travelling salesman problem using integer programming
%     without iteratively forcing a cut-set constraint (i.e. not allowing
%     any loops).
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

nl = 1;
Aieq = [];
m = 0;
bieq = [];
n = size(M, 1);
f = M; % Ensuring we move to/from different cities.
f = f(:);
n2 = n^2;
Aeq = spalloc(2*n, n2, 2*n2);
beq = ones(2*n, 1);
% Making all the rows sum to one.
for i=1:n
    Aeq(i, n*(i-1) + (1:n)) = 1;
end
% Making all the columns sum to one.
for i=1:n
   Aeq(i+n, i + n*(0:n-1)) = 1;
end
%%%%%%%% NB - The Following intcon is not appropriate !! %%%%%%%%%
% intcon = ones(n2, 1); % All entries of x must be integers.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
intcon = 1:n2; % All entries of x must be integers.
lb = zeros(n2, 1);
ub = ones(n2, 1);
ub((1:n)+(0:n-1)*n) = 0;

% While there are sub_loops:
while nl
    
    X = intlinprog(f, intcon, Aieq, bieq, Aeq, beq, lb, ub, optimoptions('intlinprog','Display','off'));
    X = reshape(X, n, n);
    P = p_matrix(X);
    d = compute_final_d(M, P);
    p = compute_paths_with_loops(P);
%     For each sub loop, we will impose the constraint that it must have a
%     connection with at least one of all the other sub groups. This will
%     eliminate all possible confiurations with those sub-loops on the next
%     iteration.
    p1 = p;
    l1 = find_loop(p1);
    if length(l1) + 1 == length(p) % There is only one global loop.
        nl = 0;
    else % There are at least 2 or more loops.
        c = zeros(1, n2);
        while ~isempty(p1) % Iterating over the first set of sub-loops.
        l1 = find_loop(p1);
        p1 = p1(length(l1)+2:end);
        p2 = p;
        % We ensure the second sub-loop is not the first sub-loop.
        for i=1:length(p2) 
            if any(l1==p2(i))
                p2(i) = 0;
            end
        end
        p2 = p2(p2>0);
        c2 = zeros(1, n2);
            while ~isempty(p2) % The second set of sub-groups.
                l2 = find_loop(p2);
                p2 = p2(length(l2)+2:end);
                c2 = c2 + cut_set_constraint_vector(n, l1, l2);
            end
        c = [c c2];
        end
        % Now appending the constraints to the inequality matrix.
        c = logical(c);
        c = -c;
        Aieq = Aieq';
        Aieq = Aieq(:);
        Aieq = [Aieq; c']';
        m = length(Aieq) / n2;
        Aieq = reshape(Aieq, m, n2);
        bieq = -ones(m, 1);
    end
end

P = p_matrix(X);
d = compute_final_d(M, P);
p = compute_paths_with_loops(P);
p = p(1:end-1); % We know this doesn't have any sub-loops.
t = toc;
end

