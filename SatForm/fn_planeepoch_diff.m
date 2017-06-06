
function [error_alpha,clockbias,range_error] = fn_planeepoch_diff(GS_LLH,GS_ECEF,numSat,numRec,allRec,X_ECEF_meas_vis,Estruc,true_rel_alpha)
    global c


%% Calculate range and add errors

Sat_error = Estruc.satmag+ Estruc.satmag*10*rand([1,numSat]);
Rec_error = Estruc.recmag+ Estruc.recmag*10*rand([numRec,1]);
Rand_error = Estruc.random+Estruc.random*10*rand([numRec,numSat]);

for irec = 1:numRec
    for isat=1:numSat
       % trans_time = 
        range_inc_error = sqrt(sum((allRec(:,irec)-X_ECEF_meas_vis(:,irec,isat)).^2)) + Sat_error(isat)*c;
 %       range_inc_error = sqrt(sum((allRec(irec,:)'-X_ECEF_vis(:,irec,isat)).^2));
        range_error(irec,isat) = range_inc_error + Rec_error(irec) + Rand_error(irec,isat);
    end
end

%% Find Relative positions

[Loc_lin,clockbias] = planarsolve_epoch_diff(range_error,X_ECEF_meas_vis,numRec,numSat, GS_ECEF);

Receivers_LG = ecef2lg(Loc_lin,GS_LLH); % NED cartesion row is rec col is xyz
%Receivers_LG_NC = ecef2lg(Loc_lin_NC',GS_LLH); % NED cartesion row is rec col is xyz


Loc_plane = vectoradd(Receivers_LG(:,2:end),Receivers_LG(:,1),-1);

%Receivers_LG = ecef2lg(Loc_plane',GS_LLH); % NED cartesion row is rec col is xyz

%% Evaluate
error_alpha = Loc_plane - true_rel_alpha;

%clockbias = clockbias';
end
