%% Test Algorithm
% 16/5/17
clc
close all
clear
addpath('./fromspace3')
plotyes = 0;
dt = 0.1; % seconds
days = 1;
T_equ = 7347737.336;
%ClassPara =  [Rasc;omega;inc;a;e;M0,t0];        
load GPSsat_ephem
ClassPara = [deg2rad(Rasc)';deg2rad(omega)';deg2rad(inc)';a';e';deg2rad(M0)';t0']; % for all 31 sats


%% location of satellites
constants();
timevec = 0:dt:5;
[X_ECIstore,X_ECEFstore,X_LLHGCstore] = keplerorbit3D(ClassPara,timevec',T_equ);

%% Location of alpha recevier and what satellites are in view
GS_LLH = [-deg2rad(33);deg2rad(151);0];
X_alpha_ECEF = llhgc2ecef(GS_LLH);  % global
Sats_all_ECEF = squeeze(X_ECEFstore(:,1,:));

VisibleSat = ID_vis_sats(Sats_all_ECEF,GS_LLH);
%% edit how many sats were picked up
allSats = VisibleSat(:,:)';

numSat = size(allSats,1);

if plotyes ==1
    animation3Dearth;
    hold on
    scatter3(allSats(:,1),allSats(:,2),allSats(:,3))
end


%% True locations of all receviers
numRec = 4;
Rec_dispersion = 10000; % in meters, how far apart to have the receivers
Rec_displacement = Rec_dispersion*rand([3,numRec-1]);
allRec = [X_alpha_ECEF,X_alpha_ECEF*ones(1,numRec-1)+Rec_displacement];
allRec = allRec';


%% need to create a fn that calculates range and simulates error
% all_range = matrix m receivers by n satellites
all_range = []; % columns = each satellite: rows = between each receiver
for isat=1:numSat
    all_range = [all_range,calcrange(allRec,allSats(isat,:))];
end
% add constant error (based on time) for each satellite based on time
% in seconds 1 by numSats
Tropo = (2.5+1*rand([1,numSat]))/c; % ~0.5 m of error
Isoph = (7+3*rand([1,numSat]))/c; % ~5 m of errror (time = 5/c)
 % relativistic error?
clockbias_sat = (1.5+0.5*rand([1,numSat]))/c;
sat_error_time = Tropo+Isoph+clockbias_sat ;
clockbias_rec = (1+0.5*rand([numRec,1]))/c; % microsecond errors

range_error = all_range+0*rand(size(all_range)) - 10*c*clockbias_rec*ones(1,numSat) + 10*c*ones(numRec,1)*sat_error_time;


%% NLLS
%[X,DOP,clockbias]
for i = 1:numRec
    [Rec_abs(:,i),~,calc_clockbias(i,1)] = convergance([0;0;0;0],allSats',range_error(i,:)');
end
Rec_abs = Rec_abs(1:3,:)';% not include clock bias

%Rec_abs = [X1(1:3)';X2(1:3)';X3(1:3)']
Rec_relative = Rec_abs(2:numRec,1:3)-ones(numRec-1,1)*Rec_abs(1,1:3)
Rec_absolute_error = Rec_abs - allRec
%% Optimise
% [Loc_lin,Omega,avg_norm] = distopt(range_error-calc_clockbias*ones(1,numSat),allSats, Rec_abs);
%[Loc_lin,Omega,avg_norm] = distopt(range_error,allSats, Rec_abs);
[Loc_lin,Omega,avg_norm] = alloptimise(range_error,allSats, Rec_abs);

Loc_lin
Rec_displacement'
