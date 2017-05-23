% polar plot   polar(theta,rho) where theta is azmuth and rho is elevation
% in degreeds

function fighandle = PolarPlot()
    d_el = 15;
    d_spk = 30;
    grey    = 0.65*[1 1 1];

    angle       = linspace(0,2*pi,150);
    unitC.x     = cos(angle);
    unitC.y     = sin(angle);

    % General setup
    nCirc       = 90/d_el;                  % No. of circles
    rUnit       = linspace(0, 1, nCirc+1);      % Circle radii
    elLabAngle  = 45 * pi/180;              % Elevation label spread angle
    elLab       = [90:-d_el:0];             % Elevation label

    %% Plot spoke lines
    fighandle = figure;
    hold all
    azAngles  = [180:-d_spk: 0];
    azLab.textup = [270:d_spk:360-d_spk, 0:d_spk:90]; % from left to right
    azLab.textdown = [270:-d_spk:90]; % from left to right
    azLab.x = 1.05*cosd(azAngles);
    azLab.y = 1.05*sind(azAngles);

    nSpk  = length(azAngles);
    for i = 1:nSpk
       plot([0,cosd(azAngles(i))],[0,sind(azAngles(i))],'color', grey);
       plot([0,cosd(azAngles(i))],[0,-sind(azAngles(i))],'color', grey);

       text(azLab.x(i),azLab.y(i),[num2str(azLab.textup(i)) '^{\circ}'],'HorizontalAlignment','center','VerticalAlignment','middle')
       if ~(i == 1 || i == nSpk)
            text(azLab.x(i),-azLab.y(i),[num2str(azLab.textdown(i)) '^{\circ}'],'HorizontalAlignment','center','VerticalAlignment','middle')
       end
    end

    %% Plot circles

    for i = 1:nCirc+1
        plot(rUnit(i)*unitC.x, rUnit(i)*unitC.y, 'color', grey);
        text((rUnit(i)+0.05)*cos(elLabAngle), (rUnit(i))*sin(elLabAngle), ...
                [num2str(elLab(i)) '^{\circ}'],'HorizontalAlignment','center','VerticalAlignment','middle');
    end

    %% Plot cardinal directions
    text(0,      1+0.15, 'North','HorizontalAlignment','center');
    text(0,     -1-0.15, 'South','HorizontalAlignment','center');
    text(-1-0.15, 0,     'West','HorizontalAlignment','Right');
    text(1+0.15,  0,     'East','HorizontalAlignment','Left');

    axis square
    set(gca, 'visible', 'off')
    set(gcf, 'Color', 0.95*[1 1 1])
end