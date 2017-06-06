%% L Drabsch
% main using fn_planeepoch

clear
%clc
close all
addpath('./fromspace3')
constants();
%% approximate location
%GS_LLH = [-deg2rad(-33);deg2rad(151);0]; % sydney
GS_LLH = [deg2rad(0);0;0];
%GS_LLH = [-deg2rad(90);deg2rad(0);0]; % sydney
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
%load VisibleSat

numSat = 10;

elset = 75;
%Sconfig_el = [20,21,19,20];
%Sconfig_el = [elset,elset+1,elset-1,elset+2,elset-2];
%Sconfig_el = [elset-2,elset+2,elset-2,elset+2,elset];
Sconfig_el = [45,20,20,20];
   
% range from 0 to 2pi
%azset = linspace(0,2*pi-0.01,20);
azset = 0;
%Sconfig_az = [pi/4,3*pi/4,5*pi/4,7*pi/4];
%Sconfig_az = [pi/4-0.2,pi/4,pi/4-0.1,pi/4+0.1,pi/4+0.2];
%Sconfig_az = [azset-2,azset-2,azset+2,azset+2,azset];
Sconfig_az = [41,48,69,45];

%Sconfig_az = [1,pi/2-1,pi-1,3*pi/2+1];

el = deg2rad(Sconfig_el);
az = deg2rad(Sconfig_az);
[x,y] = polar2plot(az,el);
%[x,y] = polar2plot(VisSat_LG_pol(2,:),VisSat_LG_pol(3,:));


% location of satellites at t = 0
allSat = sat_ned2ecef(el,az,GS_LLH); % global frame
%allSat = VisibleSat;
% make them move

timevec = 0;
plotyes = 0;
if plotyes ==1
    animation3Dearth;
    hold on
    scatter3(allSat(1,:),allSat(2,:),allSat(3,:))
end
%% errors
power = [-3:1:5];
error_var_power = 10:-1:0;
j=10;

% second receiver NED then transform - use as config(:,i)
Rconfig = [1,0,0;
          0,1,0;
          0,0,1;
          -1,0,0;
          0,-1,0;
          0,0,-1]';

      
alpha = [0;0;0];
beta = Rconfig(:,1);
%% plot receiver configuration - 0 is approximate location
figure(1)
ned2xyz = [1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,0];

subplot(221)
plotrec([alpha,beta],gcf)
ax = gca;
%text(0,0,'Receiver and Satellite Configuration\n from Approximate Location')
subplot(223);
subplot('position',[0.05,0.05,0.45,0.45])
scatter(x,y)
hold on
polarfig = PolarPlot(gcf,0.65);

     %% 
for j = 1:length(power)
    Rec_displacement = 10^power(j).*[[0;0;0],beta];
    %Rec_displacement = [0,10;0,0;0,0];   % use NED coords
    Rec_ecef_local = lg2ecef(Rec_displacement,GS_LLH);
    allRec = GS_ECEF*ones(1,numRec)+Rec_ecef_local;
    true_rel_alpha = Rec_displacement(:,2:end)-repmat(Rec_displacement(:,1),[1,numRec-1]);

    
    
    Estruc.satmag = 1*10^-error_var_power(10);
    Estruc.recmag = 0*10^-error_var_power(10);
    Estruc.random = 0*10^-error_var_power(10);
    
    
%% statistical analysis - one rec
total_iter = 1;
allerror = zeros(3,total_iter,numRec-1);  % NEED TO STRUCTURE FOR MORE REC
for i = 1:total_iter
%    [allerror(:,i),clockbias(:,j)] = fn_planeepoch(GS_LLH,GS_ECEF,numSat,numRec,allRec,allSat,Estruc,true_rel_alpha);
    [allerror(:,i),clockbias(:,j),allerror_NC(:,j)] = fn_planeepoch(GS_LLH,GS_ECEF,numSat,numRec,allRec,allSat,Estruc,true_rel_alpha);

end

%% error analysis
avg_error(:,j) = mean(allerror,2);
std_dev(:,j) = std(allerror,0,2); % use N-1 (0) or N (1)? in second field
    if j == 6 % displacement = 100
        
    end
    
end

%%

subplot(2,2,2)
xplot = 10.^power;
loglog(xplot,magc(avg_error),'bo-')
grid on
hold on
loglog(xplot,magc(allerror_NC),'ro-')
legend('solve with clockbias','solve without clockbias','Location','best')
%loglog(xplot,magc(avg_error)+magc(std_dev),'--b')
%loglog(xplot,magc(avg_error)-magc(std_dev),'--b')
xlabel('Distance between receviers (meters)')
ylabel('Solution error (meters)')
title('Total Error due to Plane Assumption')

%%

subplot(2,2,4)
loglog(xplot,abs(avg_error(1,:)),'ro-') % north error
hold on
loglog(xplot,abs(avg_error(2,:)),'ko-') % east error
loglog(xplot,abs(avg_error(3,:)),'bo-') % down error
loglog(xplot,abs(clockbias(2,:)-clockbias(1,:)),'mx-')
grid on
xlabel('Distance between receviers (meters)')
ylabel('Solution error (meters)')
title('Component Error due to Plane Assumption')
legend('North Error','East Error','Down Error','Clockbias','Location','best')




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

