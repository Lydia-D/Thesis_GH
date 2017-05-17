%% by Lydia Drabsch 13/3/16
% function to convert states from orbit coordinates to ECI coordinates
% inputs: X_orbit = [x,y,z,vx,vy,vz]' in orbit frame
%           Rasc = right ascentionn of the ascending node in radians
%           i = inclination angle in radians
%           omega = argument of perigee in radians
% NOTE: doesnt work with only 1 sat or 1 time? - use orbit2ECI fn

function X_ECI = orbit2ECI3D(X_orbit,Rasc,inc,omega)
    
    RascM(1,:,:) = ones(size(X_orbit,2),1)*Rasc;
    incM(1,:,:) = ones(size(X_orbit,2),1)*inc;
    omegaM(1,:,:) = ones(size(X_orbit,2),1)*omega;


    X_ECI(1,:,:) =  (cos(RascM).*cos(omegaM)-sin(RascM).*sin(omegaM).*cos(incM)).*X_orbit(1,:,:) +(-cos(RascM).*sin(omegaM)-sin(RascM).*cos(omegaM).*cos(incM)).*X_orbit(2,:,:) + sin(RascM).*sin(incM).*X_orbit(3,:,:);
    X_ECI(2,:,:) = (sin(RascM).*cos(omegaM)+cos(RascM).*sin(omegaM).*cos(incM)).*X_orbit(1,:,:) + (-sin(RascM).*sin(omegaM)+cos(RascM).*cos(omegaM).*cos(incM)).*X_orbit(2,:,:) -cos(RascM).*sin(incM).*X_orbit(3,:,:);
    X_ECI(3,:,:) = sin(omegaM).*sin(incM).*X_orbit(1,:,:) + cos(omegaM).*sin(incM).*X_orbit(2,:,:) + cos(incM).*X_orbit(3,:,:);

%     X_ECI(4,:,:) =  (cos(RascM).*cos(omegaM)-sin(RascM).*sin(omegaM).*cos(incM)).*X_orbit(4,:,:) +(-cos(RascM).*sin(omegaM)-sin(RascM).*cos(omegaM).*cos(incM)).*X_orbit(5,:,:) + sin(RascM).*sin(incM).*X_orbit(6,:,:);
%     X_ECI(5,:,:) = (sin(RascM).*cos(omegaM)+cos(RascM).*sin(omegaM).*cos(incM)).*X_orbit(4,:,:) + (-sin(RascM).*sin(omegaM)+cos(RascM).*cos(omegaM).*cos(incM)).*X_orbit(5,:,:) -cos(RascM).*sin(incM).*X_orbit(6,:,:);
%     X_ECI(6,:,:) = sin(omegaM).*sin(incM).*X_orbit(4,:,:) + cos(omegaM).*sin(incM).*X_orbit(5,:,:) + cos(incM).*X_orbit(6,:,:);               
               
end

