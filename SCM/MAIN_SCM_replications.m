
% -------------------------------------------------------------------------
% Run the NNr replications of the SCM search over a test landscape function
% for performance comparison; evaluate success rate and mean number of
% function evaluations
% -------------------------------------------------------------------------
% reference paper: "A collective intelligence model for swarm robotics applications"
% author: Alessandro Nitti, Polytechnic University of Bari, Italy
% email: alessandro.nitti@poliba.it
% -------------------------------------------------------------------------


clc
clear
close all
addpath('../utils/')



%% simulation parameters
lfname          = 'Rastrigin';              % landscape function {Styblinski,Ackley,Rastrigin,Schwefel,Griewank,fractal}
NNr             = 100;                      % number of replications 
nvars           = 2;                        % number of landscape dimensions  
por.M           = 8;                        % number of agents 
por.te          = 500;                      % maximum simulation duration
por.dt          = 0.1;                      % time step size for integration
tau             = por.dt*60;                % global noise modulation: time window coeff.
por.sigmalim    = 0.3;                      % maximum global noise factor
omega           = 0.20;                     % global noise modulation: step coeff.
sigma0          = 0.05;                     % initial value of global noise modulation factor


%% pre-processing operations
% input check
if (mod(tau,por.dt)~=0)
    error('... tau is not a multiple of the time step size')
end


% pick landscape function
[Land,dLand,limLand,target,por]=getLand_SCM(nvars,lfname,por,'maximize');
[X,Y,Landpz,Landpx,colo]=preplot(nvars,251,lfname,Land,target,por);


%% run replications
for nr=1:NNr
            
    % pick agent initial position
    xa_n=agent_init(nvars,por.M,false(1));
    xa_np1=zeros(size(xa_n));
            
    % initialization
    time=0.0;
    por.nts=por.te/por.dt;
    por.CT=zeros(por.nts,1);        por.sigmat=zeros(por.nts,1);
    lamk=zeros(por.M,1);            aod=false(por.M,1);
    Vevalh=zeros(por.nts,por.M);
    if (por.Lan)
        [Veval,dVeval]=compLand_an(nvars,Land,dLand,xa_n,por,aod);
    else
        [Veval,dVeval]=compLand(X,Y,Landpz,nvars,xa_n,por,aod);
    end

    
    % build noise arrays with random normal distributions
    clear por.etaM
    for i=1:por.M              
        for j=1:nvars
            rng(2*i+por.M*(j-1)+nr-1);
            por.etaM(i).dir(:,j)=normrnd(0,1,[por.nts,1]);            
        end
    end


    % time loop
    stfn=@(x) (1-tanh(x/100))/20+0.9;           % stop criterium function
    kp=1;
    nn=ceil(tau/por.dt); 
    por.sigma=sigma0;
    for n=1:por.nts   
                
        % time advancement
        xa_np1=tstep(nvars,por,n,dVeval,xa_n,lamk); 
        
        % check if agent came out of the domain
        for j=1:por.M
            if ( any(xa_np1(j,:)<0) || any(xa_np1(j,:)>1) )
                aod(j)=true;
            else
                aod(j)=false;
            end
        end

    
        % evaluate landscape and compute swarm consensus  
        if (por.Lan)
            [Veval,dVeval]=compLand_an(nvars,Land,dLand,xa_np1,por,aod);
        else
            [Veval,dVeval]=compLand(X,Y,Landpz,nvars,xa_np1,por,aod);
        end
        Vevalh(n+1,:)=Veval';
    
        [lamk,por.CT(n)]=consensus(por,xa_np1,Veval);
    
        % update global noise coefficient  
        if (n>nn)
            I1=sum(por.CT(n-ceil(nn/2)+1:n).*por.dt);
            I2=sum(por.CT(n-nn:n-ceil(nn/2)).*por.dt);  
            eps=0.0;        
            I=I1-I2-eps;        
            if (mod(time,tau)<por.dt)            
                if ( (I1+I2) > stfn(por.M)*tau )      % stop criterium dependent on swarm size
                    break
                end
                por.sigma=por.sigma+por.dt*omega*min(I,0)/I;            
                if (por.sigma >= por.sigmalim ); por.sigma=sigma0; end    % re-initialize sigma value
            end
        end
        por.sigmat(n)=por.sigma;
           
        % variable update
        xa_n=xa_np1;  
        time=time+por.dt;  
    
    end

    xo=mean(xa_n,1);
    dist(nr)=norm(target-xo,2);
    nit(nr)=n;
    nfel(nr)=por.M*n;
    
    if (dist(nr)<=0.05);     str=': the global optimum was found. n=';
    else;   str=': the global search failed. n=';  end
    disp(['Replication ',num2str(nr),str,num2str(n)])
    
end


%% show statistics
dt1=find(dist<=0.05);
sr=length(dt1)/NNr;

disp(' ')
disp(['success rate: ',num2str( sr*100),' %'])
disp(['number of iterations: ',num2str(mean(nit)),' +- ',num2str(std(nit))])
disp(['number of fn. evaluations: ',num2str(mean(nfel)),' +- ',num2str(std(nfel))])



