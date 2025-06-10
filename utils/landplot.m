
% ---------------------------------------------------------------- purpose
% plot landscape function in 2 or 3 dimensions
% ---------------------------------------------------------------- input
% lfname: string with the assigned landscape name 
% dim: number of problem dimensions
% Land: function handle with the assigned landscape
% {lb,ub}: lower bound and upper bound of the assigned landscape
% nn: number of points to use for the plot for each dimension
% target [dim]: location of the true global optimum
% xM [na,dim]: agent position at the current time step, with na the 
% number of agents
% ---------------------------------------------------------------- 

function landplot(lfname,dim,Land,lb,ub,nn,target,xM)

if (dim==2) % 2D landscape

    if (isequal(lfname,'fractal'))

        load('../utils/fractal_surf.mat')
        Zfr=-Zfr;
        contourf(Xfr,Yfr,Zfr,12)

    else

        % create nn x nn landscape matrix
        x=linspace(lb(1),ub(1),nn);
        [X,Y]=meshgrid(x,x);
        Lp=zeros(nn,nn);
        for j=1:nn
            for i=1:nn
                Lp(j,i)=Land([x(i),x(j)]);
            end
        end
        
        % plot contour
        contourf(X,Y,Lp,12) 

    end
    
    hold on
    xlabel('$x^1$','interpreter','latex','fontsize',14); 
    ylabel('$x^2$','interpreter','latex','fontsize',14); 
    axis equal; axis([0,1,0,1])    
    colorbar
    view(2)
    scatter(target(1),target(2),45,'pentagram','MarkerEdgeColor','k','MarkerFaceColor','r')
    scatter(xM(:,1),xM(:,2),25,'MarkerEdgeColor','k','MarkerFaceColor','m')

elseif (dim==3) % 3D landscape; plot 2 slices bapping by the global optimum

    % create nn x nn x nn landscape matrix
    x=linspace(lb(1),ub(1),nn);
    [X,Y]=meshgrid(x,x);
    Lp1=zeros(nn,nn);   Lp2=Lp1; 
    ntz=ceil(target(3)*nn);
    for j=1:nn
        for i=1:nn
            Lp1(j,i)=Land([x(i),x(j),x(ntz)]);
        end
    end
    ntx=ceil(target(1)*nn);
    for j=1:nn
        for k=1:nn
            Lp2(k,j)=Land([x(ntx),x(j),x(k)]);
        end
    end    
    
    % plot contour
    Z=target(3)*ones(nn,nn);
    surf(X,Y,Z,Lp1)
    hold on    
    Z=target(1)*ones(nn,nn);
    surf(Z,X,Y,Lp2)

    shading interp
    xlabel('$x^1$','interpreter','latex','fontsize',14); 
    ylabel('$x^2$','interpreter','latex','fontsize',14); 
    zlabel('$x^3$','interpreter','latex','fontsize',14); 
    axis equal; axis([0,1,0,1,0,1])
    colorbar
    scatter3(target(1),target(2),target(3),45,'pentagram','MarkerEdgeColor','k','MarkerFaceColor','r')
    scatter3(xM(:,1),xM(:,2),xM(:,3),25,'MarkerEdgeColor','k','MarkerFaceColor','m')    

end

end
