%% function 'ecef2llh_geocentric'
%
% Transforms coordinates in ECEF to Geocentric LLH
% ECEF: Earth Centered Earth Fixed Frame
% Geocentric LLH: Geocentric Longitude, Latitude, Height Frame
%
% Inputs:   ->  X_ECEF           = [x, y, z]' in ECEF frame
% Outputs:  ->  X_LLH_GC         = [lat, lon, h]' in geocentric LLH
%
%% Edited by Lydia Drabsch 6/3/16 
% 28/4/16 3D
function X_LLHGC = ecef2llhgc3D(X_ECEF)

    global r_earth;     % Earth's radius

    hormag = sqrt(X_ECEF(1,:,:).^2+X_ECEF(2,:,:).^2); % horizontal magnitude
    mag = sqrt(X_ECEF(1,:,:).^2+X_ECEF(2,:,:).^2 + X_ECEF(3,:,:).^2);   
    
    X_LLHGC(1,:,:) = atan2d(X_ECEF(3,:,:),hormag);  % latitude
    X_LLHGC(2,:,:) = atan2d(X_ECEF(2,:,:),X_ECEF(1,:,:));          % longitude
    X_LLHGC(3,:,:) = mag-r_earth;               % height
end