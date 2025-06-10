
function [A,B,C]=get_triangle(par,xn,ts)

l=par.LL*ts;    % fixed value at the plot scale
at=75*pi/180;
A=[-l*cot(at),-l/2];
B=[l*cot(at),-l/2];
C=[0,l/2];
R=[cos(xn(3)),-sin(xn(3));sin(xn(3)),cos(xn(3))];
A=R*A'+xn(1:2)';
B=R*B'+xn(1:2)';
C=R*C'+xn(1:2)';

end
