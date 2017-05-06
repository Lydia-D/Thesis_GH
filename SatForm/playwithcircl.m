%% parameters
Aa = 3;
Ab = 4;
Ba = 4;
Bb = 3;
AB = sqrt(Aa^2+Ba^2);
Ca = sqrt(8^2+3^2);
Cb = 4;

circpol = @(r0,phi,r,theta) r^2+r0^2-2*r*r0*cosd(theta-phi);
syms x y
%circplot = @(x0,y0,r) ezplot((x-x0)^2 + (y-y0)^2 - r^2);

figure(1)
clf
circplot(0,0,Aa);
axis([-4 12 -8 8])
hold on
hAb = circplot(0,0,Ab);
set(hAb,'Color','r')
circplot(4,-3,Ba);
hBb = circplot(4,-3,Bb);
set(hBb,'Color','r')
circplot(8,0,Ca);
hCb = circplot(8,0,Cb);
set(hCb,'Color','r')


grid on;
axis equal;

%theta = [0:0.1:2*pi];
% y = circpol(AB,-20,Ba,theta);

% polar(theta,-4*cos(theta))

