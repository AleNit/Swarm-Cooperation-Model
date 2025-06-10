
% crete fractal surface and fit landscape function handle

clc
clear
close all
clearAllMemoizedCaches


% create rough surface
fname='fractal_surf.mat';     % output file name
sigma=0.5e-3;               % [mm] standard deviation of the roughness height
H=1.2;                      % Hurst exponent (D=3-H, D fractal dimension)
Lx=0.1;                     % [m] size of the topography in x direction
m=512;                      % pixel per direction
seed=0;                     % seed for random number generator
qr=0;                       % roll-off wavenumber

[Z , PixelWidth, PSD] = artificial_surf(sigma,H,Lx,m,m,seed,qr);

Zfr=Z-min(Z(:));
Zfr=Zfr./(max(Zfr(:))-min(Zfr(:)));
eps=1.0e-10;
[row,col]=find(Zfr<=1.0+eps & Zfr>=1.0-eps);
xp=linspace(0,1,m);
target=[xp(col);xp(row)];

% plot generated surface
figure(1)
[Xfr,Yfr]=meshgrid(xp,xp);
surf(Xfr,Yfr,Zfr)
hold on
scatter3(target(1),target(2),max(Zfr(:)),40,'MarkerEdgeColor','k', ...
    'MarkerFaceColor','r')
colorbar
xlabel('x'); ylabel('y'); 
tit=strcat('numerically generated surface, H=',num2str(H));
title(tit,'interpreter','latex','fontsize',12)

% plot surface cuts
figure(2)
plot(Xfr(ceil(m/2),:),Zfr(ceil(m/2),:),'-o')
hold on
plot(Yfr(:,ceil(m/2)),Zfr(:,ceil(m/2)),'-o')

return

% save discrete surface
path='C:/Users/PCALE/Desktop/OneDrive - Politecnico di Bari/research/swarm_swimmers/models/utils/';
save(strcat(path,fname),'Xfr','Yfr','Zfr','target')


