%% Function that calculates ECEF and ECI coords
% L Drabsch 11/4/16

% Input: ClassPara = [Rasc;omega;inc;a;e;M0,t0];
%        t   = current time   column vec?

% have multiple time/multiple sats?.

function [X_ECI,X_ECEF,X_LLHGC] = keplerorbit3D(ClassPara,t,T_equ)
        
        numofSats = size(ClassPara,2);
        

        global mu_earth

        Rasc = ClassPara(1,:);
        omega = ClassPara(2,:);
        inc = ClassPara(3,:);
        a = ClassPara(4,:);
        e = ClassPara(5,:);
        M0 = ClassPara(6,:);
        t0 = ClassPara(7,:);
        
        % calculate n and p
        n = sqrt(mu_earth./a.^3);  % mean motion
        p = a.*(1-e.^2);% semilatus rectum
        
        Mt = ones(length(t),1)*M0 + ones(length(t),1)*n.*(t*ones(1,numofSats)-ones(length(t),1)*t0);
        % solve kepler equation
        E = newtown(Mt,e);

        % solve for theta (true anomaly) using eccentric anomaly
        theta = 2.*atan2(sqrt(1+ones(length(t),1)*e)./sqrt(1-ones(length(t),1)*e).*sin(E/2),cos(E/2));

        % solve for r
        r = ones(length(t),1)*p./(1+ones(length(t),1)*e.*cos(theta));

        % resolve in state space in the perifocal frame 
        % X = [x,y,z,vx,vy,vz]' not partially dependent on time
        X_orbit(1,:,:) = r.*cos(theta);
        X_orbit(2,:,:) = r.*sin(theta);
        X_orbit(3,:,:) = zeros(size(theta));
        X_orbit(4,:,:) = -sqrt(mu_earth./ones(length(t),1)*p).*sin(theta);
        X_orbit(5,:,:) = sqrt(mu_earth./ones(length(t),1)*p).*(ones(length(t),1)*e+cos(theta));
        X_orbit(6,:,:) = zeros(size(theta));
            
        
        % transform to ECI 
        X_ECI = orbit2ECI3D(X_orbit,Rasc,inc,omega);
%         X_ECItest = orbit2ECI(reshape(X_orbit(:,1,:),[6,31]),Rasc,inc,omega);
        
        % transform to ECEF
        X_ECEF = eci2ecef3D(X_ECI(1:3,:,:),t-T_equ); % only position
%         X_ECEFtest = eci2ecef(X_ECItest,t(1));
        
        X_LLHGC = ecef2llhgc3D(X_ECEF);
        
end




