%% L Drabsch

% compare to NLLS with exact same data
% comapre computation time
% statistical analysis
% monte carlo - run 50 times get mean and std of the errors for different
% types

clear
clc
close all
addpath('./fromspace3')
constants();
%% approximate location
GS_LLH = [-deg2rad(33);deg2rad(151);0]; % sydney
GS_ECEF = llhgc2ecef(GS_LLH);  % global


%% Location of receivers

% numRec = 5;
% Rec_dispersion = 10; % in meters, how far apart to have the receivers
% Rec_displacement = Rec_dispersion*rand([3,numRec-1]);
numRec = 2;
Rec_displacement = [0,10;0,0;0,0];
%Rec_displacement = 100*[5,0,10,0,2;0,10,0,0,5;0,0,0,10,-10];   % use NED coords
Rec_ecef_local = lg2ecef(Rec_displacement,GS_LLH);
allRec = GS_ECEF*ones(1,numRec)+Rec_ecef_local;
true_rel_alpha = Rec_displacement(:,2:end)-repmat(Rec_displacement(:,1),[1,numRec-1]);
%allRec = allRec';


%% Location of Satellites
% how to pretend they're moving?
% assume they're all moving to the centre?

el = deg2rad([30,80,55,42]);
az = [pi/2+0.01,0,pi,3*pi/2];
[x,y] = polar2plot(az,el);
polarfig = PolarPlot();
hold on
scatter(x,y)

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
Estruc.satmag = 10^-7;
Estruc.recmag = 10^-6;      
Estruc.random = 10^-9;
range_error = rangesim(allRec,allSat,Estruc);

%% Find Relative positions
[Loc_lin,clockbias] = planarsolve(range_error,allSat,numRec, GS_ECEF);
Receivers_LG = ecef2lg(Loc_lin',GS_LLH); % NED cartesion row is rec col is xyz

Loc_plane = vectoradd(Receivers_LG(:,2:end),Receivers_LG(:,1),-1);
%Receivers_LG = ecef2lg(Loc_plane',GS_LLH); % NED cartesion row is rec col is xyz
%Loc_plane = Loc_plane(:,2:end) -Loc_plane(:,1)*ones(1,numRec-1);
%% Evaluate
error_alpha = Loc_plane- true_rel_alpha





