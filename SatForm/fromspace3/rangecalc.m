% vectorised to calculate 
% input PosSat = [xrow;yrow;zrow] at time t for all sats in range
%       PosVar = [x0;y0;z0] current itteration 

function r = rangecalc(PosSat,PosVar)

    r = sqrt((PosSat(1,:) - PosVar(1)).^2+...
        (PosSat(2,:) - PosVar(2)).^2+...
        (PosSat(3,:) - PosVar(3)).^2);
    r = r'; % column vector of ranges
    
end
    


    
    
    
    
    
    
    
    