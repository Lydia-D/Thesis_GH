%% L Drabsch
% 21/5/17
% transform from ecef to local trangental plane (NED) using the llh
% geocentric model then to polar coordinates

% use approximate location

function [Sat_LG_pol,Sat_LG_cart] = ecef2lg_pol(X_ECEF,GS_LLH)
 
    GS_ECEF = llhgc2ecef(GS_LLH); 

    Sat_ECEF_local = X_ECEF-GS_ECEF*ones(1,size(X_ECEF,2)); %all time - gs
    
    Sat_LG_cart = ecef2lg(Sat_ECEF_local,GS_LLH);  %North East Down
    
    Sat_LG_pol = cartesian2polar(Sat_LG_cart);
    
end