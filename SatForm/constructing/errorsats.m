%% analysing error in normal vector based on timing errors
clear

G = 6.67*10^-11;
m = 5.98*10^24;
alt = 20180000;
rs = 6.38*10^6 + alt;

vs = sqrt(G*m/rs);

%error=@(d,c) 2*d*sin(vs*c/(2*rs));
% small angle approx
% d is the distance from the point of normal vector, displacement of plane
% at d length away
% c is the timing bias (accuracy of 10^-6 receivers, acc of 10^-9 sats)
% (from space3 lectures)
error_time=@(testdis,c) testdis*c*sqrt(G*m/rs^3); % or d*vs*c/rs -> linearly proportional to c and d



%% analysing error in normal vector based on location error
% worst case directly above

%delta = dis_diff/rs;   %2*asin(d/(2*rs));
%error_loc = @(testdis,dis_diff) 2.*testdis.*sin(dis_diff./(2.*rs)); 
error_loc = @(testdis) 2.*testdis.^2/20000000;
figure(1)
plot([0:0.1:10000],error_loc([0:0.1:10000]))
grid on

%% distance of sat from extreme fov (160deg)
dis = (rs+alt)*sind(80-asind(rs*sind(100)/(rs+alt)))/sind(100);


%% calculate difference between time taken and the epoch common time
% and the direction vector between satellite times
addpath('../fromspace3','..')
load GPSsat_ephem
ClassPara = [deg2rad(Rasc)';deg2rad(omega)';deg2rad(inc)';a';e';deg2rad(M0)';t0']; % for all 31 sats
T_equ = 7347737.336;

GS_LLH = [-deg2rad(33);deg2rad(151);0];

t1 = 0; % at epoch
t2 = 1; % in seconds after t1
[X_ECIstore,X_ECEFstore,X_LLHGCstore] = keplerorbit3D(ClassPara,[t1;t2],T_equ);
[VisibleSat1,~] = ID_vis_sats(squeeze(X_ECEFstore(:,1,:)),GS_LLH);
[VisibleSat2,~] = ID_vis_sats(squeeze(X_ECEFstore(:,2,:)),GS_LLH);


%sat_diff = squeeze(X_ECEFstore(:,1,:)) - squeeze(X_ECEFstore(:,2,:));

%sat_mag = sqrt(sum((sat_diff).^2,1));
% pseudorange difference between the two points in thime from point on
% earth. 
X_alpha_ECEF = llhgc2ecef(GS_LLH);  % global
range1 = VisibleSat1-X_alpha_ECEF*ones(1,size(VisibleSat1,2));
range2 = VisibleSat2-X_alpha_ECEF*ones(1,size(VisibleSat2,2));
diff_range = range1-range2
sat_mag = sqrt(sum((diff_range).^2,1));

