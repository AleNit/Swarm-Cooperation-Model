
% ---------------------------------------------------------------- purpose
% evaluate error w.r.t. two-dimensional numerically-generated 
% landscape functions
% ---------------------------------------------------------------- input
% xy [2,1]: query point
% ---------------------------------------------------------------- output
% err: cost function error at the xy query point
% ----------------------------------------------------------------

function err = funval(xy)

global Xfr Yfr Zfr

xquery = xy(1);
yquery = xy(2);
zquery = interp2(Xfr,Yfr,Zfr,xquery,yquery);

err =  zquery - min(Zfr(:));

end