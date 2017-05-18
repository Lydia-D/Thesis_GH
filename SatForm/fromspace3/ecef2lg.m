%% function 'ecef2lg'
%
% Transforms coordinates in ECEF to coordinates in LG
% ECEF: Earth Centered Earth Fixed Frame
% LG  : Local Geocentric Vertical Frame OR Local Geodetic Vertical Frame
%
% Inputs:   ->  Sat_ECEF                  = [x, y, z]' in ECEF frame
%           ->  Obv_LLH                     = [lat, lon, h]'|Observer Centric
%
% Outputs:  ->  Pos_LG                    = [N, E, D]' in LGV frame
%
% Kelvin Hsu
% AERO4701, 2016
%% Edited by Lydia Drabsch 5/3/16
% 1) convert observer Obs_LLH to Obs_ECEF
% 2) find vector pointing from observer to satellite Pos_ECEF=Sat_ECEF-Obs_ECEF
% 3) convert Obs_ECEF to polar coordinates [phi,theta,R]' ?? can just use
% long lat?
% 4) rotate Pos_ECEF using fixed angles about z by phi (Rz) then about y by -(pi-theta) (Ry) 
function Vec_LG = ecef2lg(Vec_ECEF, Obs_LLH)
    
%     Vec_LG = rot('y',Obs_LLH(1,1)))*rot('z',Obs_LLH(2,1))*Vec_ECEF; 
    lambda = Obs_LLH(1,:);
    psi = Obs_LLH(2,:);
    N = -sin(lambda).*cos(psi).*Vec_ECEF(1,:) - sin(lambda).*sin(psi).*Vec_ECEF(2,:) + cos(lambda).*Vec_ECEF(3,:);
    E = -sin(psi).*Vec_ECEF(1,:) + cos(psi).*Vec_ECEF(2,:);
    D = -cos(lambda).*cos(psi).*Vec_ECEF(1,:) - cos(lambda).*sin(psi).*Vec_ECEF(2,:) - sin(lambda).*Vec_ECEF(3,:);
    
    Vec_LG = [N;E;D];
end