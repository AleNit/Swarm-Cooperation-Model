
% evaluate value and derivative of the Landscape function at the agent location

function [Vj,dVj]=compLand_an(dim,V,dV,xa,par,aod)

Vj=zeros(par.M,1);
dVj=zeros(par.M,dim);

for j=1:par.M

    if (aod(j)) % agent outside the domain; assign a conic landscape function 
    
        Vj(j)=0;    % assign zero when out of the domain; it affects the consensus calculations
        dVj(j,:)=par.H*cot(par.cang*pi/180)*(xa(j,:)-1/2)./norm(xa(j,:)-1/2,2);        
    
    else        % agent inside the domain

        Vj(j)=V(xa(j,:));
        for i=1:dim
            loc=num2cell(xa(j,:));
            dVj(j,i) = dV{i}(loc{:});
        end
            
    end

end

end
