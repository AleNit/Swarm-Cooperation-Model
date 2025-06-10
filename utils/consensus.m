
% ---------------------------------------------------------------- purpose
% compute global swarm consensus
% ---------------------------------------------------------------- input
% par: object collecting different case parameters
% xa [na,dim]: agent position at the current time step
% V [dim]: value of the landscape function at the agent location
% ---------------------------------------------------------------- output
% C: global swarm consensus
% lamk [M]: agent-wise noise parameter lambda_k, with M the number of agents
% ----------------------------------------------------------------

function [lamk,C]=consensus(par,xa,V)

M=par.M;
eps=1.0e-16;
dk=zeros(M,1);

Vm=min(V)+eps;
cm=sum(xa.*(V-Vm))./sum(V-Vm);     % centroid location

Dmax=getmaxdist(xa,M);     % max network distance

for i=1:M        
    dk(i) = norm(xa(i,:)-cm,2);     
end
C = 1 - 2/M*sum(dk);

C=max(C,0.05);    % a limiter is needed in case many agents exits the domain
   
lamk=dk./(Dmax*C);   

end