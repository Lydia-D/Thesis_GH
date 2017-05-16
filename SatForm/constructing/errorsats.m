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
error_loc = @(testdis,dis_diff) 2.*testdis.*sin(dis_diff./(2.*rs)); 

%% distance of sat from extreme fov (160deg)
dis = (rs+alt)*sind(80-asind(rs*sind(100)/(rs+alt)))/sind(100);




