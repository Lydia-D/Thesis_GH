%% L Drabsch
% 18/5/17
% solve for all variables at once ->

function [Loc_lin,clockbias] = planarsolve(range_com,Sat_com,numRec, GS_ECEF)
% range_com = pseudoranges at common epoch 
%       (already accounted for clockbias, rotation of earth, )
%       -> matrix m receivers by n satellites
% Sat_com = location of satellites in ECEF frame n by [x,y,z] at common
% epoch
% Abs_com = location of receivers as calculated in ECEF frame m x [x,y,z]

    numSat = size(Sat_com,2);

%% calculate normal vectors from approximate location to each satellite
    
    avg_norm = normalise(Sat_com-GS_ECEF*ones(1,numSat));
    

%% calculate difference in ranges between each recevier for each sat
    % columns = each satellite: rows = between each receiver
    all_RHO = []; 
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
    % all ABC will be the same for all P(o mega)-> avg_norm
    Loc_svd = [];
    %invP = inv(avg_norm'*avg_norm)*avg_norm';
    planes = zeros(size(Omega,1));
    offset = 0;
    
    N = [avg_norm',ones(numSat,1)]; % numSats by 4
    
    
    % solve for [xalpha;yalpha;zalpha;b_alpha;xbeta...] PX=D
    % individual planes + alpha plane intersection but with clockbias linked
    BIG = zeros(numSat*numRec,4*numRec);
    BIG(:,4) = -1*ones(size(BIG,1),1);
    for irec = 1:numRec
        BIG(1+(irec-1)*numSat:irec*numSat,1+(irec-1)*4:(irec)*4) = N;
    end
        
    pinv = inv((BIG'*BIG))*BIG';
    
    for irec = 1:numRec-1
        D(1+(irec-1)*numSat:irec*numSat,1) = Omega(irec,:);
    end
    d = [zeros(numSat,1);D];
    
    
    ALL_ans = pinv*d;
%     for irec = 1:numRec-1
%         P = [avg_norm,Omega(irec,:)'];
%         BIG = 
%         %[U,S,V]=svd(P);
%         %Loc_svd(irec,:) = V(:,end)';
%         %Loc_lin(irec,:) = invP*Omega(irec,:)';
%     end
    
    %Loc_lin=ALL_ans;
    ALL_ans = reshape(ALL_ans,[4,numRec]);
    clockbias = ALL_ans(4,:);
    Loc_lin = ALL_ans(1:3,:)';


end