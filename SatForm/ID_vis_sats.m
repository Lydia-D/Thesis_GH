%% L Drabsch
% Identify visible satellites for one timestep

function [VisibleSat,VisSat_LG] = ID_vis_sats(X_ECEF,GS_LLH)

% INPUT: X_ECEF of satellites-> 3 by n satellites
%        GS_LLH point on gs -> 3 by 1

   % Sat_LG_pol = ecef2lg_pol(X_ECEF,GS_LLH);
     GS_ECEF = llhgc2ecef(GS_LLH);
    Sat_ECEF_local = X_ECEF-GS_ECEF*ones(1,size(X_ECEF,2)); %all time - gs
    Sat_LG_cart = ecef2lg(Sat_ECEF_local,GS_LLH);  %North East Down
    Sat_LG_pol = cartesian2polar(Sat_LG_cart);
    
    % Store elevation data
    VisibleSat_index = Sat_LG_pol(3,:)>=deg2rad(10);
    VisibleSat = X_ECEF(:,VisibleSat_index);
    VisSat_LG = Sat_LG_pol(:,VisibleSat_index);


end