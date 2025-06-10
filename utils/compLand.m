
% evaluate value and derivative of a 2D numerical Landscape function

function [Vj,dV]=compLand(X,Y,V,dim,xa,par,aod)

x=X(1,:);
y=Y(:,1);
dx=x(2);

Vj=zeros(par.M,1);
dV=zeros(par.M,dim);

for j=1:par.M

    if (aod(j)) % agent outside the domain; assign a conic (analytical) landscape function 
    
        Vj(j)=0;    % assign zero when out of the domain; it affects the consensus calculations
        dV(j,:)=par.H*cot(par.cang*pi/180)*(xa(j,:)-1/2)./norm(xa(j,:)-1/2,2);        
    
    else        % agent inside the domain
    
        Vj(j)=interp2(X,Y,V,xa(j,1),xa(j,2));
        ids=find(x>=xa(j,1));     ix=ids(1);
        ids=find(y>=xa(j,2));     iy=ids(1);
        dV(j,1)=(V(iy,ix)-V(iy,ix-1))/dx;    
        dV(j,2)=(V(iy,ix)-V(iy-1,ix))/dx;
    
    end

end

end