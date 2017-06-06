%% Epoch analysis Algorithm
% 7/6/17
%clc
close all
clear
addpath('./fromspace3')
plotyes = 1;
dt = 0.01; % seconds
days = 1;
T_equ = 7347737.336;
%ClassPara =  [Rasc;omega;inc;a;e;M0,t0];        
load GPSsat_ephem
ClassPara = [deg2rad(Rasc)';deg2rad(omega)';deg2rad(inc)';a';e';deg2rad(M0)';t0']; % for all 31 sats
constants();
timevec = 0;

%% Location of alpha recevier and what satellites are in view
GS_LLH = [-deg2rad(30);deg2rad(0);0];
GS_ECEF = llhgc2ecef(GS_LLH);  % global

%% errors
%power = [-3:1:5];
power_dis = 0; % 10 m?
index_dis = 1;

error_var_power = 10:-1:0;

% second receiver NED then transform - use as config(:,i)
numRec = 2;
Rconfig = [1,0,0;
          0,1,0;
          0,0,1;
          -1,0,0;
          0,-1,0;
          0,0,-1]';
      
alpha = [0;0;0];
beta = Rconfig(:,1);

%% difference in time -> be fn of this?
%Sat_timeoffset = [0:0.1:1];
timeadjust = [0:0.1:1];
Sat_timeoffset = [0,0];
%Rec_sampleoffset = linspace(0,1,numRec); 
%%
% index_error = 1:length(error_var_power)
index_error = 1;

for index_time = 1:length(timeadjust)
    Sat_timeoffset = [0,timeadjust(index_time)];
    
    Rec_displacement = 10^power_dis(index_dis).*[alpha,beta];
    Rec_ecef_local = lg2ecef(Rec_displacement,GS_LLH);
    allRec = GS_ECEF*ones(1,numRec)+Rec_ecef_local;
    true_rel_alpha = Rec_displacement(:,2:end)-repmat(Rec_displacement(:,1),[1,numRec-1]);

    % errors
    Estruc.satmag = 0*10^-error_var_power(index_error);
    Estruc.recmag = 0*10^-error_var_power(index_error);
    Estruc.random = 0*10^-error_var_power(index_error);

% may need statistical analysis later to combination here

% calculate position of sats (recevier clock bias doesnt matter)
    [~,X_ECEFreal,~] = keplerorbit3D(ClassPara,Sat_timeoffset',T_equ);
    Sats_all_ECEF = squeeze(X_ECEFreal(:,1,:));
    
    % identify visible sats
    [VisibleSat,VisSat_LG_pol,VisibleSat_index] = ID_vis_sats(Sats_all_ECEF,GS_LLH);
    numSat = size(VisibleSat,2);
    X_ECEF_real_vis = X_ECEFreal(:,:,VisibleSat_index);
    
    %% PA

    [allerror(:,index_time),clockbias,range_error] = fn_planeepoch_diff(GS_LLH,GS_ECEF,numSat,numRec,allRec,X_ECEF_real_vis,Estruc,true_rel_alpha);




% compare to NLLS
    for irec = 1:numRec
    [NLLS_abs_ecef_global(:,irec),~,~,~] = convergance([GS_ECEF;0],squeeze(X_ECEF_real_vis(:,irec,:)),range_error(irec,:)');
    end
    
    % convert to local NED
    NLLS_abs_ecef_local = vectoradd(NLLS_abs_ecef_global,GS_ECEF,-1);
    NLLS_abs_ned = ecef2lg(NLLS_abs_ecef_local,GS_LLH); % local
    % take relative distance for two rec
    NLLS_rel_ned = vectoradd(NLLS_abs_ned(:,2:end),NLLS_abs_ned(:,1),-1);
    % error
    NLLS_error_ned(:,index_time) = NLLS_rel_ned - true_rel_alpha;

    
    
%    avg_error(:,index_error) = mean(allerror,2);
%    std_dev(:,index_error) = std(allerror,0,2); % use N-1 (0) or N (1)? in second field

 %   NLLS_avg_error(:,index_error) = mean(NLLS_error_ned,2);
  %  NLLS_std_error(:,index_error) = std(NLLS_error_ned,0,2);
    
    
end

%% plotting

figure(1)
clf
plot(timeadjust,magc(allerror),'bo-')
hold on
grid on
plot(timeadjust,magc(NLLS_error_ned),'ko-')
xlabel('Difference between satellite sent times for two receviers (s)')
ylabel('Total Error (m)')
legend('PA','NLLS')