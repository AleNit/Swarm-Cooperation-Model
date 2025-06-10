
% ---------------------------------------------------------------- purpose
% create plot to monitor SCM execution
% ---------------------------------------------------------------- input
% V [function handle]: analytical expression of the landscape
% dV [function handle]: analytical expressions of the landscape derivatives
% {X,Y}: coordinate matrices with meshgrid structure
% {Landz,Landx}: value matrices with meshgrid structure. XY section and ZY
% section of the landscape
% dim: number of problem dimensions
% par: object collecting different case parameters
% xa [na,dim]: agent position at the current time step
% colo [na]: color matrix for agent scatter plot
% n: time-step counter
% limLand [2,dim]: bounds of the assigned landscape
% target [dim]: location of the true global optimum
% wrf: logical. If true write the figure to file
% Vevalh [dim]: value of the landscape function at the agent location
% lfname: string with the assigned landscape name
% ---------------------------------------------------------------- output
% kp: counter of the current snapshot
% ----------------------------------------------------------------

function kp=pltfig1(dim,n,par,X,Y,Landz,Landx,limLand,xa, ...
                    time,kp,colo,Vevalh,target,wrf,lfname)

M=par.M;
te=par.te;
CT=par.CT;
sigmat=par.sigmat;
tl=time+10;

tiledlayout(2,2);

delete(findall(gcf,'type','annotation'))

% landscape plot
nexttile([2 1])        
contl=linspace(min(min(Landz)),limLand(2),15);

if (dim==2) % 2D landscape

    contourf(X,Y,Landz,contl,'LineWidth',0.1,'color','w','facealpha',1)
    cb=colorbar;
    colormap(viridis)
    clim([limLand(1),limLand(2)])
    hold on
    axis equal
    axis([0,1,0,1])
    % axis([-0.5,1.5,-0.5,1.5])
    
    % plot target
    scatter(target(1),target(2),70,'pentagram','MarkerFaceColor','r','MarkerEdgeColor','k')
    
    % plot agents
    scatter(xa(:,1),xa(:,2),35,colo,'filled','markeredgecolor','k','LineWidth',1) 
    xlabel('$x^1/L$','interpreter','latex','fontsize',14)
    ylabel('$x^2/L$','interpreter','latex','fontsize',14)
    hold off 

    yticks(0:0.2:1)

else

    nn=length(Landz(:,1));
    Z=target(3)*ones(nn,nn);
    surf(X,Y,Z,Landz)
    hold on    
    Z=target(1)*ones(nn,nn);
    surf(Z,X,Y,Landx)

    % contourf(X,Y,Land,contl,'LineWidth',0.1,'color','w','facealpha',1)     % if analytical landscape function
    shading interp
    cb=colorbar;
    colormap(viridis)
    clim([limLand(1),limLand(2)])
    hold on
    axis equal
    axis([0,1,0,1,0,1])
    
    % plot target
    scatter3(target(1),target(2),target(3),70,'pentagram','MarkerFaceColor','r','MarkerEdgeColor','k')
    
    % plot agents
    scatter3(xa(:,1),xa(:,2),xa(:,3),35,colo,'filled','markeredgecolor','k','LineWidth',1) 
    xlabel('$x^1/L$','interpreter','latex','fontsize',14)
    ylabel('$x^2/L$','interpreter','latex','fontsize',14)
    zlabel('$x^3/L$','interpreter','latex','fontsize',14)
    hold off 

end


% evaluated landscape plot
nexttile(2)
for i=1:min(5,M)
    plot(linspace(0,time,n),Vevalh(1:n,i),'-','color',colo(i,:),'handlevisibility','off')
    % fake plot, just to have circles in the legend
    scatter(-100,-100,35,colo(i,:),'filled','markeredgecolor','k','LineWidth',1)
    hold on
end
xlabel('$t \, J$','interpreter','latex','fontsize',14)
ylabel('$V_k$','interpreter','latex','fontsize',14)
legend('agent 1','agent 2','agent 3','agent 4','agent 5', ...
    'Location','southeast')
axis([0,tl,0,1])
% xticks(0:tl/5:tl);
xticks(0:10:400);   % for the tape
yticks(0:0.2:1)
box on

% adjust colorbar size
cb.Position(4)=0.72;
annotation(gcf,'textbox',[0.462,0.862,0.0295,0.0727],'String',{'$\psi$'},...
    'LineStyle','none','Interpreter','latex','FontSize',14,'FitBoxToText','off');

hold off 

% global consensus plot
nexttile(4)
CT(n)=Inf; % just for the plotting purpose
yyaxis left
plot(linspace(0,time,n),CT(1:n),'-k')
xlabel('$t \, J$','interpreter','latex','fontsize',14)
ylabel('$C$','interpreter','latex','fontsize',14)
xlim([0,tl])
ylim([0,1])
% xticks(0:tl/5:tl);
xticks(0:10:400);   % for the tape
yticks(0:0.2:1)
yyaxis right
plot(linspace(0,time,n-1),sigmat(1:n-1),'-','Color','#c00')
ylim([0,par.sigmalim])
ylabel('$\sigma$','interpreter','latex','fontsize',14)
ax=gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = '#c00';
hold off


set(gcf,'position',[100,250,1100,440])
drawnow


if (wrf)
    fold = strcat('./frames_',lfname,'/');
    if (~exist(fold, 'dir'))
       mkdir(fold)
    end
    picname=strcat(fold,'snap_',sprintf('%05d',kp));
    print('-dpng','-r200',picname);                
    kp=kp+1;
end

end
