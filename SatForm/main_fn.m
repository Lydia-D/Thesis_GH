%% L Drabsch
% main using fn_planeepoch

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
%allRec = allRec';

%% Location of Satellites
% how to pretend they're moving?
% assume they're all moving to the centre?
load VisibleSat

numSat = 10;
%el = deg2rad([30,80,55,42]);
%az = [pi/2+0.01,0,pi,3*pi/2];
[x,y] = polar2plot(VisSat_LG_pol(2,:),VisSat_LG_pol(3,:));
polarfig = PolarPlot();
hold on
scatter(x,y)

% location of satellites at t = 0
%allSat = sat_ned2ecef(el,az,GS_LLH); % global frame
allSat = VisibleSat;
% make them move

timevec = 0;
plotyes = 0;
if plotyes ==1
    animation3Dearth;
    hold on
    scatter3(allSat(1,:),allSat(2,:),allSat(3,:))
end
%% errors
power = [0:1:5];
error_var_power = 10:-1:0;
j=1;

for j = 1:length(power)
    Rec_displacement = 10^power(j).*[0,1;0,0;0,0];
    %Rec_displacement = [0,10;0,0;0,0];   % use NED coords
    Rec_ecef_local = lg2ecef(Rec_displacement,GS_LLH);
    allRec = GS_ECEF*ones(1,numRec)+Rec_ecef_local;
    true_rel_alpha = Rec_displacement(:,2:end)-repmat(Rec_displacement(:,1),[1,numRec-1]);

    
    
    Estruc.satmag = 0*10^-error_var_power(j);
    Estruc.recmag = 0*10^-error_var_power(j);
    Estruc.random = 0*10^-error_var_power(j);
    
    
%% statistical analysis - one rec
total_iter = 1;
allerror = zeros(3,total_iter,numRec-1);  % NEED TO STRUCTURE FOR MORE REC
for i = 1:total_iter
    allerror(:,i) = fn_planeepoch(GS_LLH,GS_ECEF,numSat,numRec,allRec,allSat,Estruc,true_rel_alpha);
end

%% error analysis
avg_error(:,j) = mean(allerror,2);
std_dev(:,j) = std(allerror,0,2); % use N-1 (0) or N (1)? in second field
end

%%
figure(2)
clf
xplot = 10.^power;
loglog(xplot,magc(avg_error),'b')
grid on
hold on
loglog(xplot,magc(avg_error)+magc(std_dev),'--b')
%loglog(xplot,magc(avg_error)-magc(std_dev),'--b')
xlabel('Distance between receviers (meters)')
ylabel('Solution error (meters)')
title('Error due to plane assumption')


% figure(3)
% clf
% semilogx(xplot,magc(avg_error),'b')
% grid on
% hold on
% semilogx(xplot,magc(avg_error)+magc(std_dev),'--b')
% semilogx(xplot,magc(avg_error)-magc(std_dev),'--b')
% xlabel('Magnitude of induced error (seconds)')
% ylabel('Solution error (meters)')
% title('Satellite Error')

% errorbar(xplot,magc(avg_error),magc(std_dev))

