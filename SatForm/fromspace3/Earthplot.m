% Function to plot earth
% By Lydia Drabsch adapted from PlotEarthSphere.m (Bryson, 2007)

function fighandle=Earthplot()
    global Nasa_A
    global r_earth

    fighandle = figure;
    % Create a sphere, make it earth sized (in meters)
    [x,y,z] = sphere(50);
    x = x.*r_earth;
    y = y.*r_earth;
    z = -z.*r_earth;

    props.FaceColor= 'texture';
    props.EdgeColor = 'none';
    props.FaceLighting = 'phong';
    props.Cdata = Nasa_A;

    % Plot Earth
    axes('dataaspectratio',[1 1 1],'visible','on')
    hold on
    grid on
    surface(x,y,z,props);
end