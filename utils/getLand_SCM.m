
% ---------------------------------------------------------------- purpose
% create artificial Landscape functions in analytical or numerical form,
% all bounded in [0,1]. Compute symbolic derivatives also
% ---------------------------------------------------------------- input
% dim: number of problem dimensions
% por: object collecting different case parameters
% landname: string with the name of the landscape function
% str: string to set the problem as a maximization or minimization procedure
% ---------------------------------------------------------------- output
% Land: function handle with the chosen landscape
% dLand: function handle with the derivatives of the chosen landscape
% limLand: bounds of the assigned landscape
% target: true location of the global optimum
% ----------------------------------------------------------------

function [Land,dLand,limLand,target,por]=getLand_SCM(dim,landname,por,str)

por.Lan=true(1);

% Landscape selection; assign symbolic/numeric landscape function and target
[Land,target]=LandDef(dim,landname,str);


% compute symbolic derivatives of landscape function and store them in a cell array
if (isequal(landname,'fractal'))
    por.Lan=false(1); 
    dLand=0;
else
    xs = sym('x',[1 dim]);
    dLand=cell(dim,1);
    for i=1:dim
        deriv = diff(Land(xs),xs(i),1);
        dLand{i} = matlabFunction(deriv,'Vars',xs);
    end
end

limLand=[0,1];


% prescribe potential barriers by means of a conical surface
por.cang=20;
por.H=-0.5;
por.Z0=1;


% %% debug plot
% x=linspace(0,1,N);
% y=x;
% [X,Y]=meshgrid(x,y);
% 
% x2=-0.5:1/10:1.5;  % create conical surface
% y2=x2;
% [X2,Y2]=meshgrid(x2,y2);
% Z= por.Z0+por.H.*sqrt((X2-1/2).^2+(Y2-1/2).^2)*cot(por.cang*pi/180);
% 
% figure(2)
% if (por.Lan)
% surf(X,Y,Land(X,Y)); hold on
% else
% C=zeros(size(X2));
% surf(X2,Y2,Z,C,'EdgeColor','none')
% end
% shading interp
% xlabel('x'); ylabel('y');
% colorbar
% % axis equal
% view(2)
% error('debug break')

end




