%% Lin Prog twice relaxed TSP
%
%
%
%First constraint: f'x
clear
clc
%given a distance matrix D, concate D:
D=[ 50000 515 353 422 482 673 634 815 609 166
     515 50000 868 621 997 437 778 693 1046 349
    353  868 50000 434 129 841 631 827 256 519 
    422 621 434 50000 544 407 212 393 538 352 
    482 997 129 544 50000 951 756 937 219 648 
    673 437 841 407 951 50000 440 267 945 501
    634 778 631 212 756 440 50000 363 474 564 
    815 693 827 393 937 267 363 50000 837 673
    609 1046 256 538 219 945 474 837 50000 697
    166 349 519 352 648 501 564 673 697 50000];

%D=[ 0 0 0 0 0 0 0 0 0 0 
%    515 0 0 0 0 0 0 0 0 0 
%    353  868 0 0 0 0 0 0 0 0
%    422 621 434 0 0 0 0 0 0 0
%    482 997 129 544 0 0 0 0 0 0
%    673 437 841 407 951 0 0 0 0 0
%    634 778 631 212 756 440 0 0 0 0
%    815 693 827 393 937 267 363 0 0 0
%    609 1046 256 538 219 945 474 837 0 0
%    166 349 519 352 648 501 564 673 697 0];

D=[ 50 1 2
    4 50 5
    1 5 50];

n=length(D);
F=reshape(D,n^2,1);
%generate A and b to impose the relaxed constraint that x<=1
%A=eye(n^2);
%b=ones(n^2,1);
%OR generate the bound vectors
UB=ones(n^2,1);
LB=ones(n^2,1);
%generate Aeqn, which imposes the equality constraint sum_i~=j(x_ij)=1
Aeqn=zeros(2*n,n^2);
for i=1:n
    Aeqn(i,:)= [zeros(1,(i-1)*n) ones(1,n) zeros(1,n^2-i*n)];
    Aeqn(i,i+(i-1)*n)=0;
end
for j=n+1:2*n
    J=j-n;
    for k=1:n
    Aeqn(j,1+(k-1)*n:(k-1)*n+n)= [zeros(1,(J-1)) 1 zeros(1,n-J)];
    Aeqn(j,J+(J-1)*n)=0;
    end
end
%beqn is a column vector of ones.
beqn=ones(1,2*n);

%[X,FVAL]=linprog(F,A,b,Aeqn,beqn)
[X,FVAL]=linprog(F,[],[],Aeqn,beqn,LB,UB)

%glitches: infeasibility.
%should D be lower triangular?