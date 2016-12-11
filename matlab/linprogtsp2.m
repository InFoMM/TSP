function [p,d,C]=linprogtsp2(M,flag)
% Author:
%     Clint Wong, December 2016.
% Description:
%     Simple Miller-Tucker-Zemlin algorithm which solves the TSP.
%     For n cities, n dummy
%     variables u_1,...,u_n are introduced to impose the cut-set constraints.
% Input:
%     M:    distance matrix. For Spanish problem, set M=0. 
% Output:
%     p: Array, row vector of permutation of the order of cities to visit.
%     d: Float, total distance travelled in a round trip.
%     C: Matrix with C(i,j)=x_ij
clc
if M==0
[~,M]=spain_example();
else
end

[n,~]=size(M);
N=n^2;

% vector c in objective function c'x. 
% x = [x11 ... x1n x21 ... xnn u1 ... un]
f=[M(:)' zeros(1,n)];

% equality constraints
Aeq=zeros(2*n,N+n);
beq=ones(2*n,1);
for i=1:n
    for j=1:n
        if i ~= j
        Aeq(i,n*(j-1)+i)=1;
        Aeq(n+i,n*(i-1)+j)=1;
        else
        end
    end
end

% Matrix check
% spy(Aeq);shg

% Inequality constraints: (n-1)*(n-2) of them
v=entries(n); % see below
A=zeros((n-1)*(n-2),N+n);
b=(n-1)*ones((n-1)*(n-2),1);
for i=1:(n-1)*(n-2)
    vv=v(i,:);
    A(i,(vv(1)-1)*n+vv(2))=n;
    A(i,N+vv(1))=1;
    A(i,N+vv(2))=-1;
end

% Matrix check
% spy(A);shg

% bounds for indicators x_ij and dummy variables u_i
lb=[zeros(N,1); ones(n,1)];
ub=[ones(N,1); n*ones(n,1)];

% integer constraint on all indicators x_ij and dummy variables u_i
intcon=1:(N+n);

% solve
if flag==1 % LP
    [x,FVAL,exitflag,output] = linprog(f,A,b,Aeq,beq,lb,ub,[]);
elseif flag==2 % IP
    [x,FVAL,exitflag,output] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,[]);
end

% path recovery 
C=reshape(x(1:N,1),n,n);
[row,col]=find(C'>0);

p=get_permutation([col row]);
d=FVAL;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [v]=entries(n)
% Author:
%     Clint Wong, December 2016.
% Description:
%     For cut-set/inequality MTZ constraint: u_i - u_j +n*x_ij <= n-1. 
%     Script which generates entries (i,j) with i,j ~= 1 or i ~= j.
% Input:
%     n:    number of cities. 
% Output:
%     v: (n-1)*(n-2) x 2 matrix of entries 
v=[ones(n,1) (1:n)'];

for i=2:n
    v = [v; i*ones(n,1) (1:n)'];
end

while sum(sum(v==1))>0
        [row,col]=find(v==1,1);
        v(row,:)=[];
end

while sum(v(:,1)==v(:,2))>0
        [row,col]=find(v(:,1)==v(:,2),1);
        v(row,:)=[];
end

end