%% function 'eci2ecef'
% can have multiple time for single position or multiple positions for
% single time
% Transforms coordinates in ECI to coordinates in ECEF
% ECI : Earth Centered Inertial Frame
% ECEF: Earth Centered Earth Fixed Frame
%
% Input  : pos_eci  = [x; y; z] | ECI                      [m]
%          times    = times since vernal equinox alignment [s]
% Output : pos_ecef = [x; y; z] | ECEF                     [m]
%
% 

function pos_ecef = eci2ecef3D(pos_eci, times)

    % This is the rotation rate of Earth (rad/s)
    global w_earth;

    timesM(1,:,:) = times*ones(1,size(pos_eci,3));
    
    pos_ecef(1,:,:) = cos(w_earth.*timesM).*pos_eci(1,:,:) + sin(w_earth.*timesM).*pos_eci(2,:,:);
    pos_ecef(2,:,:) = - sin(w_earth.*timesM).*pos_eci(1,:,:) + cos(w_earth.*timesM).*pos_eci(2,:,:);
    pos_ecef(3,:,:) = pos_eci(3,:,:);
    

end