%% function 'ecef2eci'
%
% Transforms coordinates in ECEF to coordinates in ECI
% ECEF: Earth Centered Earth Fixed Frame
% ECI : Earth Centered Inertial Frame
%
% Input  : pos_ecef = [x; y; z] | ECEF                     [m]
%          times    = times since vernal equinox alignment [s]
% Output : pos_eci  = [x; y; z] | ECI                      [m]
%
% Kelvin Hsu
% AERO4701, 2016
%% Edited 29/2/16 by Lydia Drabsch
% Notes: assume z axes for both ECEF and ECI are the same direction
function pos_eci = ecef2eci(pos_ecef, times)

    % This is the rotation rate of Earth (rad/s)
    global w_earth;  
    pos_eci(1,:) = cos(w_earth.*times).*pos_ecef(1,:) - sin(w_earth.*times).*pos_ecef(2,:);
    pos_eci(2,:) =  sin(w_earth.*times).*pos_ecef(1,:) + cos(w_earth.*times).*pos_ecef(2,:);
    pos_eci(3,:) = pos_ecef(3,:);
    

end