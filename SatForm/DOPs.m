%% caluclate the dilution of precisions

function DOP = DOPs(H)

    V = inv(H'*H);
    Vdiag = diag(V);    

    GDOP = sqrt(sum(Vdiag.^2));
    PDOP = sqrt(sum(Vdiag(1:3).^2));
    HDOP = sqrt(sum(Vdiag(1:2).^2));
    VDOP = Vdiag(3);
    TDOP = Vdiag(4);
    
    DOP = [GDOP,PDOP,HDOP,VDOP,TDOP]';
end