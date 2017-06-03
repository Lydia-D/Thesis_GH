%% L Drabsch
clear
clc
close all
addpath('./fromspace3')
constants();
%% approximate location
GS_LLH = [-deg2rad(33);deg2rad(151);0]; % sydney
GS_ECEF = llhgc2ecef(GS_LLH);  % global

%% TO DO:
% make this code into epoch manipulation.
% how to pretend the sats are moving in orbit?

%% Location of receivers

% numRec = 5;
% Rec_dispersion = 10; % in meters, how far apart to have the receivers
% Rec_displacement = Rec_dispersion*rand([3,numRec-1]);
numRec = 2;
Rec_displacement = [0,10;0,0;0,0];   % use NED coords
Rec_ecef_local = lg2ecef(Rec_displacement,GS_LLH);
allRec = GS_ECEF*ones(1,numRec)+Rec_ecef_local;
true_rel_alpha = Rec_displacement(:,2:end)-repmat(Rec_displacement(:,1),[1,numRec-1]);
%allRec = allRec';


%% Location of Satellites
% how to pretend they're moving?
% assume they're all moving to the centre?

% controlled sats
el = deg2rad([30,80,55,42]);
az = [pi/2+0.01,0,pi,3*pi/2];
[x,y] = polar2plot(az,el);
polarfig = PolarPlot();
hold on
scatter(x,y)

% GPS constellations
days = 1;
T_equ = 7347737.336;
load GPSsat_ephem
ClassPara = [deg2rad(Rasc)';deg2rad(omega)';deg2rad(inc)';a';e';deg2rad(M0)';t0']; % for all 31 sats


% location of satellites at t = 0
allSat = sat_ned2ecef(el,az,GS_LLH); % global frame
% make them move


timevec = 0;
plotyes = 1;
if plotyes ==1
    animation3Dearth;
    hold on
    scatter3(allSat(1,:),allSat(2,:),allSat(3,:))
end


%% Calculate range and add errors
Estruc.satmag = 0*10^-7;
Estruc.recmag = 0*10^-5;
Estruc.random = 0*10^-9;
range_error = rangesim(allRec,allSat,Estruc);

%% Find Relative positions
[Loc_lin,clockbias] = planarsolve_epoch(range_error,allSat,numRec, GS_ECEF);
Receivers_LG = ecef2lg(Loc_lin',GS_LLH); % NED cartesion row is rec col is xyz

Loc_plane = vectoradd(Receivers_LG(:,2:end),Receivers_LG(:,1),-1);
%Receivers_LG = ecef2lg(Loc_plane',GS_LLH); % NED cartesion row is rec col is xyz

%% Evaluate
error_alpha = Loc_plane- true_rel_alpha


