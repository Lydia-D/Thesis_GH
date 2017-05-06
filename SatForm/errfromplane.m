function [rtot,r] = errfromplane(plane,point)

    % plane [a,b,c,d]
    % point [x,y,z]
    r = sum(plane.*[point,-1],2); % vector of residuals
    rtot = sum(r);
    

end