
% ---------------------------------------------------------------- purpose
% pick the selected landscape function
% ---------------------------------------------------------------- input
% dim: number of problem dimensions
% landname: string with the name of the chosen landscape function
% str: string to choose between a maximization and a minimization setting
% ---------------------------------------------------------------- output
% Land: function handle with the assigned landscape
% target [dim]: location of the true global optimum 
% ---------------------------------------------------------------- 

function [Land,target]=LandDef(dim,landname,str)

switch landname

    case 'Ackley'

        maxloc=0.07;
        minloc=0.6;
        L = @(x) - 20.*exp(-0.2*sqrt(1/dim*( sum((10.*x-6).^2) ))) - ...
                       exp(1/dim*sum( cos(pi.*(10.*x-6)) ));        
        target=minloc.*ones(1,dim);
                
    case 'Rastrigin'

        maxloc=0.089;
        minloc=0.6;
        L = @(x) sum( (10.*x-6).^2-10.*cos(pi.*(10.*x-6)) );
        target=minloc.*ones(1,dim);

    case 'Schwefel' 

        minloc=0.7300;
        maxloc=0.8920;
        L = @(x) sum( (1225.*x).*sin(sqrt(abs(1225.*x))) );        
        target=minloc.*ones(1,dim);
        
    case 'Griewank'
        
        a=0.1;    b=25;       c=0.38;
        minloc=c;
        maxloc=0.92;
        L = @(x) sum( (x-c).^2 ) - ...
                 a.*prod( cos( ((x-c).*b)./sqrt((1:length(x))) ) );
        target=minloc.*ones(1,dim);
                
    case 'Styblinski'

        minloc=0.211;
        maxloc=1;
        L = @(x) sum( (10.*x-5).^4 - 16.*(10.*x-5).^2 + 5.*(10.*x-5) )/2;
        target=minloc.*ones(1,dim);
                
    case 'fractal'

        if (dim~=2)
            error('... the fractal function is defined in the 2D space only')
        end

        global Xfr Yfr Zfr
        load('../utils/fractal_surf.mat')        
        
    otherwise
        error('... landscape function not implemented')

end


if (isequal(str,'maximize'))
    if (isequal(landname,'fractal'))
        Land = @funval;
    else
        Land = @(x) -(L(x) - L(maxloc.*ones(1,dim)))./( L(maxloc.*ones(1,dim)) - L(minloc.*ones(1,dim)) ) ;
        % Land = @(x) -L(x);
    end
elseif (isequal(str,'minimize'))
    if (isequal(landname,'fractal'))
        Zfr = -Zfr;
        Land = @funval;
    else
        Land = @(x) (L(x) - L(maxloc.*ones(1,dim)))./( L(maxloc.*ones(1,dim)) - L(minloc.*ones(1,dim)) ) ;
    end
end

end