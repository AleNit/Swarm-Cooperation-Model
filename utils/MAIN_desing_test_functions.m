
% design and rescale test functions for optimization 

clc
clear
close all


%% domain bounds and dimension
lb=0; ub=1;
dim=2;
fname='Griewank';         % landscape function {Styblinski-Tang,Ackley,Rastrigin,Schwefel,Griewank,fractal}


switch fname

    case 'Styblinski-Tang'
        minloc=0.211;
        maxloc=1;
        L = @(x) sum( (10.*x-5).^4 - 16.*(10.*x-5).^2 + 5.*(10.*x-5) )/2;
        Land = @(x) (L(x) - L(maxloc.*ones(1,dim)))./( L(maxloc.*ones(1,dim)) - L(minloc.*ones(1,dim)) ) ;

    case 'Ackley'
        minloc=0.6;
        maxloc=0.07;
        L = @(x) - 20.*exp(-0.2*sqrt(1/dim*( sum((10.*x-6).^2) ))) - ...
                   exp(1/dim*sum( cos(pi.*(10.*x-6)) ));        
        Land = @(x) (L(x) - L(maxloc.*ones(1,dim)))./( L(maxloc.*ones(1,dim)) - L(minloc.*ones(1,dim)) ) ;

    case 'Griewank'
        c=0.38;     b=25;   d=0.1;
        minloc=c;
        maxloc=0.92;
        L = @(x) 1.0*sum( (x-c).^2 ) - ...
                 d.*prod( cos( ((x-c).*b)./sqrt((1:length(x))) ) );        
        % Land = @(x) L(x);
        Land = @(x) (L(x) - L(maxloc.*ones(1,dim)))./( L(maxloc.*ones(1,dim)) - L(minloc.*ones(1,dim)) ) ;

    case 'Rastrigin'
        minloc=0.6;
        maxloc=0.089;
        L = @(x) sum( (10.*x-6).^2-10.*cos(pi.*(10.*x-6)) );        
        Land = @(x) (L(x) - L(maxloc.*ones(1,dim)))./( L(maxloc.*ones(1,dim)) - L(minloc.*ones(1,dim)) ) ;

    case 'Schwefel'
        L = @(x) sum( (1225.*x).*sin(sqrt(abs(1225.*x))) );
        minloc=0.7300;
        maxloc=0.8920;
        Land = @(x) (L(x) - L(maxloc.*ones(1,dim)))./( L(maxloc.*ones(1,dim)) - L(minloc.*ones(1,dim)) ) ;

end


%% plot Landscape function
nn=1001;
x=linspace(lb,ub,nn);
[X,Y]=meshgrid(x,x);
Lp=zeros(nn,nn);
for j=1:nn
    for i=1:nn
        Lp(j,i)=-Land([x(i),x(j)]);
        % Lp(j,i)=Land([x(i),x(j)]);
    end
end

% plot contour
surf(X,Y,Lp) 
% axis equal
xticks(0:0.1:1); yticks(0:0.1:1)
shading interp
colormap(viridis)
colorbar
view(2)

