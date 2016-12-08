function [p, d, t] = IntLinProgCutSetTSP(D)
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%generate the bound vectors
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


%Now we need to analyse and deal with loops!
number_of_loops=k-1;
loop_length=loop_length(1:number_of_loops);
loop_length(number_of_loops)=idx-1;

for j=2:number_of_loops
    J=number_of_loops-j+2;
    loop_length(J)=loop_length(J)-loop_length(J-1)-1;
end
loop_length(1)=loop_length(1)-1;
%generate inequality matrix to impose cut set constraints

A=zeros(number_of_loops,n^2);

in_the_loop=route(1:loop_length(1)+1);
not_in_the_loop=route(loop_length(1)+2:end);

for j=1:n
    for i=1:n
        if nnz(in_the_loop==i)>0 & nnz(not_in_the_loop==j)>0
            A(1,(i-1)*n+j)=1;
        end
    end
end

for marker=2:number_of_loops
in_the_loop=route(sum(loop_length(1:marker-1))+marker:sum(loop_length(1:marker-1))+loop_length(marker)+marker);
not_in_the_loop=[route(1:sum(loop_length(1:marker-1))+marker-1) route(sum(loop_length(1:marker-1))+loop_length(marker)+marker+1:end)];

for j=1:n
    for i=1:n
        if nnz(in_the_loop==i)>0 & nnz(not_in_the_loop==j)>0
            A(marker,(i-1)*n+j)=1;
        end
    end
end
end
b=ones(1,number_of_loops);
b=-b;

%recalculate a solution which doesn't have the loops
[Y,FVAL2]=intlinprog(F,intcon,-A,b,Aeqn,beqn,LB,UB);

edge_transitions=reshape(Y,n,n);
edges=find(edge_transitions'>0);
route_edges=zeros(2,n);
for idx=1:n
    route_edges(:,idx)=[idx edges(idx)-n*(idx-1)];
end
newroute=zeros(1,2*n+1); %note, 2*n to allow for loops
next=find(edge_transitions'>0);
newroute(1)=1;
idx=1;
k=1;
loop_length=zeros(1,2*n+1);
for idx=2:2*n+1
        if sum(newroute==newroute(idx-1))>1
            loop_length(k)=idx-1;
        k=k+1; %counting the number of loops
        for j=1:n
            if sum(newroute==j)==0 %'jump' to the next loop
              newroute(idx)=j;
              
              
                break
            end
        end
        else
            current=newroute(idx-1);
    newroute(idx)=next(current)-(current-1)*n;
        end
        if newroute(idx)==0
            break
        end
end
newroute=newroute(find(newroute));



p=newroute;
d=FVAL2;
t=toc;
end