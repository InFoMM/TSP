function [route, UBcost, time] = edgeupperbound(y_init)
%%Author: Mel Beckerleg
%Description: TSP algorithm that generates an upper bound on cost by adding the cheapest
%available edge that doesn't create a loop or a fork.
%Input: an nxn matrix representing distances between cities
%Output: an upper bound on the cost, computation time, a route.
n=length(y_init);
y=y_init +sum(sum(y_init))*eye(n);
t_edge=zeros(n);
t_cost=zeros(1,n);
hold=zeros(2,n); %store the vertices of each edge)
 %create a hamiltonian path of length n by adding in the cheapest available edge
k=1;
tic
while k<n
     %find the smallest value and its index
[p1 i1]=min(y);
[p2 i2]=min(p1);
idx=[i1(i2) i2];
%check there are no branches or loops (branches = vertices with degree more
%than two)
hope=0;
if sum(t_edge(idx(1),:))<2 & sum(t_edge(idx(2),:))<2 
    hope=1;
end
j=1;
adj=t_edge;
while j<k+1
    adj=t_edge*adj;
    adj=t_edge^j;
    if adj(idx(1), idx(2))>0
        hope=0;
        break
    end
    j=j+1;
    
end 

 if hope==1
t_edge(idx(1),idx(2))=1;
t_edge(idx(2),idx(1))=1;
t_cost(k)=p2;
hold(:,k)=[idx(1) idx(2)]';
k=k+1;
end
y(idx(1),idx(2))=inf;
y(idx(2),idx(1))=inf;
end
%add the final edge to complete the cycle
for j=1:n %find the exposed vertices which only have one edge coming out of them
    if sum(sum(hold==j))<2
        end_edge(j)=j;
    end
end
missing=[find(end_edge)];
hold(:,n)=missing'; %make an edge between the exposed vertices
t_cost(n)=y_init(missing(1),missing(2));
UBcost=sum(t_cost);
time=toc;
cities=zeros(1,n+1);
newhold=hold;
cities(1)=hold(1,1);
cities(2)=hold(2,1);
newhold(:,1)=[0 0];
position=2; %position of the most recently added node - 1 is top 2 is bottom.
%find the next one
for k=2:n
nxtedge=ceil(find(newhold==cities(k))/2);
check=floor(find(newhold==cities(k))/2);
if    nxtedge-check==0 %vertex found on bottom, add the top vertex
    position=1;    
else 
    position=2;%vertex found on bottom row, add the top vertex
end
cities(k+1)=newhold(position,nxtedge);
newhold(:,nxtedge)=0; %remove edge from search

end
route=cities;
end

