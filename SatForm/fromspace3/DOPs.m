%% caluclate the dilution of precisions

function DOP = DOPs(H)

    V = inv(H'*H);
    Vdiag = diag(V);    

    DOP.GDOP = sqrt(sum(Vdiag.^2));
    DOP.PDOP = sqrt(sum(Vdiag(1:3).^2));
    DOP.HDOP = sqrt(sum(Vdiag(1:2).^2));
    DOP.VDOP = Vdiag(3);
    DOP.TDOP = Vdiag(4);
    
    %DOP = [GDOP,PDOP,HDOP,VDOP,TDOP]';
end