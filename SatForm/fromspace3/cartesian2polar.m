%% function 'cartesian2polar'
%
% Transforms coordinates in cartesian coordinates [x, y, z]' 
% into polar coordinates [R, az, el]'
%
% Input  : pos_cartesian = [x,  y,  z]' in cartesian coordinates [m, m, m]
% Output : pos_polar     = [R, az, el]' in polar coordinates [m, rad, rad]
%
%% Edited 29/2/16 by Lydia Drabsch
% Notes: z points down, elevation defined as positive upwards from horizon
%       euler angles, radians

function pos_polar = cartesian2polar(pos_cart)
    magnitude = sqrt(pos_cart(1,:).^2+pos_cart(2,:).^2+pos_cart(3,:).^2);
    anglemag = sqrt(pos_cart(1,:).^2+pos_cart(2,:).^2);
    pos_polar(1,:) = magnitude;
    pos_polar(2,:) = atan2(pos_cart(2,:),pos_cart(1,:));
    pos_polar(3,:) = atan2(-pos_cart(3,:),anglemag);

end