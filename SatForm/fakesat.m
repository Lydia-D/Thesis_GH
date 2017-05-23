%% Set configuration of satellites
% L Drabsch
% 23/5/17

% use NED frame to create configuration then convert to 

% have set configurations:
% create a cluster of 4 sats:
%   - have a dispersion factor
%   - have an offset factor in elevation

%%
el = deg2rad([75,85,85,75]);
az = [0,0,pi,pi];
[x,y] = polar2plot(az,el);
polarfig = PolarPlot();
hold on
scatter(x,y)

Sat_ECEF = sat_ned2ecef(el,az,Rec_LLH);


