%% L Drabsch
% 15/5/17

function [Loc_lin,Omega,avg_norm] = distopt(range_com,Sat_com, Abs_com)
% range_com = pseudoranges at common epoch 
%       (already accounted for clockbias, rotation of earth, )
%       -> matrix m receivers by n satellites
% Sat_com = location of satellites in ECEF frame n by [x,y,z] at common
% epoch
% Abs_com = location of receivers as calculated in ECEF frame m x [x,y,z]

%% calculate normal vectors from each recevier to each satellite
% & calculate average normal vector for each satellite
% 3D matrix? - need to average across 
% for vector from receiver to satellite-> sat-rec
    numSat = size(Sat_com,1);
    numRec = size(Abs_com,1);
    all_norm_vecs = zeros([numRec,3,numSat]);
    for isat = 1:numSat
        temp = repmat(Sat_com(isat,:),[numRec,1])-Abs_com;
        all_norm_vecs(:,:,isat) = normalise(temp);
        avg_norm(isat,:) = mean(all_norm_vecs(:,:,isat),1);
    end


%% calculate difference in ranges between each recevier for each sat
    all_RHO = []; % columns = each satellite: rows = between each receiver
    for i=1:(numRec-1)
        all_RHO = [all_RHO;range_com(i+1:end,:)-ones(numRec-i,1)*range_com(i,:)];
    end


%% construct Phi matrix -> only fn of num_Rec-> same Phi for all Omega_s

    Phi = zeros(size(all_RHO,1),numRec-1);
    %Phi(1:numRec-1,1:numRec-1) = eye(numRec-1);
    offset = 1;
    for i = 1:numRec-1
        Phi(offset:offset+numRec-i-1,i:end) = -1*eye(numRec-i);
        if i>1
           Phi(offset:offset+numRec-i-1,i-1) = ones(numRec-i,1);
        end
        offset = offset + numRec-i;
    end
    

%% Solve for Omega_s for all s

    % calculate pseudoinverse:
    invPhi = inv(Phi'*Phi)*Phi';
    % distances from alpha along each normal vector numRec-1 by numSat
    Omega = zeros(numRec-1,numSat);
    for isat=1:numSat
        Omega(:,isat) = invPhi*all_RHO(:,isat);
    end
   
%% Make Planes and solve for intersection
    % avg_norm is a matrix of normal vectors numSat by x,y,z
    % Omega = matrix of distances from alpha (numRec-1) by numSat
    
    % make matrix of planes for each receiver
    % eg: P(beta) = [A B C D (sat1); A B C D (sat2)];
    % all ABC will be the same for all P(omega)-> avg_norm
    Loc_svd = [];
    invP = inv(avg_norm'*avg_norm)*avg_norm';
    for irec = 1:numRec-1
        %P = [avg_norm,Omega(irec,:)'];
        %[U,S,V]=svd(P);
        %Loc_svd(irec,:) = V(:,end)';
        Loc_lin(irec,:) = invP*Omega(irec,:)';
    end
    
    


end