function [p, d, t] = IntLinProgTwiceRelaxedTSP(D)
% Author: 
%     Mel Beckerleg, December 2016.
% Description:
%     Solves the travelling salesman problem using integer programming
%     without the cut-set constraint (i.e. allows loops).
% Input:
%     D: Matrix, distance matrix between cities.
% Output:
%     p: Array, row vector of permutation of the order of cities to visit.
%     d: Float, total distance travelled in a round trip.
%     t: Float, execution time for algorithm.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Spainish problem:
% D=[ 0 515 353 422 482 673 634 815 609 166
%      515 0 868 621 997 437 778 693 1046 349
%     353  868 0 434 129 841 631 827 256 519 
%     422 621 434 0 544 407 212 393 538 352 
%     482 997 129 544 0 951 756 937 219 648 
%     673 437 841 407 951 0 440 267 945 501
%     634 778 631 212 756 440 0 363 474 564 
%     815 693 827 393 937 267 363 0 837 673
%     609 1046 256 538 219 945 474 837 0 697
%     166 349 519 352 648 501 564 673 697 0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
n=length(D);
D=D +sum(sum(D))*eye(n); %high values on the diagonal avoid single city loops
F=reshape(D,n^2,1);
%generate A and b to impose the relaxed constraint that x<=1
%A=eye(n^2);
%b=ones(n^2,1);
%OR generate the bound vectors
UB=ones(n^2,1);
LB=zeros(n^2,1);
%generate Aeqn, which imposes the equality constraint sum_i~=j(x_ij)=1
Aeqn=zeros(2*n,n^2);
for idx=1:n
    Aeqn(idx,:)= [zeros(1,(idx-1)*n) ones(1,n) zeros(1,n^2-idx*n)];
    Aeqn(idx,idx+(idx-1)*n)=0;
end
for j=n+1:2*n
    J=j-n;
    for k=1:n
    Aeqn(j,1+(k-1)*n:(k-1)*n+n)= [zeros(1,(J-1)) 1 zeros(1,n-J)];
    Aeqn(j,J+(J-1)*n)=0;
    end
end
%beqn is a column vector of ones.
beqn=ones(2*n,1);
%set integer constraint
intcon=1:n^2;
%[X,FVAL]=linprog(F,A,b,Aeqn,beqn)
[X,FVAL]=intlinprog(F,intcon,[],[],Aeqn,beqn,LB,UB);
edge_transitions=reshape(X,n,n);
edges=find(edge_transitions'>0);
route_edges=zeros(2,n);
for idx=1:n
    route_edges(:,idx)=[idx edges(idx)-n*(idx-1)];
end
route=zeros(1,2*n+1); %note, 2*n to allow for loops
next=find(edge_transitions'>0);
route(1)=1;
idx=1;
k=1;
loop_length=zeros(1,2*n+1);
for idx=2:2*n+1
        if sum(route==route(idx-1))>1
            loop_length(k)=idx-1;
        k=k+1; %counting the number of loops
        for j=1:n
            if sum(route==j)==0 %'jump' to the next loop
              route(idx)=j;
              
              
                break
            end
        end
        else
            current=route(idx-1);
    route(idx)=next(current)-(current-1)*n;
        end
        if route(idx)==0
            break
        end
end
route=route(find(route));
p=route;
d=FVAL;
t=toc;
end
