clear
close all
clc

% alpha frame (km)
SatA = [6000,0,-18000];
SatB = [-7000,0,-17000];
SatC = [-23000,0,-2000];
SatD = [24000,0,-5000];
SatE = [-8000,-8000,-17000];
alpha = [0,0,0];
beta = [0.1,-0.1,0.1];
gamma = [0.05,0.1,-0.05];

allSats = [SatA;SatB;SatE];
% create plane at alpha with normal SatA-alpha
n = ones(size(allSats,1),1)*alpha-allSats;
n_norm = normalise(n);
% find distance along vector from sats
r = beta-alpha;
dis = dotm(r,n_norm);

alphaplane = findplane(n,alpha,zeros(size(allSats,1),1));
betaplane = findplane(n,alpha,dis);
%gammaplane = findplane(n,alpha,dotm(gamma-alpha,n_norm));

plotplane(betaplane,1);
plotplane(alphaplane,1);
%plotplane(gammaplane,1);
plot3(beta(1),beta(2),beta(3),'ko')
plot3(gamma(1),gamma(2),gamma(3),'kx')

grid on;

%% next to do:
% fix github/ update matlab?
% see if there are memory errors with your code?

% check the rotation of the earth error- what do you need to do for that?

% create optimisation algorithm
%  - cost fn -> residuals
%  - how to express time error
%  - what variables are you minimising?-> cost-> find (x,y,z) coordinates of receivers 
%  - need to analyse and present RELATIVE data
%  -  

% implement errors
%  - noise
%  - timing
%  - sat location
%  - movement? error in measurement if receiver is moving while receiving
%  radio signal?

%% develop residual cost fn
% ONE REFERENCE
% - coordinates for [x,y,z] for each receiver expect for the reference 
% sum(perpendicular distance between guess [x,y,x](i) and plane(ij) where i
% is receiver i and j is the plane from satellite j
% known: [A B C D](ij) which descibes the normal vector perpendicular to
% the plane(ij) - need perpendicular distance from plane

dis = costresidual(betaplane,alpha);

%[x,y,z] = meshgrid(-0.2:0.05:0.2,-0.2:0.05:0.2,-0.2:0.05:0.2);
[x,y] = meshgrid(-0.2:0.05:0.2,-0.2:0.05:0.2,-0.2:0.05:0.2);



