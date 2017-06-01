
function error_alpha = fn_planeepoch(GS_LLH,GS_ECEF,numSat,numRec,allRec,allSat,Estruc,true_rel_alpha)
%% TO DO:
% make this code into epoch manipulation.
% how to pretend the sats are moving in orbit?






%% Calculate range and add errors

range_error = rangesim(allRec,allSat,Estruc);

%% Find Relative positions
[Loc_lin,clockbias] = planarsolve_epoch(range_error,allSat,numRec, GS_ECEF);
Receivers_LG = ecef2lg(Loc_lin',GS_LLH); % NED cartesion row is rec col is xyz

Loc_plane = vectoradd(Receivers_LG(:,2:end),Receivers_LG(:,1),-1);
%Receivers_LG = ecef2lg(Loc_plane',GS_LLH); % NED cartesion row is rec col is xyz

%% Evaluate
error_alpha = Loc_plane- true_rel_alpha;

end
