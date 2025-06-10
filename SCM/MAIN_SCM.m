
% -------------------------------------------------------------------------
% Simulate the operation of the Swarm Cooperation Model (SCM) by
% integrating an overdamped Langevin equation. The objective of the swarm is
% to find the absolute minimum of the assigned landscape function
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
nvars           = 2;                        % number of landscape dimensions
por.te          = 500;                      % maximum simulation duration
por.dt          = 0.1;                      % time step size for integration
por.M           = 8;                        % number of agents
omega           = 0.20;                     % global noise modulation: step coeff.
tau             = por.dt*60;                % global noise modulation: time window coeff.
sigma0          = 0.05;                     % initial value of global noise modulation factor
por.sigmalim    = 0.3;                      % maximum global noise factor 
nplt            = 50;                       % step interval for output plot
wrf             = true;                    % save output figures to file 



%% pre-processing operations
% input check
if (mod(tau,por.dt)~=0)
    error('... tau is not a multiple of the time step size')
end


% pick agent initial position
xa_n=agent_init(nvars,por.M,false);
% xa_n=rand(por.M,nvars);


% pick landscape function
[Land,dLand,limLand,target,por]=getLand_SCM(nvars,lfname,por,'maximize');


% preliminary operations for graphic output
[X,Y,Landpz,Landpx,colo]=preplot(nvars,251,lfname,Land,target,por);


% initialization
rng(0)
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
for i=1:por.M              
    for j=1:nvars
        rng(2*i+por.M*(j-1));
        por.etaM(i).dir(:,j)=normrnd(0,1,[por.nts,1]);            
    end
end


% set output figure
figure(1);
% FF=figure('visible','off');
set(gcf,'position',[50,250,1100,440])
tiledlayout(2,2);


%% time loop
stfn=@(x) (1-tanh(x/100))/20+0.9;           % stop criterium function
kp=181;
nn=ceil(tau/por.dt); 
por.sigma=sigma0;
for n=1:por.nts   
    
    % plot figure
    if ( nvars<4 & mod(n-1,nplt)==0 )        
        disp(['time step ',num2str(n),'/',num2str(por.nts)])  
        figure(1)
        kp=pltfig1(nvars,n,por,X,Y,Landpz,Landpx,limLand,xa_n, ...
            time,kp,colo,Vevalh,target,wrf,lfname); 
    end
    
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
disp(['target: ',num2str(target)])
disp(['localized optimum: ',num2str(xo)])
disp(['Total evaluations: ',num2str(por.M*n)])
        

