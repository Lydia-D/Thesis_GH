%% Test Algorithm
% 16/5/17
clc
% alpha frame (km)
SatA = [6000,0,-18000];
SatB = [-7000,-2000,-17000];
SatC = [-23000,-6000,-2000];
SatD = [24000,0,-5000];
SatE = [-8000,-8000,-17000];
allSats = [SatA;SatB;SatC;SatD;SatE];


alpha = [0,0,0];
beta = [1,-1,1];
gamma = [5,1,5];
allRec = [alpha;beta;gamma];
allRec_e = allRec+rand(3)*0.1;
numSat = 5;
numRec = 3;


%% need to create a fn that calculates range and simulates error
% all_range = matrix m receivers by n satellites
all_range = []; % columns = each satellite: rows = between each receiver
for isat=1:numSat
    all_range = [all_range,calcrange(allRec,allSats(isat,:))+rand(3,1)*0.5];
end

%% NLLS
%[X,DOP,clockbias]
[X1,~,~] = convergance([0;0;0;0],allSats',all_range(1,:)');
[X2,~,~] = convergance([0;0;0;0],allSats',all_range(2,:)');
[X3,~,~] = convergance([0;0;0;0],allSats',all_range(3,:)');

% not include clock bias
Rec_abs = [X1(1:3)';X2(1:3)';X3(1:3)']
Rec_relative = Rec_abs(2:3,:)-ones(2,1)*Rec_abs(1,:)
%% Optimise
[Loc_lin,Omega,avg_norm] = distopt(all_range,allSats, Rec_abs);
Loc_lin



