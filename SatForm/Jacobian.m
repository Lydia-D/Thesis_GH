
% input PosSat = [xrow;yrow;zrow] at time t for all sats in range
%       PosVar = [x0;y0;z0] current itteration 
function H = Jacobian(PosSat, PosVar)

    % column vectors of all sats
    rangeVar = rangecalc(PosSat,PosVar);
    df_dx = (PosVar(1)-PosSat(1,:)')./rangeVar;
    df_dy = (PosVar(2)-PosSat(2,:)')./rangeVar;
    df_dz = (PosVar(3)-PosSat(3,:)')./rangeVar;

    H = [df_dx,df_dy,df_dz,ones(length(df_dx),1)];
    
    
end

