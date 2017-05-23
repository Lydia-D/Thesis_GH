%% function 'polar2cartesian'
% Transforms polar coordinates [R, az, el]' into
% cartesian coordinates [x, y, z]' 

% Input  : X_P     = [R, az, el]' in polar coordinates [m, rad, rad]
% Output : X_C = [x,  y,  z]' in cartesian coordinates [m, m, m]
%
% Kelvin Hsu
% AERO4701, 2016
%% Edited: Lydia Drabsch 6/3/16
function X_C = polar2cartesian(X_P)
    X_C(1,:) = X_P(1,:).*cos(X_P(3,:)).*cos(X_P(2,:));  % x
    X_C(2,:) = X_P(1,:).*cos(X_P(3,:)).*sin(X_P(2,:));  % y
    X_C(3,:) = -X_P(1,:).*sin(X_P(3,:));                % z

end