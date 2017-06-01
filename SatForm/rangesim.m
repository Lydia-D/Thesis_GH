function range_error = rangesim(allRec,allSat,Estruc)
    global c
% allRec = matrix of receiver locations in ECEF 3 by numRec
% allSat = matrix of satellite locations in ECEF 3 by numSat


% errorstruct: magnitude of error in seconds
%     .tropo = troposphere 
%     .isoph = ionosphere
%     .satcb = clock bias from satellite
%     .reccb = receiver clock bias
% controlled error: 
%     .satmag = satellite correlated *10^-6
%     .recmag = recevier correlated *10^-6
%     .random = uncorrelated error

%% need to create a fn that calculates range and simulates error
% all_range = matrix m receivers by n satellites
numRec = size(allRec,2);
numSat = size(allSat,2);
all_range = []; % columns = each satellite: rows = between each receiver
for isat=1:numSat
    all_range = [all_range,calcrange(allRec,allSat(:,isat))];
end

Sat_error = Estruc.satmag+ Estruc.satmag*10*rand([1,numSat]);
Rec_error = Estruc.recmag+ Estruc.recmag*10*rand([numRec,1]);
Rand_error = Estruc.random+Estruc.random*10*rand([numRec,numSat]);
range_error = all_range + Rand_error*c + c*Rec_error*ones(1,numSat) + c*ones(numRec,1)*Sat_error;


end