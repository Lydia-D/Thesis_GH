%% L Drabsch
% 18/5/17
% solve for all variables at once ->

function [Loc_lin,clockbias] = alloptimise_transepoch(range_com,Sat_com, Abs_com,X_ECEF_vis,numRec)
% range_com = pseudoranges at common epoch 
%       (already accounted for clockbias, rotation of earth, )
%       -> matrix m receivers by n satellites
% Sat_com = location of satellites in ECEF frame n by [x,y,z] at common
% epoch
% Abs_com = location of receivers as calculated in ECEF frame m x [x,y,z]

numSat = size(Sat_com,1);

%% calculate normal vectors from approximate location to each sat


    % Sat_com -> one timestep at 0
    avg_norm = normalise2(Sat_com-ones(numSat,1)*Abs_com(1,:));
    
    % just have one set of vectors from a rough location

%% calculate transform errors
    
    
%% calculate difference in ranges between each recevier for each sat
    %all_RHO = []; % columns = each satellite: rows = between each receiver
    
    for k = 1:numSat
        all_RHO{k} = [];
    end
    
    for fromrec = 1:(numRec-1)
        for torec = fromrec+1:numRec
            for isat = 1:numSat
            % transform torec to time at fromrec
            % know location of sats
            trans_s = (X_ECEF_vis(:,fromrec,isat)- X_ECEF_vis(:,torec,isat));
            trans_p = -dot(avg_norm(isat,:)',trans_s);
%             trans_p = 0;
            diffp = range_com(torec,isat) - (range_com(fromrec,isat)+trans_p);
            all_RHO{isat} = [all_RHO{isat};diffp];
            end
        end
    end
    
    
%     for i=1:(numRec-1)
%         all_RHO = [all_RHO;range_com(i+1:end,:)-ones(numRec-i,1)*range_com(i,:)];
%     end


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
        Omega(:,isat) = invPhi*all_RHO{isat};
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
    
    N = [avg_norm,ones(numSat,1)]; % numSats by 4
    
    
    % solve for [b_alpha;xbeta;ybeta;zbeta;b_beta;xgamma...]  PX=D
%     BIG = zeros(numSat*(numRec-1),4*(numRec-1)+1);
%     BIG(:,1) = -1*ones(size(BIG,1),1);
%     for irec = 1:numRec-1
%         BIG(1+(irec-1)*numSat:irec*numSat,2+(irec-1)*4:5+(irec-1)*4) = N;
%     end
    
    % solve for [xalpha;yalpha;zalpha;b_alpha;xbeta...]  PX=D
    % eta_x*(xbeta-xalpha)...
%     BIG = zeros(numSat*(numRec-1),4*numRec);
%     BIG(:,1:4) = -1*repmat(N,[numRec-1,1]);
%     for irec = 1:numRec-1
%         BIG(1+(irec-1)*numSat:irec*numSat,1+(irec)*4:(irec+1)*4) = N;
%     end
    
    % solve for [xalpha;yalpha;zalpha;b_alpha;xbeta...] PX=D
    % individual planes + alpha plane intersection but with clockbias linked
    BIG = zeros(numSat*(numRec-1),4*numRec);
    BIG(:,4) = -1*ones(size(BIG,1),1);
    for irec = 1:numRec
        BIG(1+(irec-1)*numSat:irec*numSat,1+(irec-1)*4:(irec)*4) = N;
    end
    
    % maybe do another itteration solving for D with the new clock biases
    
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