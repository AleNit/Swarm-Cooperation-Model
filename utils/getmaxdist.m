
% ---------------------------------------------------------------- purpose
% find maximum distance in a point cloud in a N-dimensional space
% ---------------------------------------------------------------- input
% x [M,N]: agent position at the current time step, with N the numebr of
% problem dimensions
% M: number of agents
% ---------------------------------------------------------------- output
% MaxDis: maximum distance within the network
% ---------------------------------------------------------------- 

function MaxDis=getmaxdist(x,M)

Dis=zeros(sum(M-1:-1:1),1);

count = 1;
for i = 1:M-1
    for j = i+1:M
        Dis(count)=norm(x(i,:)-x(j,:),2);
        count = count + 1;
    end
end
MaxDis=max(Dis);

end