%% NLLS jacobian convergance
% L Drabsch 4/4/16
% 
% Inputs: PosSat = [xrow;yrow;zrow] at time t for all sats in range
%         X0 = [x0;y0;z0] current itteration 
%         Rsat = column vector of real ranges from satellites
% Outputs: 
%% 
function [Loc,X,DOP,clockbias] = convergance(X0,PosSat,Rsat)
    % weighted 
    W = eye(size(PosSat,4)); % something to do with dilution of precision?
   
    % initialise X0 (gnd station location or previous time step position)
    X = X0;
    dX = Inf;    
    maxiterations = 100;
    iter = 0;
        % while convergance
        
    while max(abs(dX)) > 10^-8 
        H = Jacobian(PosSat,X);
        drho = Rsat - (rangecalc(PosSat,X(1:3))+X(4)); % error in range
%         dX = (H'*W*H)\H'*W*drho; % minimise
        dX = (H'*H)\H'*drho;
        X = X+dX;   % update new X 
        if iter > maxiterations
            break
        else
            iter = iter+1;
        end
    end
    
    %% DOPs
    DOP = DOPs(H);
    clockbias = X(4);
    Loc = X(1:3);
end