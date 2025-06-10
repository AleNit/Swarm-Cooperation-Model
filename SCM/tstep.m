
% ---------------------------------------------------------------- purpose
% numerically integrate the Langevin model in time with the Euler-Maruyama
% scheme
% ---------------------------------------------------------------- input
% dim: number of problem dimensions
% par: object collecting different case parameters
% n: time-step counter
% dVdx [na,dim]: landscape gradient, with na the number of agents 
% xa_n [na,dim]: agent position at the old time step
% lamk [na,1]: agent-dependent noise parameter lambda_k
% ---------------------------------------------------------------- output
% xa_np1 [na,dim]: agent position at the old time step
% ----------------------------------------------------------------

function xa_np1=tstep(dim,par,n,dVdx,xa_n,lamk)

sigma=par.sigma;
M=par.M;
dt=par.dt;

xa_np1=zeros(M,dim);
Adj_full=1:1:M;

% compute agent-wise vector norm of the gradient
normdV=vecnorm(dVdx,2,2);
xi = 1/mean(normdV);


for i=1:M

    eta=par.etaM(i).dir;

    Adj=Adj_full;        
    Adj(i)=[];               

    % compute Consensus energy
    dEdx=zeros(1,dim);
    for j=1:M-1
        jj = Adj(j);
        dx_ij = xa_n(i,:)-xa_n(jj,:);
        dEdx = dEdx + sin(dx_ij.*pi/2);
    end        
    dEdx=-dEdx./(M-1);

    gn=lamk(i)*sigma;
    dW = sqrt(dt).*eta(n,1:dim);   
    fn = 2/pi.*dEdx + xi.*4/pi^2.*dVdx(i,:);
    xa_np1(i,:) = xa_n(i,:) + dt.*fn + 2/pi*gn.*dW;

end

end
