function [p,d,t] = twoopt(M)
% Author:
%     Clint Wong, December 2016.
% Description:
%     Initialise with route 1, 2, ..., 10, 1.
%     Replace 2 edges at random and accept the new route if it is shorter.
%     Terminate when the current distance is not lowered for 1000
%     consecutive trials. 
% Input:
%     M: Matrix, distance matrix between cities.
% Output:
%     p: Array, row vector of permutation of the order of cities to visit.
%     d: Float, total distance travelled in a round trip.
%     t: Float, execution time for algorithm.

tic
[N,~]=size(M);

% flow matrix, with D(i,j)=indicator(i to j)
D=zeros(N,N);

% initialise, route from 1 to N
D=diag(ones(1,N-1),1);
D(N,1)=1;

dold=sum(M(D>0));

% define p(i) is the destination of i
[p,~]=find(D'>0);
% number of trials
iter=0;

while iter<1000
    % permute 2 edges
    id=randperm(N,2);
    a=id(1);b=id(2);
    % new path length        
    dnew=dold-M(a,p(a))-M(b,p(b))+M(a,b)+M(p(a),p(b));
    if dnew < dold
        % take new path
        dold=dnew;
        iter=0;
    % update flow matrix
        % replace 2 edges
        D(a,b)=1;
        D(p(a),p(b))=1;
        D(a,p(a))=0;
        D(b,p(b))=0;
        
        % reconstruct flow matrix such that it has non-zero columns
        flag=1;
        while flag>0
               % find first zero column in flow matrix
               v1=find(sum(D)<1,1);
               % fill with an edge
               D(p(v1),v1)=D(v1,p(v1));
               D(v1,p(v1))=0;
               
               % check whether there are anymore zero columns
               v2=min(sum(D));
            if v2==1
                flag=0;
                % output path
                [p,~]=find(D'>0);
            else
            end
        end
    else
        iter=iter+1;
    end
end
P = [1:length(p); p']';
% amend p-output 
p = get_permutation(P);

d=dold;
t=toc;

end

