load epochErrors
power = [0:1:5];
x = 10.^power;

northtot = sqrt(sum(error_north(1,:).^2+error_north(2,:).^2+error_north(3,:).^2,1));
easttot = sqrt(sum(error_east(1,:).^2+error_east(2,:).^2+error_east(3,:).^2,1));
downtot = sqrt(sum(error_down(1,:).^2+error_down(2,:).^2+error_down(3,:).^2,1));
close all
loglog(x,northtot,'LineWidth',2)
hold on
loglog(x,easttot,'LineWidth',2);
loglog(x,downtot,'LineWidth',2);
legend('North','East','Down')
xlabel('Distance between receviers (m)')
ylabel('Total error in relative distance')
title('Error due to epoch synchronisation')
grid on


% figure(1)
% loglog(x,abs(error_north(1,1:end-1)));
% hold on
% loglog(x,abs(error_north(2,1:end-1)))
% loglog(x,abs(error_north(3,1:end-1)))
% legend('north error','east error','down error')
% title('north')
% 
% figure(2)
% loglog(x,abs(error_east(1,1:end-1)));
% hold on
% loglog(x,abs(error_east(2,1:end-1)))
% loglog(x,abs(error_east(3,1:end-1)))
% legend('north error','east error','down error')
% title('east')
% 
% figure(3)
% loglog(x,abs(error_down(1,1:end-1)));
% hold on
% loglog(x,abs(error_down(2,1:end-1)))
% loglog(x,abs(error_down(3,1:end-1)))
% legend('north error','east error','down error')
% title('north')