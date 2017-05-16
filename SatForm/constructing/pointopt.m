function pointopt(avg_norm,Omega)

    % avg_norm is a matrix of normal vectors numSat by x,y,z
    % Omega = matrix of distances from alpha (numRec-1) by numSat
    
    % make matrix of planes for each receiver
    % eg: P(beta) = [A B C D (sat1); A B C D (sat2)];
    % all ABC will be the same for all P(omega)-> avg_norm
    %[numRec,numSat] = size(Omega);
    for irec = 1:size(Omega,1)
        P = [avg_norm,Omega(irec,:)'];
        [U,S,V]=svd(P);
        
    end
    
    

end