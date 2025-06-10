
% ---------------------------------------------------------------- purpose
% Initialize the position of M agents in a N-dimensional space. If N=2 arrange 
% the M points in a unit square aiming to get the greatest minimal separation, 
% i.e., pack M equal circles. If N>2 and sqrt(M) is integer generate an array of
% equally spaced points for each dimension. If N>2 and sqrt(M) is not integer
% distribute points randomly in the N dimensions
% ---------------------------------------------------------------- input
% N: number of dimensions
% M: number of agents
% plt: logical. If true, plot the initial position and stop the execution
% ---------------------------------------------------------------- output
% x0 [M,N]: agent initial position
% ----------------------------------------------------------------

function x0=agent_init(N,M,plt)


fname=strcat('../utils/csq_coords/csq',num2str(M),'.txt');

if (N==2)

    if (isfile(fname))   % if packing solution doesn't exist, just pick from uniform random distribution
        fileID = fopen(fname,'r');
        A = fscanf(fileID,'%i %f %f',[3,Inf]);
        fclose(fileID);
        x0=squeeze(A(2:3,:))'+0.5;
    else
        x0=rand(M,2)';
    end

    if (plt)
        figure(99)
        scatter(x0(:,1),x0(:,2),30,'MarkerEdgeColor','k','MarkerFaceColor','r')
        axis equal; axis([0,1,0,1]); box on
        xlabel('$x^1$','Interpreter','latex'); ylabel('$x^2$','Interpreter','latex');        
        error('... check plot on agent initial position')
    end

elseif (N>2)

    a=M^(1/N);
    if ( floor(a)==ceil(a) )
        b=1/a;
        xx=b/2:b:(1-b/2);
        combs=cell(1,N);
        [combs{:}] = ndgrid(xx);
        x0 = reshape(cat(N+1, combs{:}), [], N);
    else
        x0=rand(M,N);        
    end

    if (plt && N==3)
        figure(99)
        scatter3(x0(:,1),x0(:,2),x0(:,3),30,'MarkerEdgeColor','k','MarkerFaceColor','r')
        axis equal; axis([0,1,0,1,0,1]); box on
        xlabel('$x^1$','Interpreter','latex'); ylabel('$x^2$','Interpreter','latex'); zlabel('$x^3$','Interpreter','latex');
        error('... check plot on agent initial position')
    end

else

    error(strcat('... no initialization available for #dimensions = ',num2str(N)))

end

end