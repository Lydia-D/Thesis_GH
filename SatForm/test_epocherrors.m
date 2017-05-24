%% Test Algorithm
% 16/5/17
%clc
close all
clear
addpath('./fromspace3')
plotyes = 0;
dt = 0.01; % seconds
days = 1;
T_equ = 7347737.336;
%ClassPara =  [Rasc;omega;inc;a;e;M0,t0];        
load GPSsat_ephem
ClassPara = [deg2rad(Rasc)';deg2rad(omega)';deg2rad(inc)';a';e';deg2rad(M0)';t0']; % for all 31 sats


%% location of satellites
constants();
timevec = 0;
[X_ECIstore,X_ECEFstore,X_LLHGCstore] = keplerorbit3D(ClassPara,timevec',T_equ);

%% Location of alpha recevier and what satellites are in view
GS_LLH = [-deg2rad(33);deg2rad(151);0];
X_alpha_ECEF = llhgc2ecef(GS_LLH);  % global
Sats_all_ECEF = squeeze(X_ECEFstore(:,1,:));

[VisibleSat,VisSat_LG_pol,VisibleSat_index] = ID_vis_sats(Sats_all_ECEF,GS_LLH);
%% edit how many sats were picked up
allSats = VisibleSat(:,:)'; %3 by numSat

numSat = size(allSats,1);

if plotyes ==1
    animation3Dearth;
    hold on
    scatter3(allSats(:,1),allSats(:,2),allSats(:,3))
end


%% True locations of all receviers
numRec = 5;
Rec_dispersion = 100; % in meters, how far apart to have the receivers
Rec_displacement = Rec_dispersion*rand([3,numRec-1]);
%numRec = 2;
%Rec_displacement = [0;0;10000];
allRec = [X_alpha_ECEF,X_alpha_ECEF*ones(1,numRec-1)+Rec_displacement];
allRec = allRec';

%% Sample times of receivers -> 
% to do : get position of all sats at these time; get index of visible
% satellites
% range from 1 to length(timevec)
%Rec_sampleoffset = rand([1 numRec]);
%Rec_sampleoffset = zeros([1 numRec]);
Rec_sampleoffset = linspace(0,1,numRec);
clockbias_rec = 10^(-6)+10^(-7)*rand([1,numRec]);
Rec_timeoffset = Rec_sampleoffset+clockbias_rec;

% true time 0.6s
% thinks its 0.6s because 0.1s clock bias

% Measured range
[~,X_ECEFstore,~] = keplerorbit3D(ClassPara,Rec_timeoffset',T_equ);

% true range -> no clockbias ->

% (xyz,time,sat)
X_ECEF_vis = X_ECEFstore(:,:,VisibleSat_index);

%% need to create a fn that calculates range and simulates error
% all_range = matrix m receivers by n satellites
range_error = []; % columns = each satellite: rows = between each receiver

Tropo = (2.5+1*rand([1,numSat]))/c; % ~0.5 m of error
Isoph = (7+3*rand([1,numSat]))/c; % ~5 m of errror (time = 5/c)
 % relativistic error?
clockbias_sat = (1.5+0.5*rand([1,numSat]))/c;
sat_error_time = Tropo+Isoph+clockbias_sat ;

for irec = 1:numRec
    for isat=1:numSat
       % trans_time = 
        range_inc_error = sqrt(sum((allRec(irec,:)'-X_ECEF_vis(:,irec,isat)).^2)) + sat_error_time(isat)*c;
 %       range_inc_error = sqrt(sum((allRec(irec,:)'-X_ECEF_vis(:,irec,isat)).^2));
        range_error(irec,isat) = range_inc_error;
    end
end
% add constant error (based on time) for each satellite based on time
% in seconds 1 by numSats

  %(1+0.5*rand([numRec,1]))/c; % microsecond errors

range_error2 = range_error+0*rand(size(range_error)) - c*clockbias_rec'*ones(1,numSat);


%% NLLS
%[X,DOP,clockbias]
%tic
% for i = 1:numRec
%     [Rec_abs(:,i),DOP,calc_clockbias(i,1)] = convergance([X_alpha_ECEF;0],allSats',range_error(i,:)');
% end
%toc
% Rec_abs = Rec_abs(1:3,:)';% not include clock bias

%Rec_abs = [X1(1:3)';X2(1:3)';X3(1:3)']
% Rec_relative = Rec_abs(2:numRec,1:3)-ones(numRec-1,1)*Rec_abs(1,1:3);
% Rec_absolute_error = Rec_abs - allRec;
%% Optimise
% [Loc_lin,Ome  ga,avg_norm] = distopt(range_error-calc_clockbias*ones(1,numSat),allSats, Rec_abs);
%[Loc_lin,Omega,avg_norm] = distopt(range_error,allSats, Rec_abs);
%tic

%[Loc_lin,clockbias] = alloptimise(range_error,allSats, Rec_abs);
[Loc_lin,clockbias] = alloptimise_transepoch(range_error2,allSats, X_alpha_ECEF',X_ECEF_vis,numRec);



% change ranges according to clockbias
%updaterange = clockbias'*ones(1,numSat) + range_error;
%[Loc_lin2,clockbias2] = alloptimise(updaterange,allSats,Rec_abs);

%toc
Loc_plane = Loc_lin(2:end,:)-ones(numRec-1,1)*Loc_lin(1,:);
Receivers_LG = ecef2lg(Loc_plane',GS_LLH); % NED cartesion row is rec col is xyz

%% plot local results - alpha is (0,0,0)
[Sat_LG_pol,Sat_LG_cart] = ecef2lg_pol(Sats_all_ECEF,GS_LLH);

%figure(2)
%scatter3([0,Receivers_LG(1,:)],[0,Receivers_LG(2,:)],[0,Receivers_LG(3,:)],'b');
%hold on
%scatter3(Sat_LG_cart(1,:),Sat_LG_cart(2,:),Sat_LG_cart(3,:),'bx');

True = Rec_displacement';
%% calc error
Error_plane = abs(Loc_plane-True)
%Error_nlls = abs(Rec_relative-True)
%DOP