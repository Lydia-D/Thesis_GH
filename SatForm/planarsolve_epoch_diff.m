%% L Drabsch
% 18/5/17
% solve for all variables at once ->
% updated 6/6/2017 for no distance optimisation


function [Loc_lin,clockbias] = planarsolve_epoch_diff(range_com,X_ECEF_meas_vis,numRec,numSat, GS_ECEF)
    global c

% range_com = pseudoranges at common epoch 
%       (already accounted for clockbias, rotation of earth, )
%       -> matrix m receivers by n satellites
% Sat_com = location of satellites in ECEF frame n by [x,y,z] at common
% epoch
% Abs_com = location of receivers as calculated in ECEF frame m x [x,y,z]


%% calculate normal vectors from approximate location to each satellite
    % in ecef frame
    avg_norm = normalise(squeeze(X_ECEF_meas_vis(:,1,:))-GS_ECEF*ones(1,numSat));
    

%% calculate difference in ranges between each recevier for each sat
    % columns = each satellite: rows = between each receiver
%     all_RHO = []; 
%     for i=1:(numRec-1)
%         all_RHO = [all_RHO;range_com(i+1:end,:)-ones(numRec-i,1)*range_com(i,:)];
%     end

    
    
    
    for k = 1:numSat
        all_RHO{k} = [];
    end
    
    for fromrec = 1:(numRec-1)
        for torec = fromrec+1:numRec
            for isat = 1:numSat
            % transform torec to time at fromrec
            % know location of sats
            trans_s = (X_ECEF_meas_vis(:,fromrec,isat)- X_ECEF_meas_vis(:,torec,isat));
            trans_p = -dot(avg_norm(:,isat),trans_s);
            %trans_p = 0;
            diffp = range_com(torec,isat) - (range_com(fromrec,isat)+trans_p);
            all_RHO{isat} = [all_RHO{isat};diffp];
            end
        end
    end
    

   
    %% dont optimise
    %Omega = -all_RHO(1:numRec-1,:);
    Omega = -[all_RHO{:}]';
    % plot planes
%     Planes = [avg_norm',Omega'];
%    plotplane(Planes,3) % ecef local frame?
    
    
%% Make Planes and solve for intersection
    % avg_norm is a matrix of normal vectors numSat by x,y,z
    % Omega = matrix of distances from alpha (numRec-1) by numSat
    
    % make matrix of planes for each receiver
    % eg: P(beta) = [A B C D (sat1); A B C D (sat2)];
    % all ABC will be the same for all P(o mega)-> avg_norm
    %invP = inv(avg_norm'*avg_norm)*avg_norm';
    %planes = zeros(size(Omega,1));
    offset = 0;
    
    N = [avg_norm',ones(numSat,1)]; % numSats by 4

    
    % solve for [xalpha;yalpha;zalpha;b_alpha;xbeta...] PX=D
    % individual planes + alpha plane intersection but with clockbias linked
    BIG = zeros(numSat*numRec,4*numRec);
    BIG(:,1:4) = -1*repmat(N(:,1:4),[numRec,1]);
   
    for irec = 1:numRec
        BIG(1+(irec-1)*numSat:irec*numSat,1+(irec-1)*4:(irec)*4) = N;
    end
        
    pinv = inv((BIG'*BIG))*BIG';
    
    for irec = 1:numRec-1
        D(1+(irec-1)*numSat:irec*numSat,1) = Omega;
    end
    d = [zeros(numSat,1);D];
    
    
    ALL_ans = pinv*d;

    
    %Loc_lin=ALL_ans;
    ALL_ans = reshape(ALL_ans,[4,numRec]);
    clockbias = ALL_ans(4,:);
    Loc_lin = ALL_ans(1:3,:);



end