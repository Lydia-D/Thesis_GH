function plotplane(plane,figurehandle)

    % plane = [A B C D] coefficents for Ax+By+Cz+D=0
    
    [x y] = meshgrid(-1:0.1:1);
    figure(figurehandle);
    hold on
    for i = 1:size(plane,1)
        z = -1/plane(i,3)*(plane(i,1)*x + plane(i,2)*y + plane(i,4));
        surf(x,y,z);
    end
    
    
end