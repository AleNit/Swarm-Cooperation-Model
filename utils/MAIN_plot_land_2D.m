
% plot 2D landscape functions used for optimization tests

clc
clear
close all
kf=1;


lfname={'Styblinski','Ackley','Rastrigin','Schwefel','Griewank','fractal'};
por.M=10;

for i=1:length(lfname)

    if (isequal(lfname{i},'fractal'))
        load('../utils/fractal_surf.mat')
        Landp=Zfr;
        xa=Xfr(1,:);
        [X,Y]=meshgrid(xa,xa);
    else
        [Land,~,~,target,por]=getLand_SCM(2,lfname{i},por,'maximize');
        [X,Y,Landp,~,~]=preplot(2,201,lfname{i},Land,target,por);
    end
    
    % landscape plot
    figure(kf); kf=kf+1;
    limLand=[min(min(Landp)),max(max(Landp))];
    set(gcf,'position',[100,100,400,400])
    contl=linspace(limLand(1),limLand(2),15);
    contourf(X,Y,Landp,contl,'LineWidth',0.1,'color','w','facealpha',1)
    colormap(viridis)
    clim([0,1])
    hold on
    axis equal
    axis([0,1,0,1])
    xticks(0:0.2:1);    yticks(0:0.2:1);
    xlabel('$x^1/L$','Interpreter','latex','FontSize',14)
    ylabel('$x^2/L$','Interpreter','latex','FontSize',14)
    if (i==1)
        tit='Styblinski-Tang';
    else
        tit=lfname{i};
    end
    title(tit,'Interpreter','latex','FontSize',14)
    
    % add colorbar
    cb=colorbar;
    set(cb,'location','south','Ticks',[0,1],'Position',[0.77,0.2,0.08,0.025], ...
        'LineWidth',1.4,'color','w','FontWeight', 'bold')
    
    % plot target
    scatter(target(1),target(2),70,'pentagram','MarkerFaceColor','r','MarkerEdgeColor','k')
    
    drawnow

end

