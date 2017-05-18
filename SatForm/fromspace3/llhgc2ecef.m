%% function 'llh_geocentric2ecef'
%
% Transforms coordinates in Geocentric LLH to coordinates in ECEF
% Geocentric LLH: Geocentric Latitude, Longitude, Height Frame
% ECEF: Earth Centered Earth Fixed Frame
%
% Input  : [lat,long,h]'
% Output : [x,y,z]'
%
% Kelvin Hsu
% AERO4701, 2016

function Pos_ECEF = llhgc2ecef(X_LLHGC)
    % Earth's radius
    global r_earth;
    
    Pos_ECEF(1,:) = (X_LLHGC(3,:)+r_earth).*cos(X_LLHGC(1,:)).*cos(X_LLHGC(2,:)); % x
    Pos_ECEF(2,:) = (X_LLHGC(3,:)+r_earth).*cos(X_LLHGC(1,:)).*sin(X_LLHGC(2,:)); % y
    Pos_ECEF(3,:) = (X_LLHGC(3,:)+r_earth).*sin(X_LLHGC(1,:));           % z
    
    
end