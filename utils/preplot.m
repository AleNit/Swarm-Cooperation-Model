
% ---------------------------------------------------------------- purpose
% perform preliminary operations the simulation plots
% ---------------------------------------------------------------- input
% nvars: number of problem dimensions
% nnp: number of points to use for the coutour plot
% lfname: string with the assigned landscape name
% Land: function handle of the assigned landscape
% target [dim]: location of the true global optimum
% por: object collecting different case parameters
% ---------------------------------------------------------------- output
% colo [M]: color matrix for agent scatter plot, with M the number of agents
% {X,Y}: coordinate matrices with meshgrid structure
% {Landz,Landx}: value matrices with meshgrid structure. XY section and ZY
% ----------------------------------------------------------------

function [X,Y,Landpz,Landpx,colo]=preplot(nvars,nnp,lfname,Land,target,por)

% create matrices for landscape plots
xxp=linspace(0,1,nnp);
[X,Y]=meshgrid(xxp,xxp);
Landpz=zeros(size(X));
Landpx=zeros(size(X));
if (nvars==2)   
    if (isequal(lfname,'fractal'))
        load('../utils/fractal_surf.mat')
        X=Xfr; Y=Yfr; Landpz=Zfr;
    else
        for j=1:nnp
            for i=1:nnp
                Landpz(j,i)=Land([xxp(i),xxp(j)]);
            end
        end
    end
    Landpx=Landpz;
elseif (nvars==3)
    ntz=ceil(target(3)*nnp);
    for j=1:nnp
        for i=1:nnp
            Landpz(j,i)=Land([xxp(i),xxp(j),xxp(ntz)]);
        end
    end
    ntx=ceil(target(1)*nnp);
    for j=1:nnp
        for k=1:nnp
            Landpx(k,j)=Land([xxp(ntx),xxp(j),xxp(k)]);
        end
    end
end


% generate random colors for agents
rng(0,'twister');
colo=normrnd(0,0.4,[por.M,3]);
colo(colo<0)=-colo(colo<0);
colo(colo>1)=1.0-(colo(colo>1)-1.0);

end
